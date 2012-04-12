Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757742Ab2DLUOT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 16:14:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42707 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752848Ab2DLUOR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 16:14:17 -0400
Message-ID: <4F87378D.7080505@zytor.com>
Date: Thu, 12 Apr 2012 13:14:05 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Jim Kukunas <james.t.kukunas@linux.intel.com>
CC: neilb@suse.de, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: lib/raid6: SSSE3 optimized recovery functions v2
References: <20120412161805.133c4ad0@notabene.brown> <1334261073-14781-1-git-send-email-james.t.kukunas@linux.intel.com>
In-Reply-To: <1334261073-14781-1-git-send-email-james.t.kukunas@linux.intel.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2012 01:04 PM, Jim Kukunas wrote:
> 
> This keeps with the existing code conventions. The code block is:
> 
> extern const u8 raid6_gfmul[256][256] __attribute__((aligned(256)));
> extern const u8 raid6_vgfmul[256][32] __attribute__((aligned(256)));
> extern const u8 raid6_gfexp[256]      __attribute__((aligned(256)));
> extern const u8 raid6_gfinv[256]      __attribute__((aligned(256)));
> extern const u8 raid6_gfexi[256]      __attribute__((aligned(256)));
> 
>> WARNING: printk() should include KERN_ facility level
>> #120: FILE: lib/raid6/algos.c:103:
>> +		printk("raid6: using %s recovery algorith\n", nest->name);
>>
>> WARNING: printk() should include KERN_ facility level
>> #122: FILE: lib/raid6/algos.c:105:
>> +		printk("raid6: Yikes! No recovery algorithm found!\n");
>>
>> WARNING: printk() should include KERN_ facility level
>> #159: FILE: lib/raid6/algos.c:176:
>> +		printk("raid6: Yikes!  No memory available.\n");
> 
> Again, these are following the conventions of the existing code such as:
> 
> printk("raid6: using algorithm %s (%ld MB/s)\n",
> 
> In fact, the last printk, about no memory available, was simply moved to a 
> different line in my patch.
> 

A lot of the RAID-6 code predates the modern kernel conventions.  It
would be good to clean that up, but that is largely orthogonal to this
patch.

	-hpa

