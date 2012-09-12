Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758450Ab2ILBQ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 21:16:59 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:40804 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753200Ab2ILBQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 21:16:57 -0400
Date: Wed, 12 Sep 2012 02:16:54 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Meredydd Luff <meredydd@senatehouse.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Kees Cook <keescook@chromium.org>, Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH signal#execve2] syscalls,x86: Add execveat() system call
 (v3)
Message-ID: <20120912011654.GQ13973@ZenIV.linux.org.uk>
References: <1347411352-12392-1-git-send-email-meredydd@senatehouse.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347411352-12392-1-git-send-email-meredydd@senatehouse.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2012 at 01:55:52AM +0100, Meredydd Luff wrote:
> Al (in particular): I've reworked this on top of your generic
> execve() changes, as well as incorporating feedback from HPA.
> Could you take another look please (and merge if all is well)?
> 
> [v3: now rebased onto signal.git#execve2, and takes a flags
> parameter which understands AT_SYMLINK_NOFOLLOW; all thanks to
> feedback from https://lkml.org/lkml/2012/8/1/418]
> 
> HPA is already on record calling for an execveat() which also does
> fexecve()'s job: https://lkml.org/lkml/2006/7/11/556.
> And the current glibc hack for fexecve() is already causing problems
> in the wild. Eg: https://bugzilla.redhat.com/show_bug.cgi?id=241609,
> https://lkml.org/lkml/2006/12/27/123, and as recounted at
> http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=514043.

Please, declare open_execat(), leaving open_exec() as it is (i.e. a
trivial wrapper for open_execat()).  Would cut down on the patch
footprint a bit...

> +	bprm->filename = filename ?:
> +			(const char *) file->f_path.dentry->d_name.name;

Absolutely not.  If nothing else, ->d_name can change on rename() *and*
get underlying memory freed.  At zero notice.
