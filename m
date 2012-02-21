Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624Ab2BUQhC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 11:37:02 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1485 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751719Ab2BUQhA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 11:37:00 -0500
Message-ID: <4F43C825.1040501@redhat.com>
Date: Tue, 21 Feb 2012 10:36:53 -0600
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Xi Wang <xi.wang@gmail.com>
CC: Haogang Chen <haogangchen@gmail.com>, Theodore Tso <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yongqiang Yang <xiaoqiangnk@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] FS: ext4: fix integer overflow in alloc_flex_gd()
References: <1329777684-18396-1-git-send-email-haogangchen@gmail.com> <4F42DBA0.4090502@redhat.com> <0E72E3B2-DAA7-45F4-845D-AF4E76174A33@gmail.com>
In-Reply-To: <0E72E3B2-DAA7-45F4-845D-AF4E76174A33@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21/2012 07:55 AM, Xi Wang wrote:
> On Feb 20, 2012, at 6:47 PM, Eric Sandeen wrote:
>> Hm this raises a few questions I think.
>>
>> On the one hand, making sure the kmalloc arg doesn't overflow here is
>> certainly a good thing and probably the right thing to do in the short term.
>>
>> So I guess:
>>
>> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
>>
>> for that, to close the hole.
> 
> Another possibility is to wait for knalloc/kmalloc_array in the -mm
> tree, which is basically the non-zeroing version of kcalloc that
> performs overflow checking.
> 
>> Doesn't this also mean that a valid s_log_groups_per_flex (i.e. 31)
>> will fail in this resize code?  That would be an unexpected outcome.
>> 2^31 groups per flex is a little crazy, but still technically valid
>> according to the limits in the code.
> 
> Or we could limit s_log_groups_per_flex/groups_per_flex to a
> reasonable upper bound in ext4_fill_flex_info(), right?

Depends on the "flex_bg" design intent, I guess.

I don't know if the 2^31 was an intended design limit, or just a
mathematical limit that based on container sizes etc...

I'd have to look at the resize code more carefully but I can't imagine
that it's imperative to allocate this stuff all at once.

-Eric

> - xi
> 

