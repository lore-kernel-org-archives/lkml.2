Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755436Ab0IRJo3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 05:44:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40144 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755376Ab0IRJo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 05:44:28 -0400
Date: Sat, 18 Sep 2010 02:50:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Namhyung Kim <namhyung@gmail.com>, Sam Ravnborg <sam@ravnborg.org>,
        Phillip Lougher <phillip@lougher.demon.co.uk>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/2] init: add sys-wrapper.h
Message-Id: <20100918025057.ae9c3ce3.akpm@linux-foundation.org>
In-Reply-To: <201009181127.47063.arnd@arndb.de>
References: <1283268619-10728-1-git-send-email-namhyung@gmail.com>
	<1283268619-10728-2-git-send-email-namhyung@gmail.com>
	<20100917144024.33e66e53.akpm@linux-foundation.org>
	<201009181127.47063.arnd@arndb.de>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 18 Sep 2010 11:27:46 +0200 Arnd Bergmann <arnd@arndb.de> wrote:

> On Friday 17 September 2010, Andrew Morton wrote:
> > > -     int err = sys_mount(name, "/root", fs, flags, data);
> > > +     int err = kernel_sys_mount(name, "/root", fs, flags, data);
> > 
> > It would be good if we could arrange for all kernel syscalls to use
> > the wrappers.  ie: cause a direct call to sys_mount() to not compile?
> > 
> > I don't know how practical that would be.
> 
> One common reason to call a sys_* function is to implement another
> system call, e.g. sys_socketcall calling sys_socket or
> compat_sys_timer_create calling sys_timer_create.
> 
> I think in those cases we don't really want to go through another
> wrapper.

The overhead is zero in the case of sys_socket() and somewhat non-zero
in the case of sys_timer_create().  I can't immediately see a
convenient way of reducing "somewhat" to zero.

