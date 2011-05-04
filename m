Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756156Ab1EDWii (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 18:38:38 -0400
Received: from cantor.suse.de ([195.135.220.2]:54488 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753011Ab1EDWih convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 18:38:37 -0400
References: <4DB8600C.8080000@suse.com> <20110504150557.a7f4bf73.akpm@linux-foundation.org>
In-Reply-To: <20110504150557.a7f4bf73.akpm@linux-foundation.org>
Mime-Version: 1.0 (iPhone Mail 8H7)
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <34AB62EA-4A0B-4DD5-8731-AD9B0DB69F14@suse.com>
Cc: Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mandeep Singh Baines <msb@google.com>
X-Mailer: iPhone Mail (8H7)
From: Jeff Mahoney <jeffm@suse.com>
Subject: Re: [PATCH] hung_task_timeout: configurable default
Date: Wed, 4 May 2011 18:38:21 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On May 4, 2011, at 6:05 PM, Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 27 Apr 2011 14:27:24 -0400
> Jeff Mahoney <jeffm@suse.com> wrote:
> 
>> This patch allows the default value for sysctl_hung_task_timeout_secs
>> to be set at build time. The feature carries virtually no overhead,
>> so it makes sense to keep it enabled. On heavily loaded systems, though,
>> it can end up triggering stack traces when there is no bug other than
>> the system being underprovisioned. We use this patch to keep the hung task
>> facility available but disabled at boot-time.
>> 
>> The default of 120 seconds is preserved. As a note, commit e162b39a may
>> have accidentally reverted commit fb822db4, which raised the default from
>> 120 seconds to 480 seconds.
> 
> The changelog forgot to tell us why the patch's author considers the
> patch to be needed.  This happens quite a lot.
> 
>> @@ -33,7 +33,8 @@ unsigned long __read_mostly sysctl_hung_
>> /*
>>  * Zero means infinite timeout - no checking done:
>>  */
>> -unsigned long __read_mostly sysctl_hung_task_timeout_secs = 120;
>> +unsigned long __read_mostly sysctl_hung_task_timeout_secs =
>> +                    CONFIG_DEFAULT_HUNG_TASK_TIMEOUT;
>> 
> 
> For the life of me I can't understand why you distro guys need to keep
> patching the kernel when you could just add a line to your initscripts.
> 
> I'm suspecting that lameness is involved.

Good point, and one we actually made ourselves internally after starting to submit these in the last round when we were tweaking more sensitive knobs.

Skip this one and I'll submit a patch fixing the 480s -> 120s regression.

-Jeff

--
Jeff Mahoney
(mobile)