Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756311Ab2BQCWd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 21:22:33 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:52715 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753305Ab2BQCWa convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 21:22:30 -0500
MIME-Version: 1.0
In-Reply-To: <1329443688.15226.16.camel@joe2Laptop>
References: <1329422549-16407-1-git-send-email-wad@chromium.org>
	<1329443688.15226.16.camel@joe2Laptop>
Date: Thu, 16 Feb 2012 20:22:28 -0600
Message-ID: <CABqD9harZap1LUmcYH8w5gpFktVunYjV9UbKNTbBjqsUf+ThgQ@mail.gmail.com>
Subject: Re: [PATCH v8 1/8] sk_run_filter: add support for custom load_pointer
From: Will Drewry <wad@chromium.org>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-doc@vger.kernel.org, kernel-hardening@lists.openwall.org,
        netdev@vger.kernel.org, x86@kernel.org, arnd@arndb.de,
        davem@davemloft.net, hpa@zytor.com, mingo@redhat.com, oleg@redhat.com,
        peterz@infradead.org, rdunlap@xenotime.net, mcgrathr@chromium.org,
        tglx@linutronix.de, luto@mit.edu, eparis@redhat.com,
        serge.hallyn@canonical.com, djm@mindrot.org, scarybeasts@gmail.com,
        indan@nul.nu, pmoore@redhat.com, akpm@linux-foundation.org,
        corbet@lwn.net, eric.dumazet@gmail.com, markus@chromium.org,
        keescook@chromium.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 16, 2012 at 7:54 PM, Joe Perches <joe@perches.com> wrote:
> On Thu, 2012-02-16 at 14:02 -0600, Will Drewry wrote:
>> This change allows CONFIG_SECCOMP to make use of BPF programs for
>> user-controlled system call filtering (as shown in this patch series).
> []
>> diff --git a/net/core/filter.c b/net/core/filter.c
> []
>> @@ -542,9 +602,35 @@ int sk_chk_filter(struct sock_filter *filter, unsigned int flen)
> []
>>               case BPF_S_LD_W_ABS:
>> +                     MAYBE_USE_LOAD_FN(LD_W_ABS);
>>               case BPF_S_LD_H_ABS:
>> +                     MAYBE_USE_LOAD_FN(LD_H_ABS);
>>               case BPF_S_LD_B_ABS:
>> +                     MAYBE_USE_LOAD_FN(LD_B_ABS);
>
> Would be nice to note fallthrough or add break if necessary.

Cool - I'll note it.  They are meant to fall through, but I can just
go back to using goto handle_skb_load or some such so it is more
readable.

Thanks!
