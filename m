Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756878Ab1ELMLJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 08:11:09 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48032 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756777Ab1ELMLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 08:11:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=IOZ5YOlmo0suj0VLeMPF92FoHW8B8ly7owzb5BhpcA9aK6W6TyX1vRDabGOtZ8wKhY
         Hy/bVHplCJEsPNiKrD7+56/JhCybarjpKjY62p+YKue3sz7OZV+wSwbNedLmxrK8x6fI
         NiA/NrKPd6Cjag9l1ZcT/4W0PcR8i+3aymNoQ=
Message-ID: <4DCBCE56.2010607@gmail.com>
Date: Thu, 12 May 2011 14:11:02 +0200
From: Juri Lelli <juri.lelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: Yong Zhang <yong.zhang0@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: lock_stat &rq->lock/1 class name meaning
References: <4DCAB8A2.8060605@linux.com> <20110512105756.GA3329@zhy>
In-Reply-To: <20110512105756.GA3329@zhy>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks!

On 05/12/2011 12:57 PM, Yong Zhang wrote:
> On Wed, May 11, 2011 at 06:26:10PM +0200, Juri Lelli wrote:
>> Hi,
>> I'm trying to collect contention statistics through /proc/lock_stat
>> about scheduler data structures.
>>
>> What I obtain if a do "cat /proc/lock_stat" is something like:
>> ...
>> &rq->lock:         13128          13128           0.43
>> [...]
>>
>> I guess the first one is about the per-rq (per-CPU) spinlock, but
>> what about the second? What the "/1" stands for?
>
> It is also rq but it's subclass is 1.
>
> Take a look at raw_spin_lock_nested(&this_rq->lock, SINGLE_DEPTH_NESTING);
> in _double_lock_balance()

Ok, I've put more light on this also looking at lockdep.h comments and 
lockdep-design documentation.

Since I'm probably not the only one having troubles undestanding 
lock_stat output, maybe could be useful to add something on this inside 
lockstat documentation (I can try to do this). What you think?

	Juri
