Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552Ab1BESwZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 13:52:25 -0500
Received: from complete.lackof.org ([198.49.126.79]:46341 "EHLO
	complete.lackof.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753514Ab1BESwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 13:52:15 -0500
Date: Sat, 5 Feb 2011 11:45:26 -0700
From: dann frazier <dann.frazier@canonical.com>
To: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [Ocfs2-devel] [PATCH] [ocfs2] Use a kobject instead of a kset
Message-ID: <20110205184523.GB5091@dannf.org>
References: <1296837627-7416-1-git-send-email-dann.frazier@canonical.com>
 <20110204175751.GA21472@noexit>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110204175751.GA21472@noexit>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 04, 2011 at 09:58:01AM -0800, Joel Becker wrote:
> On Fri, Feb 04, 2011 at 09:40:27AM -0700, dann.frazier@canonical.com wrote:
> > From: dann frazier <dann.frazier@canonical.com>
> > 
> > We currently allocate a kset and add attributes to its internal kobject.
> > However, Documentation/kobject.txt says only the kset code should manipulate
> > this internal object, and we can get the same results by just creating our
> > own kobject and avoiding a kset altogether.
> 
> 	Hmm, is this actually valid?  I thought you had to be a kset to
> have children.  Did this change at some point?

hey Joel,
 Well, I'm by no means an expert on kobjects - hopefully someone who
is will chime in. I came across this while debugging a sysfs teardown
issue and looking through this code to see if it might be related. I
read through kobject.txt & saw that note about a kset's kobj being for
internal-use only, and then saw that samples/kobject/kobject-example.c
seems to achieve the same goal (a sysfs dir w/ attributes) w/o using a
kset.

The sysfs entries look the same to me before & after this patch:

$ ls -l /sys/fs/ocfs2
total 0
-r--r--r-- 1 root root 4096 Feb  5 11:40 active_cluster_plugin
-rw-r--r-- 1 root root 4096 Feb  5 11:40 cluster_stack
-r--r--r-- 1 root root 4096 Feb  5 11:40 loaded_cluster_plugins
-r--r--r-- 1 root root 4096 Feb  5 11:40 max_locking_protocol

That said, I haven't been able to demonstate that the current code is
causing any actual problems - this was just a cleanup attempt.
