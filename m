Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752446Ab0LVHLM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 02:11:12 -0500
Received: from mail-fx0-f43.google.com ([209.85.161.43]:59486 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063Ab0LVHLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 02:11:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=c2SBoxuO8tJvcvnwOsIaux5ve7AUdBDGb7BoPVE5Ytqc82WnRjKqH0l5Am7rnXhiag
         0DVuc9OGm0Bpah1GxeAhWkucSkq1YKIB0txjQGHYHqGYrLa8XO72Tz6RtuJXu7T/Q6ab
         7iqs3QgcTdp8ft+YFIVxKJ0cvYi1Cvu7Ib3uE=
Date: Wed, 22 Dec 2010 08:11:04 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: john stultz <johnstul@us.ibm.com>
Cc: "Kuwahara,T." <6vvetjsrt26xsrzlh1z0zn4d2grdah@gmail.com>,
        Alexander Gordeev <lasaine@lvk.cs.msu.su>,
        Rodolfo Giometti <giometti@enneenne.com>, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org, netdev@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Christoph Lameter <cl@linux.com>, David Miller <davem@davemloft.net>,
        Krzysztof Halasa <khc@pm.waw.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Rodolfo Giometti <giometti@linux.it>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH V7 1/8] ntp: add ADJ_SETOFFSET mode bit
Message-ID: <20101222071104.GA8627@riccoc20.at.omicron.at>
References: <cover.1292512461.git.richard.cochran@omicron.at>
 <880d82bb8120f73973db27e0c48e949014b1a106.1292512461.git.richard.cochran@omicron.at>
 <AANLkTi=yGoFwYt4p_LeHtAQyYgmURspO-p57UdL0sUEZ@mail.gmail.com>
 <1292960224.2618.4.camel@work-vm>
 <AANLkTikHV-qN73Zvvvxn76vtFFKG_VNTQhF3qpqTnOrE@mail.gmail.com>
 <1292968784.2618.51.camel@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292968784.2618.51.camel@work-vm>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 21, 2010 at 01:59:44PM -0800, john stultz wrote:
> However, your concern does bring up a good point: 0x40 is MOD_PPSMAX in
> BSD, and we should at-least check to make sure that the PPS code that is
> currently floating around on the lists and is in akpm's tree hasn't
> already reserved that bit.

If the concern is only about that bit, then we can choose another one
from the range 0x0f00 instead.

It seems to me that the ability to jump the clock is a very useful
feature, at least when implementing a clock servo for PTP in user
space, if not in other cases, too. I wonder why that option is missing
from the interface in the first place.

I am not aware of any serious attempt to get any kind of standardized
PTP clock support into any other OS.  As far as compatibility with NTP
is concerned, why can't we let Linux set an example and let
NTP/BSD/*nix follow us?


Richard
