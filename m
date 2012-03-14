Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030566Ab2CNClK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 22:41:10 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:57686 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030422Ab2CNClJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 22:41:09 -0400
Date: Tue, 13 Mar 2012 22:41:04 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@shadowen.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] checkpatch: Suggest pr_<level> over printk(KERN_<LEVEL>
Message-ID: <20120314024104.GE15379@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>, Joe Perches <joe@perches.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Whitcroft <apw@shadowen.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <20120313120514.GA17538@thunk.org>
 <20120313145517.f4fcae46.akpm@linux-foundation.org>
 <20120313220144.GD11969@thunk.org>
 <20120313150316.6ae19b95.akpm@linux-foundation.org>
 <20120314003157.GA15379@thunk.org>
 <1331686026.24613.6.camel@joe2Laptop>
 <20120314010701.GB15379@thunk.org>
 <1331687831.27389.2.camel@joe2Laptop>
 <20120314021938.GD15379@thunk.org>
 <1331692311.27389.27.camel@joe2Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331692311.27389.27.camel@joe2Laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2012 at 07:31:51PM -0700, Joe Perches wrote:
> Right now many fs ext4 messages are somewhat opaque
> without any reference to what kernel subsystem produced
> the message.
> 
> For instance:
> 
> fs/ext4/ialloc.c:		printk(KERN_DEBUG "group %lu: stored = %d, counted = %lu\n",
> 
> This is a somewhat senseless output in dmesg without
> any linkage to ext4.
> 
> Using pr_fmt and pr_debug as I sent a patch to do
> instead emits in dmesg:
> 
> EXT4-fs: group: etc...
> 
> Using subsystem prefixes makes it easy and consistent to
> grep dmesg.

That's a debug message which is never by anyone other than ext4
developers.  Your patch also hacked the Makefile to enable it by
default, which also enabled some performance degrading code paths
(again, only enabled by developers who manually drop the #define in a
header file when they are trying to figure out some obscure failure
during the development process).  This is why I don't like people who
are wanking around in code they don't understand just to fix style
fixes, in the mistaken belief that it adds value.

						- Ted
