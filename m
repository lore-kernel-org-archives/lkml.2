Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932751Ab0LUIAO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 03:00:14 -0500
Received: from mail-fx0-f43.google.com ([209.85.161.43]:56745 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754006Ab0LUIAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 03:00:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=lmh59YDRzuOLO7E04I9DT1vOb37h6fFbLsZvcqtX0PBrYee8G1cfeulg6kLQRPlRpg
         G/XaKVhD55H7BSxfNfOend0ZBUaxsb+J80YcoRXqdR+DfzCcPflbnKEZGbYYTGa5XeOY
         ypi7P0W0xDYtV5FFYAbbzn8eqrMg2d2eMf9b4=
Date: Tue, 21 Dec 2010 08:56:12 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: "Kuwahara,T." <6vvetjsrt26xsrzlh1z0zn4d2grdah@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Christoph Lameter <cl@linux.com>,
        David Miller <davem@davemloft.net>, John Stultz <johnstul@us.ibm.com>,
        Krzysztof Halasa <khc@pm.waw.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Rodolfo Giometti <giometti@linux.it>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH V7 1/8] ntp: add ADJ_SETOFFSET mode bit
Message-ID: <20101221075612.GA13626@riccoc20.at.omicron.at>
References: <cover.1292512461.git.richard.cochran@omicron.at>
 <880d82bb8120f73973db27e0c48e949014b1a106.1292512461.git.richard.cochran@omicron.at>
 <AANLkTi=yGoFwYt4p_LeHtAQyYgmURspO-p57UdL0sUEZ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=yGoFwYt4p_LeHtAQyYgmURspO-p57UdL0sUEZ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 18, 2010 at 05:16:52AM +0900, Kuwahara,T. wrote:
> On 12/17/10, Richard Cochran <richardcochran@gmail.com> wrote:
> > This patch adds a new mode bit into the timex structure. When set, the bit
> > instructs the kernel to add the given time value to the current time.
> >
> 
> The proposed new control mode, ADJ_SETOFFSET, is logically the same as
> ADJ_OFFSET with timex.constant == -INFINITY.  So it is possible to do
> the same thing without risking forward compatibility.  (I mean by "risking
> forward compatibility" that the mode bit 0x0040 may be defined differently
> by the upstream maintainer anytime in the future.)

Can you please elaborate?

I don't see any way to use timex.constant with ADJ_OFFSET in order to
correct a time offset. The 'time_constant' in kernel/time/ntp.c is
restricted to the interval [0..MAXTC], and MAXTC is 10 in timex.h.

Richard
