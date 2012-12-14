Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484Ab2LNAvf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 19:51:35 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41349 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753410Ab2LNAve (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 19:51:34 -0500
Message-ID: <50CA7808.7090307@zytor.com>
Date: Thu, 13 Dec 2012 16:51:20 -0800
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
References: <1355436141-8668-1-git-send-email-yinghai@kernel.org> <1355436141-8668-20-git-send-email-yinghai@kernel.org> <50CA6478.20008@zytor.com> <CAE9FiQURsKT8Ufy7NmWUzrzkYoH65Edk6e_kJkw_+YYx=1bXTg@mail.gmail.com> <50CA7515.9080701@zytor.com> <CAE9FiQXi6XZ9_7CDS_Ypgd59tSouhw8TCePCdJQNC7bhGMO8WQ@mail.gmail.com>
In-Reply-To: <CAE9FiQXi6XZ9_7CDS_Ypgd59tSouhw8TCePCdJQNC7bhGMO8WQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/2012 04:44 PM, Yinghai Lu wrote:
> On Thu, Dec 13, 2012 at 4:38 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> On 12/13/2012 04:13 PM, Yinghai Lu wrote:
>>
>> It is definitely the minmum we can rely on, and so is the minimum we should
>> rely on.  In fact, we don't even need .bss/.brk to be mapped, but we
>> probably should require that as a matter of protocol.
>
> in my version of arch/x86/kernel/head_64.S is using BRK to do
> ident/kernel high mapping
> for kernel that is above 4G.
> so .brk is needed.
>

Yes, with the page fault approach we wouldn't need to do that, so that 
version is the minimum that can, practically, be required (one can 
constrain that even further, down to only needing a handful of pages, 
but that gets progressively more painful for little to no gain.)

However, as I said, rather than tying our hands for the future we should 
include .bss/.brk in the requirement.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

