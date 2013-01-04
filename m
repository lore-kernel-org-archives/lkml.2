Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339Ab3ADVuY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 16:50:24 -0500
Received: from mail-bk0-f42.google.com ([209.85.214.42]:55087 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755254Ab3ADVuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 16:50:19 -0500
MIME-Version: 1.0
In-Reply-To: <20130104071737.GA20905@x1.alien8.de>
References: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
	<1357260531-11115-2-git-send-email-yinghai@kernel.org>
	<20130104071737.GA20905@x1.alien8.de>
Date: Fri, 4 Jan 2013 13:50:18 -0800
X-Google-Sender-Auth: 7GJvw_outUCGKPZf97znFO0hfxU
Message-ID: <CAE9FiQXpAJgS_ADW-c23QsqywsX=vL_PSg=crYgLgep5nzVpxg@mail.gmail.com>
Subject: Re: [PATCH v7u1 01/31] x86, mm: Fix page table early allocation
 offset checking
From: Yinghai Lu <yinghai@kernel.org>
To: Borislav Petkov <bp@alien8.de>, Yinghai Lu <yinghai@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 3, 2013 at 11:17 PM, Borislav Petkov <bp@alien8.de> wrote:
> On Thu, Jan 03, 2013 at 04:48:21PM -0800, Yinghai Lu wrote:
>> During debugging loading kernel above 4G, found one page if is not used
>> in BRK with early page allocation.
>>
>> pgt_buf_top is address that can not be used, so should check if that new
>> end is above that top, otherwise last page will not be used.
>>
>> Fix that checking and also add print out for every allocation from BRK.
>
> This commit message still bothers the hell out of me. Please, fix it up
> to something more readable like the below, for example:
>
> "pgt_buf_top is an address which cannot be used so we should check
> whether the new 'end' is above it. Otherwise, the last BRK page remains
> unused.
>
> Fix that check and add a debug printout of every BRK allocation."

but your changelog is wrong.

it is NOT last BRK page.

it is NOT every BRK allocation.
