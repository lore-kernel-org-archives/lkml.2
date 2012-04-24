Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756251Ab2DXCFk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 22:05:40 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:36593 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755222Ab2DXCFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 22:05:39 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 24 Apr 2012 11:05:18 +0900 (JST)
Message-Id: <20120424.110518.434300178.d.hatayama@jp.fujitsu.com>
To: andi@firstfloor.org
Cc: linux-kernel@vger.kernel.org, fenghua.yu@intel.com, ebiederm@xmission.com
Subject: Re: [PATCH 2/2] Enter 2nd kernel with BSP
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
In-Reply-To: <m2ipgqoh90.fsf@firstfloor.org>
References: <20120416021951.9303.58568.stgit@localhost6.localdomain6>
	<20120416022139.9303.56284.stgit@localhost6.localdomain6>
	<m2ipgqoh90.fsf@firstfloor.org>
X-Mailer: Mew version 6.3 on Emacs 23.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 2/2] Enter 2nd kernel with BSP
Date: Mon, 23 Apr 2012 03:49:15 -0700

>> Split logic into BSP's and AP's: BSP waits for AP halting.
>>
>> Don't remove variable crashing_cpu for debugging use; useful for
>> determining one what CPU crash happens.
> 
> Fenghua has this patchkit to allow offlining the BSP. What happens then?
> 
> It would be good to understand why initializing APs from other APs
> should not work.  Not aware of such a limitation in x86.
> 
> AFAIK when we online a random cpu after boot there is no effort to do it
> from BSP. Why does that work and not from the kexec boot?
> 

Hello Andi,

I have yet to test what I explain here, so I'm sorry I say these with
``would''.

APs to APs case would be entirely my misunderstanding. The problematic
case would be APs to BSP case only.

native_cpu_up avoids to wake up cpu with boot_cpu_physical_apicid, but
the boot_cpu_physical_apicid would be just a boot cpu now, which could
be non-BSP on the 2nd kernel; equal to crashing cpu on the 1st
kernel. It would need to check explicitly whether a given cpu is BSP
or not and this would be better fix here. This is suggested by Eric.

Thanks.
HATAYAMA, Daisuke

