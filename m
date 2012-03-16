Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423112Ab2CPQ3F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 12:29:05 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:57174 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1031359Ab2CPQ3E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 12:29:04 -0400
Message-ID: <1331915341.9591.2.camel@joe2Laptop>
Subject: Re: [PATCH 1/9] ext4: Add -DDEBUG to Makefile
From: Joe Perches <joe@perches.com>
To: David Daney <david.daney@cavium.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 16 Mar 2012 09:29:01 -0700
In-Reply-To: <4F63646D.1040700@cavium.com>
References: <cover.1331856299.git.joe@perches.com>
	 <7ee60f3b750f4500f9bdcb64f358acbf17987036.1331856300.git.joe@perches.com>
	 <4F63646D.1040700@cavium.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-03-16 at 09:03 -0700, David Daney wrote:
> On 03/15/2012 05:07 PM, Joe Perches wrote:
> > Add -DDEBUG to enable future use of pr_debug.
> > No changes to objects as no DEBUG uses currently exist.
[]
> > diff --git a/fs/ext4/Makefile b/fs/ext4/Makefile
[]
> > +ccflags-$(CONFIG_EXT4_FS) := -DDEBUG

> In many other susbsystems/drivers, the definition of DEBUG is gated by a 
> separate Kconfig symbol used to select debugging just for that 
> susbsystem/driver (see CONFIG_MMC_DEBUG for example).
> 
> Why aren't you doing the same here?

It can be done later with an additional symbol if
desired.

For now the current code uses printk(KERN_DEBUG and a
straight conversion to pr_debug would eliminate the
KERN_DEBUG the output.

pr_debug without #define DEBUG or dynamic_debug is
compiled away to nothing.


