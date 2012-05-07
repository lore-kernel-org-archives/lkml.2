Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757726Ab2EGTP6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 15:15:58 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:48761 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757664Ab2EGTP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 15:15:57 -0400
MIME-Version: 1.0
In-Reply-To: <1336417641-29771-1-git-send-email-suresh.b.siddha@intel.com>
References: <1336417641-29771-1-git-send-email-suresh.b.siddha@intel.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 7 May 2012 12:15:35 -0700
X-Google-Sender-Auth: qbBzU2NURc2JVDCby9gnnRWZjzs
Message-ID: <CA+55aFwsZu6YhfeKp17TuiZuyxEXgReXVUMh+_drM7410SBiyg@mail.gmail.com>
Subject: Re: [PATCH 1/2] coredump: flush the fpu exit state for proper
 multi-threaded core dump
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: hpa@zytor.com, mingo@elte.hu, oleg@redhat.com, suresh@aristanetworks.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 7, 2012 at 12:07 PM, Suresh Siddha
<suresh.b.siddha@intel.com> wrote:
>
> Fix this by explicitly flushing the fpu state in do_exit() by calling
> prepare_to_copy()

Ugh, I hate this one.

We're making the exit path more expensive for almost no gain. The FPU
state is dead in 99.9% of all cases.

Why isn't this a core-dump-only case?

                    Linus
