Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692Ab1LFS7w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 13:59:52 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46293 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836Ab1LFS7u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 13:59:50 -0500
MIME-Version: 1.0
In-Reply-To: <CAJfuBxyyriN6vYgwzEft9PKFjWsa2E4FZmbFMmtO6G_DP=nosg@mail.gmail.com>
References: <CAJfuBxyyriN6vYgwzEft9PKFjWsa2E4FZmbFMmtO6G_DP=nosg@mail.gmail.com>
From: Jim Cromie <jim.cromie@gmail.com>
Date: Tue, 6 Dec 2011 11:59:18 -0700
Message-ID: <CAJfuBxzM6rg21Rpq+ww+=2qK_am44V-Btvhp3Z3hbP2TKP8JTw@mail.gmail.com>
Subject: Re: [patch 00/25] dynamic-debug enhancements
To: LKML <linux-kernel@vger.kernel.org>, Jason Baron <jbaron@redhat.com>
Cc: Greg KH <greg@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 30, 2011 at 1:27 PM, Jim Cromie <jim.cromie@gmail.com> wrote:
> this patchset adds
> - dynamic-debug during module initialization
> - multiple queries in ddebug_query, module.dyndbg
>
> Unlike previous versions, it drops the pending-query approach in
> favor of  "fake module parameters"proposed by Thomas Renninger
>    https://lkml.org/lkml/2010/9/15/397
>
> Its based upon 3.2-rc3, since that has several patches to
> include/linux/dynamic_debug.h
> that are not in driver-core-next, and theyd need to be handled eventually.
>
> 1 - trivial bug in kernel/module.c under DEBUGP
> 2 - whitespace
> 3-12 dyndbg cleanups
> 13-17 multiple queries
> 18-25 dynamic-debug during module initialization
>

This revision follows Rusty's, Jason's advice, and drops previously added
ddebug_(boot|module)_parse_args(), instead using a new callback function,
ddebug_dyndbg_param_cb(), invoked by kernel/module.c: parse_one(),
to handle unknown args

Ive also consolidated Thomas's original patch with my adjustments,
mostly to reduce churn around the above, and the ddebug -> dyndbg
param-name change.

WRT pnp.debug, vs pnp.dyndbg parameters, Ive kept the 2 of them,
since latter is fake, former is real, and the usages are quite different.
It seems the least suboptimal of the choices, and easiest to explain.

Im resending entire set, although 1-~18 are identical.
One patch has trivial alteration fixing a const char * mismatch,
not sure which one - sorry about the bookkeeping fail.

You can also get this patchset here:
git://github.com/jimc/linux-2.6.git  dyndbg/modinit-1205


[dyndbg/modinit-x1 c44ca6c] dynamic_debug: remove unneeded includes
 1 files changed, 0 insertions(+), 10 deletions(-)
[jimc@groucho linux-2.6]$    git diff --stat v3.2-rc3..HEAD
 Documentation/dynamic-debug-howto.txt |  110 ++++++++++---
 Documentation/kernel-parameters.txt   |   23 ++-
 drivers/pnp/base.h                    |    8 +-
 drivers/pnp/core.c                    |   12 ++
 include/linux/device.h                |    8 +-
 include/linux/dynamic_debug.h         |   30 +++-
 include/linux/kernel.h                |   10 +
 include/linux/moduleparam.h           |    3 +-
 include/linux/netdevice.h             |    8 +-
 include/linux/printk.h                |    8 +-
 init/main.c                           |    7 +-
 kernel/module.c                       |   49 +++---
 kernel/params.c                       |   24 +--
 lib/Kconfig.debug                     |   15 +-
 lib/dynamic_debug.c                   |  306 ++++++++++++++++++++++----------
 15 files changed, 423 insertions(+), 198 deletions(-)


with a little luck, I'll get the in-reply-to correct on the
git-send-email to follow.

thanks
Jim Cromie
