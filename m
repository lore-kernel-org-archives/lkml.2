Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758643Ab1ELUcd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 16:32:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34608 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758615Ab1ELUca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 16:32:30 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTim8mAzZbdOhBodaOFKM5esP-Q+K7g@mail.gmail.com>
References: <BANLkTim8mAzZbdOhBodaOFKM5esP-Q+K7g@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 12 May 2011 13:31:37 -0700
Message-ID: <BANLkTi==OatTqfDbnAmHQA0t2DmokEd-CA@mail.gmail.com>
Subject: Re: [BUG] perf: bogus correlation of kernel symbols
To: Stephane Eranian <eranian@google.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 12, 2011 at 7:48 AM, Stephane Eranian <eranian@google.com> wrote:
>
> I think there is a serious problem with kernel symbol correlation
> with the latest perf in 2.6.39-rc7-tip.

Yeah. It's annoying. It's a "perf" bug, though - triggered by
/proc/sys/kernel/kptr_restrict being set to 1.

The bug is that perf doesn't say "I can't match kernel symbols", but
instead does some crazy matching and gives total crap module
information (I think it just picks the one that shows up last in
/proc/kallsyms).

That said, I have considered just reverting the thing that makes
kptr_restrict be 1 by default. I do like the security implications of
restricting visibility into kernel pointers, but I also think that
security rules that make the system less usable are dubious. So I
dunno.

                           Linus
