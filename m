Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752246Ab0LURyW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 12:54:22 -0500
Received: from mail-bw0-f45.google.com ([209.85.214.45]:38088 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490Ab0LURyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 12:54:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=JQCK4nB9C7hdVq11svuL0G0QcF7WeAAfDmde8h+x3r+Drd+F2Q0b3QhCgfFqYoArxS
         0O7dRuYtV1bR8zh4hRZ0+TLRlSY7TtbJ6dj0lhqHoEde76Nd4WotSLT/U62WsK9QQy/v
         EcrI1LTm7T/aC43y26U8v0QA0zAxu3LTij10E=
Date: Tue, 21 Dec 2010 18:54:16 +0100
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: roland@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, rjw@sisk.pl,
        jan.kratochvil@redhat.com
Subject: Re: [PATCH 13/16] ptrace: reorganize __ptrace_unlink() and
 ptrace_untrace()
Message-ID: <20101221175415.GJ13285@htj.dyndns.org>
References: <1291654624-6230-1-git-send-email-tj@kernel.org>
 <1291654624-6230-14-git-send-email-tj@kernel.org>
 <20101220181516.GB18070@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101220181516.GB18070@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Dec 20, 2010 at 07:15:16PM +0100, Oleg Nesterov wrote:
> OK. Of course, I do not blame this patch, this mimics the current
> behaviour.
> 
> But, afaics, this is not exactly right in the long term. Suppose
> that SIGNAL_STOP_STOPPED is set but the tracee is running (this can
> happen if, say, debugger resumes the tracee and exits). In this case,
> I think this thread should be stopped too.

Yes, that would be the more consistent behavior.

> IIRC, I already tried to do this, but the patch (or idea) was nacked
> because it means another user-visible change. However, if we want to
> really fix things, we should fix this case too. If SIGNAL_STOP_STOPPED
> is set, there should be no running threads after detach.

Aside from the user-visible change part, I don't think the
implemnentation would be difficult.

> Or. We can change the rules for ptrace_resume(), more on this later.

You haven't written this yet, right?  (I reconfigured / migrated my
mail setup during past few days so things are still a bit shaky.)

Thank you.

-- 
tejun
