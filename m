Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755867Ab2LNBFL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 20:05:11 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41453 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755573Ab2LNBFJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 20:05:09 -0500
Message-ID: <50CA7B34.7060502@zytor.com>
Date: Thu, 13 Dec 2012 17:04:52 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 19/27] x86, boot: update comments about entries for
 64bit image
References: <1355436141-8668-1-git-send-email-yinghai@kernel.org> <1355436141-8668-20-git-send-email-yinghai@kernel.org> <50CA6478.20008@zytor.com> <CAE9FiQURsKT8Ufy7NmWUzrzkYoH65Edk6e_kJkw_+YYx=1bXTg@mail.gmail.com> <50CA7515.9080701@zytor.com> <CAE9FiQXi6XZ9_7CDS_Ypgd59tSouhw8TCePCdJQNC7bhGMO8WQ@mail.gmail.com> <CAE9FiQXSSbWOp=DqGiH2gyuR4FvTaLot4CnSm3KGqcgmj4p34A@mail.gmail.com> <50CA78AC.3060700@zytor.com> <CAE9FiQXp8kiHus3s-TYtAKzzZHqgfmsv-PpHDqgd56b1Re3B-g@mail.gmail.com>
In-Reply-To: <CAE9FiQXp8kiHus3s-TYtAKzzZHqgfmsv-PpHDqgd56b1Re3B-g@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/2012 05:00 PM, Yinghai Lu wrote:
> On Thu, Dec 13, 2012 at 4:54 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> On 12/13/2012 04:51 PM, Yinghai Lu wrote:
> 
>>> also need to make sure zero page and command line get ident mapping.
>>> because arch/x86/boot/compressed/head_64.S is using them.
>>>
>>
>> ... or we need to do the same kind of thing there.
>>
> your #PF handler approach will  handle accessing kernel code together
> with zero_page, command_line, ramdisk ?
> so only need to map first 2M?
> 

Well, it needs to map enough that it can bootstrap itself -- 2M is
certainly sufficient, but right now it touches memory which isn't
necessarily guaranteed to be in the same 2M chunk (specifically
.init.data and .init.text).

We can do the equivalent in the decompressor, there the memory layout is
even simpler, and it may very well be practical to say we only need the
caller to map a single 2M page RWX.

	-hpa

