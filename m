Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758808Ab2JYMW7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 08:22:59 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:36088 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753229Ab2JYMW6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 08:22:58 -0400
Date: Thu, 25 Oct 2012 14:22:43 +0200
From: Davide Ciminaghi <ciminaghi@gnudd.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: sameo@linux.intel.com, rubini@gnudd.com, giancarlo.asnaghi@st.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/10] drivers/mfd/sta2x11-mfd: add regmap support
Message-ID: <20121025122243.GD29674@mail.gnudd.com>
References: <1350917441-4478-1-git-send-email-ciminaghi@gnudd.com> <1350917441-4478-3-git-send-email-ciminaghi@gnudd.com> <20121023171837.GE4477@opensource.wolfsonmicro.com> <20121024123118.GD26622@mail.gnudd.com> <20121024124955.GF18814@opensource.wolfsonmicro.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20121024124955.GF18814@opensource.wolfsonmicro.com>
X-Face: #Q;A)@_4.#>0+_%y]7aBr:c"ndLp&#+2?]J;lkse\^)FP^Lr5@O0{)J;'nny4%74.fM'n)M
	>ISCj.KmsL/HTxz!:Ju'pnj'Gz&.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2012 at 01:49:55PM +0100, Mark Brown wrote:
> On Wed, Oct 24, 2012 at 02:31:18PM +0200, Davide Ciminaghi wrote:
> > On Tue, Oct 23, 2012 at 06:18:38PM +0100, Mark Brown wrote:
> 
...
> 
> > My opinion is that passing function pointers for
> > readable/writeable/precious/volatile methods could still be useful when
> > registers' features or access properties can change at runtime (for instance a
> 
> This is essential for sparse register maps, really.

yes, I realized that when updating sta2x11-mfd to the new table driven approach
yesterday. One more thing I found is that you can have the case in which, for
instance, almost all readable registers are also writeable. To address such a
case, I added the possibility for a user to specify ranges for which a given
property is false, so that, in the above example, you first check whether a
given register belongs to the non-writeable region and then maybe skip the
other checks.
I'm sending a regmap patch in few minutes.

Thanks and regards
Davide

