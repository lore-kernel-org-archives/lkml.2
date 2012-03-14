Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030663Ab2CNDBR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 23:01:17 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:48400 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030539Ab2CNDBP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 23:01:15 -0400
Message-ID: <1331694074.27389.42.camel@joe2Laptop>
Subject: Re: [PATCH] checkpatch: Suggest pr_<level> over printk(KERN_<LEVEL>
From: Joe Perches <joe@perches.com>
To: "Ted Ts'o" <tytso@mit.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@shadowen.org>, LKML <linux-kernel@vger.kernel.org>
Date: Tue, 13 Mar 2012 20:01:14 -0700
In-Reply-To: <20120314024104.GE15379@thunk.org>
References: <20120313120514.GA17538@thunk.org>
	 <20120313145517.f4fcae46.akpm@linux-foundation.org>
	 <20120313220144.GD11969@thunk.org>
	 <20120313150316.6ae19b95.akpm@linux-foundation.org>
	 <20120314003157.GA15379@thunk.org> <1331686026.24613.6.camel@joe2Laptop>
	 <20120314010701.GB15379@thunk.org> <1331687831.27389.2.camel@joe2Laptop>
	 <20120314021938.GD15379@thunk.org> <1331692311.27389.27.camel@joe2Laptop>
	 <20120314024104.GE15379@thunk.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-03-13 at 22:41 -0400, Ted Ts'o wrote:
> On Tue, Mar 13, 2012 at 07:31:51PM -0700, Joe Perches wrote:
> > Right now many fs ext4 messages are somewhat opaque
> > without any reference to what kernel subsystem produced
> > the message.
> > 
> > For instance:
> > 
> > fs/ext4/ialloc.c:		printk(KERN_DEBUG "group %lu: stored = %d, counted = %lu\n",
> > 
> > This is a somewhat senseless output in dmesg without
> > any linkage to ext4.
> > 
> > Using pr_fmt and pr_debug as I sent a patch to do
> > instead emits in dmesg:
> > 
> > EXT4-fs: group: etc...
> > 
> > Using subsystem prefixes makes it easy and consistent to
> > grep dmesg.
> 
> That's a debug message which is never by anyone other than ext4
> developers.  Your patch also hacked the Makefile to enable it by
> default,

It's just an example and no it didn't.
That output is still in an #ifdef EXT4FS_DEBUG
block and is unchanged.

What I did was #define DEBUG so pr_debug
(and so dynamic_debug if desired as well)
emits output to dmesg.

+ccflags-$(CONFIG_EXT4_FS) := -DDEBUG

ext4 doesn't currently use any #ifdef DEBUG blocks.

> which also enabled some performance degrading code paths
> (again, only enabled by developers who manually drop the #define in a
> header file when they are trying to figure out some obscure failure
> during the development process).  This is why I don't like people who
> are wanking around in code they don't understand just to fix style
> fixes, in the mistaken belief that it adds value.

cheers, Joe

