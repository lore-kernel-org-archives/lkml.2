Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756452Ab1FXMNb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 08:13:31 -0400
Received: from mail.windriver.com ([147.11.1.11]:56075 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662Ab1FXMNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 08:13:30 -0400
Message-ID: <4E047F39.6060704@windriver.com>
Date: Fri, 24 Jun 2011 08:12:41 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110516 Thunderbird/3.1.10
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: <stable@kernel.org>, <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        <stable-review@kernel.org>, Timo Warns <warns@pre-sense.de>
Subject: Re: [Stable-review] [34-longterm 224/247] fs/partitions/ldm.c: fix
 oops caused by corrupted partition table
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>	 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>	 <1308850515-15242-165-git-send-email-paul.gortmaker@windriver.com> <1308870894.3093.1011.camel@localhost>
In-Reply-To: <1308870894.3093.1011.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-06-23 07:14 PM, Ben Hutchings wrote:
> On Thu, 2011-06-23 at 13:34 -0400, Paul Gortmaker wrote:
>> From: Timo Warns <Warns@pre-sense.de>
>>
>>                    -------------------
>>     This is a commit scheduled for the next v2.6.34 longterm release.
>>     If you see a problem with using this for longterm, please comment.
>>                    -------------------
>>
>> commit c340b1d640001c8c9ecff74f68fd90422ae2448a upstream.
>>
>> The kernel automatically evaluates partition tables of storage devices.
>> The code for evaluating LDM partitions (in fs/partitions/ldm.c) contains
>> a bug that causes a kernel oops on certain corrupted LDM partitions.
>> A kernel subsystem seems to crash, because, after the oops, the kernel no
>> longer recognizes newly connected storage devices.
>>
>> The patch validates the value of vblk_size.
> [...]
> 
> This doesn't completely fix the possibility of a buffer overflow.  You
> also need commit cae13fe4cc3f24820ffb990c09110626837e85d4.

Thanks Ben, I will queue that up this morning.

Paul.

> 
> Ben.
> 
