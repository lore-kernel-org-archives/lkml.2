Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756101Ab0FXQvZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 12:51:25 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:60637 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753936Ab0FXQvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 12:51:24 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6023"; a="45268946"
Message-ID: <4C238D09.5050200@codeaurora.org>
Date: Thu, 24 Jun 2010 09:51:21 -0700
From: Patrick Pannuto <ppannuto@codeaurora.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org, sboyd@codeaurora.org, tglx@linutronix.de,
       mingo@elte.hu, heiko.carstens@de.ibm.com, eranian@google.com,
       schwidefsky@de.ibm.com
Subject: Re: [RFC] [PATCH] timer: Added usleep[_range][_interruptable] timer
References: <4C225EED.5040600@codeaurora.org> <871vbwafwu.fsf@basil.nowhere.org>
In-Reply-To: <871vbwafwu.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Patrick Pannuto <ppannuto@codeaurora.org> writes:
> 
> Overall it seems like a good improvement.
> 
>> +
>> +static inline void usleep(unsigned long usecs)
>> +{
>> +	usleep_range(usecs, usecs);
>> +}
>> +
>> +static inline unsigned long usleep_interruptible(unsigned long usecs)
> 
> Is the interruptible case even needed?  I assume most drivers won't
> bother with that and not being interruptible for a few usecs is not a
> big issue.

Honestly, I don't think so, but I was mirroring the msleep API when
I wrote it so I included it for completeness.  I can't think of a use
case where it is necessary / useful. I will remove it unless anyone
can think of an application for it?

