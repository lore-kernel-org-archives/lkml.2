Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933383Ab0KORpf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 12:45:35 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:62338 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933227Ab0KORpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 12:45:30 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTin7Sfx5rnU3u7da5bQQiLTj9geOMht-x6z6kvid@mail.gmail.com>
References: <1289669176.16461.12.camel@Joe-Laptop>
	<AANLkTi=ut2O+mCbs1jOyg-aP=E+48h1B-MH8NxK5XyVf@mail.gmail.com>
	<1289677904.16461.82.camel@Joe-Laptop>
	<AANLkTikWEZLwx4khj_jFOqP+uy-TxgJGwsbxdtaCfbJq@mail.gmail.com>
	<AANLkTik=mnFDXAyJ53_7FPfD5ETiYY8GjkE5pm0PJSBu@mail.gmail.com>
	<AANLkTimoFGqKDYe24uc_2EHk-MLqxc4GGCCe7hPRJqbJ@mail.gmail.com>
	<AANLkTin7Sfx5rnU3u7da5bQQiLTj9geOMht-x6z6kvid@mail.gmail.com>
Date: Mon, 15 Nov 2010 12:45:28 -0500
Message-ID: <AANLkTikG=brgFP3yuWqMp=4ntHV=kyuhCUODZNp4Uo6Y@mail.gmail.com>
Subject: Re: [PATCH] Fix dmesg_restrict build failure with CONFIG_EMBEDDED=y
 and CONFIG_PRINTK=n
From: Eric Paris <eparis@parisplace.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>, Dan Rosenberg <drosenberg@vsecurity.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Eugene Teo <eugeneteo@kernel.org>, Kees Cook <kees.cook@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Morris <jmorris@namei.org>,
        LSM List <linux-security-module@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 15, 2010 at 12:41 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> If the old rule should have been that you _have_
> to call cap_syslog(), then just eviscerating that entirely and putting
> it in the generic code is definitely the right thing.

That is the rule for ALL of the hooks in commoncap.c.  The one time I
tried to do something else *cough*mmap_min_addr*cough* I screwed it
up.  I'll put a note in my todo list about looking into lifting all of
commoncap.c into the callers.

-Eric
