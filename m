Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758651Ab1ELUlE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 16:41:04 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:60690 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758600Ab1ELUlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 16:41:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=SIvsIln1+WTIeXSSSnML7BgOwI+UxKcBpRAFqvivKCtX8rFkoed1kAOVEhuoZhWXf8
         DQSbng9IW97Z7bkbNKM9YWupRbVesy2uax1EPUzRfOagsOdrzaKXSotYcUNMpOeL5E6y
         5I31WGG0d+vIgTS3YHfe8RCjUkb3/V08CQjX8=
Date: Thu, 12 May 2011 22:40:54 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 2/2] x86: Make the x86-64 stacktrace code safely
 callable from scheduler
Message-ID: <20110512204051.GD7410@nowhere>
References: <1305232326-9804-1-git-send-email-fweisbec@gmail.com>
 <1305232326-9804-3-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305232326-9804-3-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 12, 2011 at 10:32:06PM +0200, Frederic Weisbecker wrote:
> Avoid potential scheduler recursion and deadlock from the
> stacktrace code by avoiding rescheduling when we re-enable
> preemption.
> 
> This robustifies some scheduler trace events like sched switch
> when they are used to produce callchains in perf or ftrace.

Actually trace events are already safe because they already disable
preemption so callchains won't call schedule() there. But still
let's be careful, we never know how stacktrace can be used.
