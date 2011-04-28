Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756846Ab1D1DkL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 23:40:11 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:49649 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836Ab1D1DkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 23:40:10 -0400
Date: Thu, 28 Apr 2011 04:40:03 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Will Drewry <wad@chromium.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, kees.cook@canonical.com,
        eparis@redhat.com, agl@chromium.org, mingo@elte.hu, jmorris@namei.org,
        rostedt@goodmis.org, Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        David Howells <dhowells@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Stephen Wilson <wilsons@start.ca>
Subject: Re: [PATCH 4/7] seccomp_filter: add process state reporting
Message-ID: <20110428034003.GG9487@ZenIV.linux.org.uk>
References: <1303960136-14298-1-git-send-email-wad@chromium.org>
 <1303960136-14298-3-git-send-email-wad@chromium.org>
 <20110428122334.D197.A69D9226@jp.fujitsu.com>
 <BANLkTinfXZ3j0vG51=cQjM0FZQ5VR5ze8A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTinfXZ3j0vG51=cQjM0FZQ5VR5ze8A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 27, 2011 at 10:24:20PM -0500, Will Drewry wrote:

> Definitely.  Would it make sense to have /proc/<pid>/seccomp and
> /proc/<pid>/seccomp_filter?

Just one question: WTF bother with S_IRUSR?  Note that it's absolutely
_useless_ in procfs; any kind of permission checks must be done in
read(2) time since doing it in open(2) is worthless.  Consider execve()
on suid binary; oops, there goes your uid and there goes the effect
of checks done by open(2).  And if you *do* checks in read(2), why bother
duplicating them in open(2)?
