Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758816Ab2ECVac (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 17:30:32 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:37945 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753382Ab2ECVab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 17:30:31 -0400
Date: Thu, 3 May 2012 17:30:30 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Tejun Heo <tj@kernel.org>
cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Lockdep false positive in sysfs
In-Reply-To: <20120427160902.GO27486@google.com>
Message-ID: <Pine.LNX.4.44L0.1205031720480.1232-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Apr 2012, Tejun Heo wrote:

> > Would it be better to release just the lockdep annotation while
> > continuing to hold the actual lock, or to really drop the lock?
> 
> Just the lockdep annotation, I think.

This is turning out to be harder than it looked.

In order to release the lockdep annotation, I need the lockdep_map
which is stored in the sysfs_dirent structure.  But when the attribute
method is called, all it is given is a pointer to the attribute itself
(which contains the lockdep_class_key but not the lockdep_map) and a
pointer to the corresponding kobject.

Is there any reasonable way to get from the kobject and the attribute
to the appropriate sysfs_dirent?  Search through all the groups
attached to the kobject?  Restrict the new interface so that it can be
used only by attributes at the kobject's top level (i.e., not in a
named group)?

Any suggestions?

Alan Stern

