Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760147Ab1LPQGH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 11:06:07 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45357 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759429Ab1LPQGC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 11:06:02 -0500
Date: Fri, 16 Dec 2011 08:05:56 -0800
From: Tejun Heo <tj@kernel.org>
To: Andrew Vagin <avagin@openvz.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>
Subject: Re: [PATCH 0/2] ptrace: add ability to attach a file descriptor to
 another process
Message-ID: <20111216160556.GB31770@google.com>
References: <1324032383-791758-1-git-send-email-avagin@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324032383-791758-1-git-send-email-avagin@openvz.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Dec 16, 2011 at 01:46:21PM +0300, Andrew Vagin wrote:
> We need this functionality for checkpointing processes.  Now some parts
> are dumped with help PTRACE_SEIZE.  Parasite code is injected to process
> and it collects information.  This code should save data to somewhere.
> I want to suggest a scheme, when a dumper creates file descriptor and
> attaches it to a target process, then execute parasite code, which closes
> this descriptor at the end.
> 
> We can't create unix sockets or open files, because a process may
> be in another namespaces.

I really dislike this.  This doesn't belong in ptrace at all.  With
parasite, you have full control of the process, there gotta be some
other way to talk back.  Can't you create a management process w/ open
UNIX socket when spawning a namespace?  If that doesn't work, wouldn't
letting it dump to filesystem and retrieving it afterwards work?

Thanks.

-- 
tejun
