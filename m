Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932223Ab0HQIxJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 04:53:09 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49474 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756871Ab0HQIxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 04:53:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ftcs0d3EJA/CiO0hELDJYO+cpEERsZDkNSf0jehRQLmpXkBpU2LpB6Y+SHul2/Pw9P
         hihtBVcQhCQTQcNsCYKStLUki+iqzg6r/X51bJh5WdqQ2BZ8vf5+w8RBjv/Day3mUov0
         nXwknmIw10i7ZvXmB0Mu89cXWUtRvMYujPdrw=
Date: Tue, 17 Aug 2010 10:53:24 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: john stultz <johnstul@us.ibm.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, Krzysztof Halasa <khc@pm.waw.pl>,
        Rodolfo Giometti <giometti@linux.it>
Subject: Re: [PATCH 1/5] ptp: Added a brand new class driver for ptp clocks.
Message-ID: <20100817085324.GB3330@riccoc20.at.omicron.at>
References: <cover.1281956490.git.richard.cochran@omicron.at>
 <363bd749a38d0b785d8431e591bf54c38db4c2d7.1281956490.git.richard.cochran@omicron.at>
 <AANLkTik_2MKMhOuDGOmu8Kzyq-ipLe+Bxrb3FaD+Tv4U@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTik_2MKMhOuDGOmu8Kzyq-ipLe+Bxrb3FaD+Tv4U@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 16, 2010 at 12:24:48PM -0700, john stultz wrote:
> 3) I'm not sure I see the benefit of being able to have multiple
> frequency corrected time domains.  In other words, what benefit would
> you get from adjusting a PTP clock's frequency instead of just
> adjusting the system's time freq? Having the PTP time as a reference
> to correct the system time seems reasonable, but I'm not sure I see
> why userland would want to adjust the PTP clock's freq.

For PTP enabled hardware, the timestamp on the network packet comes
from from the PTP clock, not from the system time.

Of course, you can always just leave the PTP clock alone, figure the
needed correction, and apply it whenever needed. But this has some
disadvantages. First of all, the (one and only) open source PTPd does
not do it that way. Also, only one program (the PTPd or equivalent)
will know the correct time. Other programs will not be able to ask the
operating system for time services. Instead, they would need to use
IPC to the PTPd.

The PTP protocol (and some PTP hardware) offers a "one step" method,
where the timestamps are inserted by the hardware on the fly. Here you
really do need the PTP clock to be correctly adjusted.

All of the PTP hardware that I am familiar with provides a clock
adjustment method, so it simpler and cleaner just to use this facility
to tune the PTP clock.

Richard
