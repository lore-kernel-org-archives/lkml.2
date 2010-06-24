Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754225Ab0FXHub (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 03:50:31 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:46483 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753789Ab0FXHu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 03:50:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=ghvr3lygecT9DNSwyfjlM+p8w08+aU/Jxz948ByoMaa7qHUDGaYG0gXTJoGsKp1kvm
         LArNd/Z2HFHwHS/dih0YlKeZs1BNAECruuwERW+Sgmrr6JGZ6AZtsG2ZkL7mw+Wm2Flw
         VyRrW9aX72y2Pi8J2L6tx4Ic+3XwrKV8+Kg4E=
Message-ID: <4C230E3F.4020107@gmail.com>
Date: Thu, 24 Jun 2010 09:50:23 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: Xiaotian Feng <xtfeng@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
CC: Miles Lane <miles.lane@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>, Cliff Wickman <cpw@sgi.com>,
       stable@kernel.org
Subject: Re: 2.6.35-rc3 -- kernel BUG at mm/vmalloc.c:216! - invalid opcode:
 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
References: <AANLkTimYUy0tCvGHf_Qtz0tUG7XVms9i3MOz03m28Jin@mail.gmail.com> <AANLkTilXIkZM8tHX3QCP9A9LpVbmezaa5_PJdQfVU-w7@mail.gmail.com> <4C2305F9.5010306@gmail.com> <AANLkTik5H_rQ2tPO6h3UtslOVzGQo-qoKW_YD8hULAA3@mail.gmail.com>
In-Reply-To: <AANLkTik5H_rQ2tPO6h3UtslOVzGQo-qoKW_YD8hULAA3@mail.gmail.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/2010 09:45 AM, Xiaotian Feng wrote:
>> It's probably the same bug Cliff Wickman reported.
>> per_cpu_ptr_to_phys() was using wrong first chunk match logic which
>> ends up passing wrong addresses to vmalloc_to_page().  I have the
>> following fix patch queued in percpu#for-linus branch and was waiting
>> for Linus to come back.
>>
>>  http://git.kernel.org/?p=linux/kernel/git/tj/percpu.git;a=commitdiff_plain;h=9983b6f0cf8263e51bcf4c8a9dc0c1ef175b3c60;hp=a92d3ff9e5dbd958d8008a3e7a573e988e370ca3
>>
>> Can you please verify the above patch fixes the problem?
> 
> Yes, that patch fixes the problem on my box, thanks.

Thanks for verifying.  Greg, we'll have to wait till Linus comes back
for mainline but maybe it's a good idea to put this into -stable queue
early?  It's a rather straight forward bug fix and unlikely to be
contentious.

Thanks.

-- 
tejun
