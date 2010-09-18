Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369Ab0IRJ2B (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 05:28:01 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:59896 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755276Ab0IRJ2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 05:28:00 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v4 1/2] init: add sys-wrapper.h
Date: Sat, 18 Sep 2010 11:27:46 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: Namhyung Kim <namhyung@gmail.com>, Sam Ravnborg <sam@ravnborg.org>,
        Phillip Lougher <phillip@lougher.demon.co.uk>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
References: <1283268619-10728-1-git-send-email-namhyung@gmail.com> <1283268619-10728-2-git-send-email-namhyung@gmail.com> <20100917144024.33e66e53.akpm@linux-foundation.org>
In-Reply-To: <20100917144024.33e66e53.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009181127.47063.arnd@arndb.de>
X-Provags-ID: V02:K0:n2VWznjm/+YnIsqsg6N8FIvhrgkUd7HFV7BFUqWdHuP
 +BuLQY7hZZUWaY/bXerwydQfq+vPAtRyN1fwd9CBi+ZlbQF9fB
 LcuRJEL0zmJ1sVZ9phVkHwDBt1Hs9yz2nc/I0t0oEbEb7s4ZF3
 NJech7rHBDIqPhOJXJtqRi1KnHQT3JzCYR7EEosKaD4ToExN2c
 ZE+ekoVYOyqQfSYGwVWAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 17 September 2010, Andrew Morton wrote:
> > -     int err = sys_mount(name, "/root", fs, flags, data);
> > +     int err = kernel_sys_mount(name, "/root", fs, flags, data);
> 
> It would be good if we could arrange for all kernel syscalls to use
> the wrappers.  ie: cause a direct call to sys_mount() to not compile?
> 
> I don't know how practical that would be.

One common reason to call a sys_* function is to implement another
system call, e.g. sys_socketcall calling sys_socket or
compat_sys_timer_create calling sys_timer_create.

I think in those cases we don't really want to go through another
wrapper.

	Arnd
