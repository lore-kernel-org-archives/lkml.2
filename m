Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751532Ab0LWGOJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 01:14:09 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:41196 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076Ab0LWGOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 01:14:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=wUZgUWTUaxz4lLe2wP9DwL4vM6NA86Tv1PhraYarAO2Cqmbk2On/dYYilIk/iRC+dL
         eDZKtl/tf3gpHPuvPWj33PhwnoNPUBIXYlo5youFZGxQRYAHcvmhXRAbfZDjI+l/o/p8
         lV7BLMrCZ2SUauEh1ahe/egCNKU/pM0TjxExI=
Date: Thu, 23 Dec 2010 07:13:59 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: "Kuwahara,T." <6vvetjsrt26xsrzlh1z0zn4d2grdah@gmail.com>
Cc: john stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org, netdev@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Christoph Lameter <cl@linux.com>, David Miller <davem@davemloft.net>,
        Krzysztof Halasa <khc@pm.waw.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Rodolfo Giometti <giometti@linux.it>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH V7 1/8] ntp: add ADJ_SETOFFSET mode bit
Message-ID: <20101223061359.GA7169@riccoc20.at.omicron.at>
References: <cover.1292512461.git.richard.cochran@omicron.at>
 <880d82bb8120f73973db27e0c48e949014b1a106.1292512461.git.richard.cochran@omicron.at>
 <AANLkTi=yGoFwYt4p_LeHtAQyYgmURspO-p57UdL0sUEZ@mail.gmail.com>
 <20101221075612.GA13626@riccoc20.at.omicron.at>
 <AANLkTimJd5pScKTiDxuYd-h+NevYbCusyvUAqmUDXe8h@mail.gmail.com>
 <1292970355.2618.76.camel@work-vm>
 <AANLkTimmTzH8+fSYmbajqZ+hU5Ps-UZaTp_1TYzjHB6P@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimmTzH8+fSYmbajqZ+hU5Ps-UZaTp_1TYzjHB6P@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 23, 2010 at 05:27:58AM +0900, Kuwahara,T. wrote:
> On Wed, Dec 22, 2010 at 7:25 AM, john stultz <johnstul@us.ibm.com> wrote:
> > I don't see why that would be better then adding a
> > clear new mode flag?
> 
> In short, time step is a special case of time slew.  Those are the same,
> only different in one parameter, as is shown in my previous post.
> That's why I said there's no need for adding a new mode.

Well, in addition to the objections raised by John, your suggested
implementation is also shortsighted. The field timex.constant is
copied into time_constant in some code paths. Obviously, this would be
a bad thing when timex.constant==-huge.

So, you need to clarify the interaction between ADJ_OFFSET,
ADJ_TIMECONST, ADJ_TAI, timex.constant, time_constant, and MAXTC.

If you would fully implement your idea, I expect it would become
obvious that it a bit of a hack, both in the kernel code and in the
user space interface. But, if you disagree, please just post a patch
with the complete implementation...

Thanks,
Richard
