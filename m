Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756801Ab1EKQFQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:05:16 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36510 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755431Ab1EKQFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:05:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=SMTYkmwFG/uWNVcJbg+vrSPFTReSjGx/I1on4JDhj9/dTfjIQc5jkR53/g95P64z3A
         NBrrVGlNqCrhXF1ftYPTb0d8Ub6NF3mDyIfjV+O8MZlvSJXC5vQjHsVYePWfj8S2LHKC
         EZr4xhLz7uYd34stCBE4lVVukL7++GYCcsZ4Q=
Date: Wed, 11 May 2011 15:22:18 +0200
From: Tejun Heo <tj@kernel.org>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Subject: Re: [PATCH 04/11] ptrace: implement PTRACE_INTERRUPT
Message-ID: <20110511132218.GG1661@htj.dyndns.org>
References: <1304869745-1073-1-git-send-email-tj@kernel.org>
 <20110510095022.GR1661@htj.dyndns.org>
 <20110510140620.GB21834@redhat.com>
 <201105102359.58900.vda.linux@googlemail.com>
 <20110511091955.GD1661@htj.dyndns.org>
 <BANLkTikQm1PVCW3164g0bfgU9fs4MMTfNA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTikQm1PVCW3164g0bfgU9fs4MMTfNA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Wed, May 11, 2011 at 02:23:44PM +0200, Denys Vlasenko wrote:
> I understand this. I am trying to understand what feature are you trying
> to provide to userland, or what problematic race scenario you are trying
> to make resolve-able *in userland* by making "stop" and "cont"
> notifications sticky wrt GETSIGINFO. I just don't see this scenario.

If you still don't see how events can get lost, I'm afraid I can't
explain any better.  You're repeating that exit_code can record the
event until it's fetched but it doesn't queue and any trap will
overwrite it and debuggers don't have to call GETSIGINFO after each
trap - it only has to do so for signal delivery, group stop and
INTERRUPT trap.  So, it can just look at the exit_code (which doesn't
indicate continuation) and let tracee return to userland.

Maybe I'm horribly confused.  Oleg, am I?

Thanks.

-- 
tejun
