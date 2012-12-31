Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754179Ab2LaDco (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2012 22:32:44 -0500
Received: from mail-da0-f54.google.com ([209.85.210.54]:47312 "EHLO
	mail-da0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905Ab2LaDcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2012 22:32:41 -0500
MIME-Version: 1.0
Date: Mon, 31 Dec 2012 11:32:39 +0800
Message-ID: <CACV3sb+69VQMM44vXx_-AdOZmbz18zZeVdmi1+YHEq7kZ_VmdA@mail.gmail.com>
Subject: [RFC] ktap: Another dynamic tracing tool for Linux
From: Jovi Zhang <bookjovi@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This mail is RFC for discuss on a new dynamic tracing tool, I name it
ktap. (only experimental project now)

I'm working at Linux embedded world long time,
when I noticed systemtap is not suit for my dynamic tracing
requirement(systemtap need to run gcc),
so I decide to write this experimental project ktap, for safe,
lightweight, extendable, easy to use, and funny.
ktap use script language to let user trace Linux kernel dynamically,
ktap is like Systemtap, and Dtrace in Solaris.

what ktap differentiates with Systemtap is:
1). ktap don't depend on gcc, you don't need to compile kernel module,
and even without root privileged in future.
      this resolve some limitation of Systemtap.
      In many usecase, it's not possible to compile source file to ko
easily, depend on product environment (like embedded).

2). ktap have good portability, because it compile source file to
bytecode, like python and Java.

3). ktap use it own simple dynamic typed script language, this
language include built-in hash table support.

4). ktap is safe, whatever you doing in script file, you will never
crash your kernel.

5). ktap will be open source completely, with GPL license, it might be
merge into mainline in someday, that's very convince for tracing user.


what ktap differentiates with Dtrace in Solaris is:
6). it's not Dtrace porting for Linux, it a new tool build from scratch.

7). The language is not D, it's a dynamic typed language which like lua
      currently ktap use lua syntax and bytecode, but it may change it
when need in future.

8). ktap is GPL licensed, so there don't have any license issue when
upstream(if possible in future)

ktap have a userspace compiler tool "ktapc", ktapc compile ktap source
file to .ktap bytecode chunk file,
then ktap binary load and run the chunk bytecode file, there have a
kernel module ktapvm executing .ktap bytecode.

ktap use lua language syntax and bytecode as initial implementation,
why lua? the reason is:
lua is small, syntax is clean, no complex language feature, few
bytecode, expendable, the virtual machine is
smaller than other script language like python and perl, it have
built-in hashtable data structure support, which proving
helpful for tracing purpose.
(ktap just borrow syntax and bytecode from lua initially,  there
should not have any relation with lua after ktap release,
ktap will have its own road)


ktap implementation is not completely finish yet, there already have a
workable ktap version,
it support basic syscall and tracepoint tracing currently, in future,
it could support kprobe, uprobe, userspace probe, etc.

that's all about ktap until now.
I wish you can give me some technical architecture pre-review for
ktap, before ktap release 1.0.
Any comments is welcome, thanks very much.

.jovi
