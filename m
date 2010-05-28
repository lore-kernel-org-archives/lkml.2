Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758638Ab0E1UFS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 16:05:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43640 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756599Ab0E1UFM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 16:05:12 -0400
Message-ID: <4C0021DC.60608@zytor.com>
Date: Fri, 28 May 2010 13:04:44 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Mike Travis <travis@sgi.com>
CC: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       x86@kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Jacob Pan <jacob.jun.pan@intel.com>, Tejun Heo <tj@kernel.org>,
       Mike Habeck <habeck@sgi.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Patch 1/1] x86 pci: Add option to not assign BAR's if not already
 assigned
References: <4BEAF008.9030805@sgi.com> <4BFFF517.6040401@sgi.com> <4BFFF6B8.30005@zytor.com> <4BFFF8F8.1070502@sgi.com>
In-Reply-To: <4BFFF8F8.1070502@sgi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28/2010 10:10 AM, Mike Travis wrote:
> 
> 
> H. Peter Anvin wrote:
>> On 05/28/2010 09:53 AM, Mike Travis wrote:
>>> Any further consideration for this patch, or has it been rejected?
>>
>> Well, it's really up to Jesse, but as far as I can see, this patch is a
>> net loss of functionality and doesn't actually add anything.  Without
>> this patch, some resources that were not assigned by BIOS will be
>> unreachable.  With this patch, *all* resources that were not assigned by
>> BIOS will be unreachable...
>>
>> 	-hpa
>>
> 
> Apparently you're missing the point of the patch?  The patch is needed
> because BIOS is purposely not assigning I/O BAR's to devices that won't
> use them, freeing up the resource for devices that do need them.  Where
> is the "all" resources that are not reachable?
> 

No, the patch isn't needed for those.

Without your patch:

- Devices assigned by BIOS remain assigned;
- Devices not assigned by BIOS get assigned until address space
  exhausted.

With your patch:

- Devices assigned by BIOS remain assigned;
- Devices not assigned by BIOS never get assigned at all.

What am I missing here?

	-hpa

