Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759236Ab2EDQwi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 12:52:38 -0400
Received: from mail-pz0-f45.google.com ([209.85.210.45]:50138 "EHLO
	mail-pz0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478Ab2EDQwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 12:52:37 -0400
Date: Fri, 4 May 2012 09:52:32 -0700
From: Tejun Heo <tj@kernel.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Lockdep false positive in sysfs
Message-ID: <20120504165232.GB24639@google.com>
References: <20120427160902.GO27486@google.com>
 <Pine.LNX.4.44L0.1205031720480.1232-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1205031720480.1232-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2012 at 05:30:30PM -0400, Alan Stern wrote:
> On Fri, 27 Apr 2012, Tejun Heo wrote:
> 
> > > Would it be better to release just the lockdep annotation while
> > > continuing to hold the actual lock, or to really drop the lock?
> > 
> > Just the lockdep annotation, I think.
> 
> This is turning out to be harder than it looked.
> 
> In order to release the lockdep annotation, I need the lockdep_map
> which is stored in the sysfs_dirent structure.  But when the attribute
> method is called, all it is given is a pointer to the attribute itself
> (which contains the lockdep_class_key but not the lockdep_map) and a
> pointer to the corresponding kobject.
> 
> Is there any reasonable way to get from the kobject and the attribute
> to the appropriate sysfs_dirent?  Search through all the groups
> attached to the kobject?  Restrict the new interface so that it can be
> used only by attributes at the kobject's top level (i.e., not in a
> named group)?
> 
> Any suggestions?

Urgh... I can't think of anything pretty.  How about just marking the
attr as "I'm special" and let sysfs code override lockdep annotation?

Thanks.

-- 
tejun
