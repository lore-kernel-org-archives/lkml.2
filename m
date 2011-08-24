Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756559Ab1HXIfH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 04:35:07 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:16022 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755549Ab1HXIfB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 04:35:01 -0400
Message-ID: <4E54B74D.7070407@parallels.com>
Date: Wed, 24 Aug 2011 12:33:17 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Cyrill Gorcunov <gorcunov@gmail.com>, Al Viro <viro@ZenIV.linux.org.uk>,
        James Bottomley <jbottomley@parallels.com>, Tejun Heo <tj@kernel.org>,
        Glauber Costa <glommer@parallels.com>,
        "containers@lists.osdl.org" <containers@lists.osdl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Nathan Lynch <ntl@pobox.com>, Oren Laadan <orenl@cs.columbia.edu>,
        Daniel Lezcano <dlezcano@fr.ibm.com>,
        LINUXFS-ML <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH resend] vfs: Add ->statfs callback for pipefs
References: <20110824080924.GG29452@sun> <20110824012328.f7bfc68a.akpm@linux-foundation.org>
In-Reply-To: <20110824012328.f7bfc68a.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> OK, I give up - how does it work?
> 
> <goes off and reads the kernel>
> 
> So it appears that the statfs call would previously return -ENOSYS, but
> with this change the statfs will succeed and userspace can then inspect
> f_type.  Yes?  I will fix your changelog by adding a description along these
> lines.

Yes, the primary intention is to get the f_type.

> And I'll ask you to fix it further by telling us why we want to do
> this?  The kernel has had this issue for a long time - why does it now
> matter?

This is required by checkpoint-restart in the userspace to make it
possible to distinguish pipes from fifos. In more details:

When we dump information about task's open files we use the /proc/pid/fd
directoy's symlinks and the fact that opening any of them gives us exactly
the same dentry->inode pair as the original process has. Now if a task 
we're dumping has opened pipe and fifo we need to detect this and act
accordingly. Knowing that an fd with type S_ISFIFO resides on a pipefs
is the most precise way.

Thanks,
Pavel

