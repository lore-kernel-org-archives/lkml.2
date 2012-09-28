Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758463Ab2I1PaZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 11:30:25 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:54704 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758306Ab2I1PaY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 11:30:24 -0400
Date: Fri, 28 Sep 2012 17:29:59 +0200
From: Davide Ciminaghi <ciminaghi@gnudd.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>, sameo@linux.intel.com,
        rubini@gnudd.com, giancarlo.asnaghi@st.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] sta2x11-mfd : add apb-soc regs driver and factor out common code
Message-ID: <20120928152959.GM22500@mail.gnudd.com>
References: <1347445374-32140-1-git-send-email-ciminaghi@gnudd.com> <1347445374-32140-2-git-send-email-ciminaghi@gnudd.com> <20120925192048.GA17038@sirena.org.uk> <20120926145615.GJ10147@mail.gnudd.com> <20120926150429.GQ4428@opensource.wolfsonmicro.com> <20120926163145.GK10147@mail.gnudd.com> <20120926164932.GS4428@opensource.wolfsonmicro.com> <20120927134110.GD6799@mail.gnudd.com> <20120927151314.118c86c1@pyramind.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120927151314.118c86c1@pyramind.ukuu.org.uk>
X-Face: #Q;A)@_4.#>0+_%y]7aBr:c"ndLp&#+2?]J;lkse\^)FP^Lr5@O0{)J;'nny4%74.fM'n)M
	>ISCj.KmsL/HTxz!:Ju'pnj'Gz&.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2012 at 03:13:14PM +0100, Alan Cox wrote:
> > as far as I know, nested locks are fine provided that you always take them in
> > the same order and release them in the opposite order (lock A, lock B,
> > unlock B, unlock A). So my conclusion is that nested spinlocks require
> > potential regmap users of sta2x11 registers to take the sta2x11-mfd spinlock
> > first. The pattern would be (sctl registers for instance):
> 
> The release order does not matter. Taking AB and releasing AB or BA is
> fine. Taking AB and dropping B and retaking B is fine. Taking AB and
> somewhere else taking BA is not. There are performance reasons in some
> cases why taking AB releasing A is best with locks, but thats generally
> with sleepable locks.
>
thanks, I'd never really thought about the release pattern actually.
In this particular case, though, B is inside the regmap code and is taken and
released when a regmap call happens, so I think AB necessarily implies BA.
For instance:

lock(A);
regmap_read(...); /* Lock/unlock B */
unlock(A);
 
Thanks
Davide
