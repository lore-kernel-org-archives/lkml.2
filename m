Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964817Ab1ETMJD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 08:09:03 -0400
Received: from purkki.adurom.net ([80.68.90.206]:44856 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935666Ab1ETMJA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 08:09:00 -0400
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/2] Fix uevent race in register_netdevice()
References: <20110516143913.13838.85357.stgit@localhost6.localdomain6>
	<20110516.141158.1777924960833804150.davem@davemloft.net>
From: Kalle Valo <kvalo@adurom.com>
Date: Fri, 20 May 2011 15:08:58 +0300
In-Reply-To: <20110516.141158.1777924960833804150.davem@davemloft.net> (David Miller's message of "Mon\, 16 May 2011 14\:11\:58 -0400 \(EDT\)")
Message-ID: <87oc2xd15x.fsf@purkki.adurom.net>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> writes:

> From: Kalle Valo <kvalo@adurom.com>
> Date: Mon, 16 May 2011 17:46:30 +0300
>
>> I'm trying to fix a race in register_netdevice(). The problem is that
>> there's a uevent to userspace before the netdevice is ready for use. The
>> problem is described here:
>> 
>> https://bugzilla.kernel.org/show_bug.cgi?id=15606
>> 
>> I have sent few different ways to fix this, but none of them have been
>> really usable. Now I came up with a way which changes the driver core
>> to make it possible send the uevent in a separate call. This is a clean
>> and safe way to fix the race. Downside is that two new functions are
>> added to the driver core interface.
>> 
>> Please comment.
>
> This doesn't work.
>
> The sysfs file will still be there before the uevent, so any
> process can go in there, and see the inconsistent state.

I considered that user space would not notice the device until the
uevent is emitted so that wouldn't matter that much.

But it's back to the drawing board again. I'm running out of options
how to do this in a not so intrusive way. Do you have any tips how to
fix the race for good?

-- 
Kalle Valo
