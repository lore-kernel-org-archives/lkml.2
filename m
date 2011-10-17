Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756581Ab1JQWnO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 18:43:14 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43875 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756391Ab1JQWnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 18:43:13 -0400
MIME-Version: 1.0
In-Reply-To: <20111017.175141.1489173261757833533.davem@davemloft.net>
References: <1318882661-26859-1-git-send-email-dpmcgee@gmail.com>
	<20111017.175141.1489173261757833533.davem@davemloft.net>
Date: Mon, 17 Oct 2011 17:43:11 -0500
Message-ID: <CAEik5nPXQXESnNLJCWd48LLiEYsN6MgnjKhd_a4SMHFGHBbm8w@mail.gmail.com>
Subject: Re: [PATCH] powerpc/mm: remove hack in mmap randomize layout
From: Dan McGee <dpmcgee@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: linuxppc-dev@lists.ozlabs.org, benh@kernel.crashing.org, paulus@samba.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 17, 2011 at 4:51 PM, David Miller <davem@davemloft.net> wrote:
> From: Dan McGee <dpmcgee@gmail.com>
> Date: Mon, 17 Oct 2011 15:17:36 -0500
>
>> Since commit 8a0a9bd4db63bc45e301, this comment in mmap_rnd() does not
>> hold true as the value returned by get_random_int() will in fact be
>> different every single call. Remove the comment and simplify the code
>> back to its original desired form.
>>
>> This reverts commit a5adc91a4b44b5d1 which is no longer necessary.
>>
>> Signed-off-by: Dan McGee <dpmcgee@gmail.com>
>
> Can you please fix up all the other architectures which use the same
> logic, because they have simply copied over what powerpc does?
>
> At a minimum, Sparc has two such locations.
Aha, I wasn't aware this was also being done elsewhere as there was no
comment to tip me off. I found the one in
arch/sparc/kernel/sys_sparc_64.c (mmap_rnd) and have fixed that
locally and will resend, but I'm not seeing get_random_int() in use
anywhere else in that architecture so I'm not quite sure where your
second mentioned location is- or did you just mean the two calls 2
lines apart in mmap_rnd()?

I also did a quick glance over every other usage and didn't seen any
other architectures doing anything funky, even in a slightly different
way.

-Dan
