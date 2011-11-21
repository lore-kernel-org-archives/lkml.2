Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020Ab1KUSvP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 13:51:15 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:39709 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755859Ab1KUSvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 13:51:11 -0500
Message-ID: <4ECA9D9A.5040006@gmail.com>
Date: Mon, 21 Nov 2011 10:51:06 -0800
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@kernel.org>
CC: linux-mips@linux-mips.org, ralf@linux-mips.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-embedded@vger.kernel.org, x86@kernel.org,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH RFC 1/5] scripts: Add sortextable to sort the kernel's
 exception table.
References: <1321645068-20475-1-git-send-email-ddaney.cavm@gmail.com> <1321645068-20475-2-git-send-email-ddaney.cavm@gmail.com> <4EC98C97.50604@kernel.org>
In-Reply-To: <4EC98C97.50604@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20/2011 03:26 PM, H. Peter Anvin wrote:
> On 11/18/2011 11:37 AM, David Daney wrote:
>> From: David Daney<david.daney@cavium.com>
>>
>> Using this build-time sort saves time booting as we don't have to burn
>> cycles sorting the exception table.
>>
>
> If we're going to do this at build time, I would suggest using a
> collisionless hash instead.  The lookup time for those are O(1), but
> they definitely need to be done at build time.
>

It is my understanding that such a hash table would be sparsely 
populated, so space would have to be reserved for the empty buckets. 
The current patch, which works in-place on the fully linked vmlinux, 
doesn't have to worry about finding enough space for the table.

If we were to do the collisionless hash, we would somehow have to 
reserve space for the empty buckets.

On my test kernel, there were only 1453 entries in the exception table, 
So doing the binary search takes a maximum of 11 loads.

So, I guess I am not strongly opposed to using a collisionless hash, but 
I think it may not be worth the extra effort.

David Daney
