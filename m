Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753065Ab0JMVRZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 17:17:25 -0400
Received: from tuxonice.net ([74.207.252.127]:34588 "EHLO mail.tuxonice.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751021Ab0JMVRX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 17:17:23 -0400
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <4CB621DF.9070109@tuxonice.net>
Date: Thu, 14 Oct 2010 08:17:19 +1100
From: Nigel Cunningham <nigel@tuxonice.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.10pre) Gecko/20100903 Shredder/3.1.4pre
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Pavel Machek <pavel@ucw.cz>,
        Linux PM <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        TuxOnIce-devel <tuxonice-devel@tuxonice.net>
Subject: Re: [PATCH 13/23] Hibernation: Partial page I/O support.
References: <1285566238-10966-1-git-send-email-nigel@tuxonice.net> <1285566238-10966-14-git-send-email-nigel@tuxonice.net> <20101013071008.GA1610@ucw.cz> <201010132228.22604.rjw@sisk.pl>
In-Reply-To: <201010132228.22604.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On 14/10/10 07:28, Rafael J. Wysocki wrote:
> On Wednesday, October 13, 2010, Pavel Machek wrote:
>> Hi!
>>
>>> Add functions that can be used for coalescing and splitting buffers
>>> that are smaller than PAGE_SIZE. These functions provide no method
>>> of determining where the boundaries of the smaller buffers are to
>>> be found - that is the caller's problem.
>>
>> I don't get it; why do we need that support?
>
> This is related to compression.  This way we can put data from two or more
> compressed pages into one page frame.

It also provides a simple way of putting information from multiple 
sources into a larger-than-at-the-moment header:

- Which pfns are stored
- What swap extents are used
- What devices are used (dev_t, UUID, last mount time for each)
- Whether compression is enabled and what algo is used (if made 
configurable)

and so on.

I do see the logic to Pavel's question though - the last set of patches 
I sent didn't switch the compression code over to using this support. 
That change would make their usefulness a lot clearer.

Regarding speed, I haven't measured the difference but would expect that 
the cost of combining and splitting pages in this way would be less than 
that of waiting on extra I/O. In addition, if we merge the pages in this 
way, our image size will be much closer to the compression ratio and 
will therefore make it more feasible for us to estimate how much storage 
is needed, taking into account an expected compression ratio (which is 
what TuxOnIce currently does).

Regards,

Nigel
