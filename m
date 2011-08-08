Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239Ab1HHQKA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 12:10:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53949 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752645Ab1HHQJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 12:09:59 -0400
MIME-Version: 1.0
In-Reply-To: <20110808151038.17366.38130.stgit@warthog.procyon.org.uk>
References: <20110808151038.17366.38130.stgit@warthog.procyon.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 8 Aug 2011 09:09:04 -0700
Message-ID: <CA+55aFz1aoSMLHwD1BrNpGO95k+_PYqFG0fySNMh6dT5JVGJuQ@mail.gmail.com>
Subject: Re: [PATCH] autofs4: Use no_printk() for no-op DPRINTK() and use
 __VA_ARGS__ too
To: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, autofs@linux.kernel.org,
        Ian Kent <raven@themaw.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 8, 2011 at 8:10 AM, David Howells <dhowells@redhat.com> wrote:
> Use no_printk() for autofs's no-op DPRINTK() to prevent unused statements from
> becoming accidentally obsolete, and use __VA_ARGS__ too as that's the standard
> way.

Gaah. May I suggest just avoiding the duplication by doing

   #ifdef DEBUG
   # define autofs_debug_printk printk
   #else
   # define autofs_debug_printk no_printk
   #endif

   #define DPRINTK(fmt, ...)                                      \
       autofs_debug_printk(KERN_DEBUG "pid %d: %s: " fmt "\n",           \
                 current->pid, __func__, ##__VA_ARGS__)

which also drops the pointless do { } while (0) protection since it's
already a well-formed statement?

                         Linus
