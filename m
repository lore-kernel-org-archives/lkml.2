Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965267Ab2CNCby (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 22:31:54 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:36401 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S964959Ab2CNCbw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 22:31:52 -0400
Message-ID: <1331692311.27389.27.camel@joe2Laptop>
Subject: Re: [PATCH] checkpatch: Suggest pr_<level> over printk(KERN_<LEVEL>
From: Joe Perches <joe@perches.com>
To: "Ted Ts'o" <tytso@mit.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@shadowen.org>, LKML <linux-kernel@vger.kernel.org>
Date: Tue, 13 Mar 2012 19:31:51 -0700
In-Reply-To: <20120314021938.GD15379@thunk.org>
References: <1330667673.1939.22.camel@joe2Laptop>
	 <1331619783.7100.8.camel@joe2Laptop> <20120313120514.GA17538@thunk.org>
	 <20120313145517.f4fcae46.akpm@linux-foundation.org>
	 <20120313220144.GD11969@thunk.org>
	 <20120313150316.6ae19b95.akpm@linux-foundation.org>
	 <20120314003157.GA15379@thunk.org> <1331686026.24613.6.camel@joe2Laptop>
	 <20120314010701.GB15379@thunk.org> <1331687831.27389.2.camel@joe2Laptop>
	 <20120314021938.GD15379@thunk.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-03-13 at 22:19 -0400, Ted Ts'o wrote:
> On Tue, Mar 13, 2012 at 06:17:11PM -0700, Joe Perches wrote:
> > The patch was all apiece, every bit associated to logging output.
> > It was bundled to make it easier to apply.
> > 
> > You call it junk, I call it cleanups.
> 
> Changing stuff to pr_foo is ***NOISE***.  It adds no value, and it
> makes it my life much, MUCH harder.

I dispute that it add no value.

pr_<foo> adds value to the dmesg output because
it can be consistently prefixed via pr_fmt.

Right now many fs ext4 messages are somewhat opaque
without any reference to what kernel subsystem produced
the message.

For instance:

fs/ext4/ialloc.c:		printk(KERN_DEBUG "group %lu: stored = %d, counted = %lu\n",

This is a somewhat senseless output in dmesg without
any linkage to ext4.

Using pr_fmt and pr_debug as I sent a patch to do
instead emits in dmesg:

EXT4-fs: group: etc...

Using subsystem prefixes makes it easy and consistent to
grep dmesg.

cheers, Joe

