Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757356Ab1AMVwh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 16:52:37 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:51667 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756745Ab1AMVwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 16:52:30 -0500
Subject: Re: [PATCH V9 02/13] ntp: add ADJ_SETOFFSET mode bit
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
In-Reply-To: <1294952228.5617.20.camel@work-vm>
References: <cover.1294917347.git.richard.cochran@omicron.at>
	 <60566a54842bcf5974d55ed39f387c32ff9cf5cb.1294917348.git.richard.cochran@omicron.at>
	 <AANLkTimHP1OsWauj6O566WgnxVTjMbNg2PK644QcT9Lq@mail.gmail.com>
	 <1294952228.5617.20.camel@work-vm>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 13 Jan 2011 13:52:17 -0800
Message-ID: <1294955537.5617.50.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-01-13 at 12:57 -0800, john stultz wrote:
> On Fri, 2011-01-14 at 05:39 +0900, Kuwahara,T. wrote:
> > My proposal: Limit the adjustable range of the offset so that leap
> > seconds will never occur more than once. (2147.5 seconds would be the
> > best choice. :-)
> 
> 2147.5? That's ~36 minutes. 
> 
> While I think a limit could be a sensible compromise here. Leap seconds
> are limited to every six months. So surely a limit of 86400 (one day),
> or 2592000 (30 days) would be more reasonable.

Actually. Thinking about this some more (and having to try to
rationalize it for Thomas), this doesn't really seem reasonable. If an
application wants to adjust the time, we can leave the responsibility to
userland to handle compensation for expected or historical leapseconds
if they care.

Since if you're adjusting the time, especially by a large amount, you're
not starting from the correct time value. So expecting the kernel to
incorperate historical or planned future leapseconds (outside of the
TIME_INS notification from NTP) is silly. 

Really, in Linux leapseconds do not really exist except for the moment
they occur. If a leapsecond occurs, then you set your time back to
before the leapsecond, it won't happen a second time. 

So I don't think we need to enforce a limit. The interface suggested
seems totally reasonable to me. I'm happy to hear arguments to the
contrary, but they really must be more convincing.

thanks
-john



