Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758850Ab1FQJaB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 05:30:01 -0400
Received: from casper.infradead.org ([85.118.1.10]:42917 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758702Ab1FQJ36 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 05:29:58 -0400
Subject: Re: How to temporary change 'current' (task)
From: Peter Zijlstra <peterz@infradead.org>
To: Vasiliy Kulikov <segooon@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, kernel-hardening@lists.openwall.com
In-Reply-To: <20110617083651.GA5625@albatros>
References: <20110617083651.GA5625@albatros>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 17 Jun 2011 11:29:17 +0200
Message-ID: <1308302957.2355.5.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-06-17 at 12:36 +0400, Vasiliy Kulikov wrote:
> Hi,
> 
> I wonder whether there is a simple way to temporary switch 'current' to
> another task and then switch it back with minimum side effects? 

No.

>  I need
> it to call "reversed" ptrace_may_access() with swapped current and
> target task.  Introducing ptrace_task_may_access_me() would produce too
> much noise in LSM (it also needs reversed security_ptrace_access_check()),
> which is too loud for my needs.
> 
> Specifically, I need it to filter taskstats and proc connector requests
> for a restriction of getting other processes' information:
> 
> http://permalink.gmane.org/gmane.linux.kernel/1155354
> 
> As the check is handled in the context of the ptrace target process,
> ptrace_may_access() doesn't fit my needs.

looking at __ptrace_may_access() it doesn't look too hard to make it
take two task arguments and use __task_cred() twice instead of
current_cred().

It of course needs extending security_ptrace_access_check() as well, but
that comes with the territory.
