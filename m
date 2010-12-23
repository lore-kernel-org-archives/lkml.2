Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752980Ab0LWAAa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 19:00:30 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:57522 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336Ab0LWAA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 19:00:28 -0500
Subject: Re: [PATCH V7 1/8] ntp: add ADJ_SETOFFSET mode bit
From: john stultz <johnstul@us.ibm.com>
To: "Kuwahara,T." <6vvetjsrt26xsrzlh1z0zn4d2grdah@gmail.com>
Cc: Richard Cochran <richardcochran@gmail.com>, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org, netdev@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Christoph Lameter <cl@linux.com>, David Miller <davem@davemloft.net>,
        Krzysztof Halasa <khc@pm.waw.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Rodolfo Giometti <giometti@linux.it>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <AANLkTimmTzH8+fSYmbajqZ+hU5Ps-UZaTp_1TYzjHB6P@mail.gmail.com>
References: <cover.1292512461.git.richard.cochran@omicron.at>
	 <880d82bb8120f73973db27e0c48e949014b1a106.1292512461.git.richard.cochran@omicron.at>
	 <AANLkTi=yGoFwYt4p_LeHtAQyYgmURspO-p57UdL0sUEZ@mail.gmail.com>
	 <20101221075612.GA13626@riccoc20.at.omicron.at>
	 <AANLkTimJd5pScKTiDxuYd-h+NevYbCusyvUAqmUDXe8h@mail.gmail.com>
	 <1292970355.2618.76.camel@work-vm>
	 <AANLkTimmTzH8+fSYmbajqZ+hU5Ps-UZaTp_1TYzjHB6P@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Dec 2010 16:00:10 -0800
Message-ID: <1293062410.2404.186.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-12-23 at 05:27 +0900, Kuwahara,T. wrote:
> On Wed, Dec 22, 2010 at 7:25 AM, john stultz <johnstul@us.ibm.com> wrote:
> > I don't see why that would be better then adding a
> > clear new mode flag?
> 
> In short, time step is a special case of time slew.  Those are the same,
> only different in one parameter, as is shown in my previous post.
> That's why I said there's no need for adding a new mode.

Sure, I get that a instantaneous offset adjustment could be represented
as a instantaneous slew of the same amount. But what is the benefit of
doing this? The ADJ_OFFSET isn't really a continuous function like you
describe. For instance, you can't slew time backwards. The amount you
can slow or speed up the clock is limited, so time will always increase.
So to have a magic value way outside the bound of normal operation that
does something special seems a bit obfuscated.

ADJ_SETOFFSET isn't slewing the clock. So I think its much clearer to
add a new mode, rather then to try to wedge the functionality into a
corner case of ADJ_OFFSET slewing just because one could mathematically
represent it the same way.

I see the cost of adding it as a special case as adding extra complexity
to an already complex subsystem. Doing things that make the code easier
to understand and read makes it more maintainable. And I don't see the
gain (other then saving a bit in the bit flag) to offset the complexity
of trying to squeeze this functionality into the ADJ_OFFSET mode.

thanks
-john


