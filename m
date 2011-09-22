Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425Ab1IVR6l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 13:58:41 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40239 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254Ab1IVR6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 13:58:40 -0400
Date: Thu, 22 Sep 2011 21:57:54 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: kernel-hardening@lists.openwall.com,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/2] proc: force dcache drop on unauthorized access
Message-ID: <20110922175754.GA6558@albatros>
References: <20110910164001.GA2342@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110910164001.GA2342@albatros>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Andrew,

On Sat, Sep 10, 2011 at 20:40 +0400, Vasiliy Kulikov wrote:
> The patch "proc: fix races against execve() of /proc/PID/fd**" is still
> a partial fix for a setxid problem.  link(2) is a yet another way to
> identify whether a specific fd is opened by a privileged process.  By
> calling link(2) against /proc/PID/fd/* an attacker may identify whether
> the fd number is valid for PID by analysing link(2) return code.
> 
> Both getattr() and link() can be used by the attacker iff the dentry is
> present in the dcache.  In this case ->lookup() is not called and the
> only way to check ptrace permissions is either operation handler or
> ->revalidate().  The easiest solution to prevent any unauthorized access
> to /proc/PID/fd*/ files is to force the dentry drop on each unauthorized
> access attempt.
> 
> If an attacker keeps opened fd of /proc/PID/fd/ and dcache contains
> a specific dentry for some /proc/PID/fd/XXX, any future attemp to use the
> dentry by the attacker would lead to the dentry drop as a result of a
> failed ptrace check in ->revalidate().  Then the attacker cannot spawn a
> dentry for the specific fd number because of ptrace check in ->lookup().
> 
> The dentry drop can be still observed by an attacker by analysing
> information from /proc/slabinfo, which is addressed in the successive
> patch.

After (almost) everybody agreed that closing slabinfo and similar is
a good thing, should I resend these 2 patches (/proc/PID/fd and
slabinfo) with sysfs addition or you'll take these patches and I'll send
sysfs patch after them?

Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
