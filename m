Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757040Ab1KVP3q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 10:29:46 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:46177 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756583Ab1KVP3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 10:29:45 -0500
Date: Tue, 22 Nov 2011 07:29:39 -0800
From: Tejun Heo <tj@kernel.org>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@linux.intel.com>, Roland McGrath <roland@hack.frob.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        James Bottomley <jbottomley@parallels.com>
Subject: Re: [RFC][PATCH 0/3] fork: Add the ability to create tasks with
 given pids
Message-ID: <20111122152939.GC322@google.com>
References: <4EC4F2FB.408@parallels.com>
 <20111117154936.GB12325@redhat.com>
 <4EC52FBF.1010407@parallels.com>
 <20111118233055.GA29378@google.com>
 <4ECA1696.5060500@parallels.com>
 <20111121225019.GQ25776@google.com>
 <4ECB8346.8040806@parallels.com>
 <20111122152312.GB322@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111122152312.GB322@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 22, 2011 at 07:23:12AM -0800, Tejun Heo wrote:
> I think the question should usually be the other way around.  Why
> deviate when the deviation doesn't earn any tangible benefit?  If you
> think setting it explicitly is justified, explain why in the comment
> of the setter and places where those explicit settings are.

Hmmm... I think I trimmed a bit too much.  Let me add back a bit.

So, either just use set_last_pid() or explain in the comment of
set_last_pid() that there are other places which set last_pid but it
won't race because they're synchronized through outer lock and similar
comment where the explicit setting of last_pid is too.  As it
currently stands, it really is difficult to find out who else would be
changing last_pid - it's buried in an argument to a proc parse
function.  IMHO just using set_last_pid() would be better here.

Thanks.

-- 
tejun
