Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751959Ab1EIKLB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 06:11:01 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56784 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678Ab1EIKLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 06:11:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=AwpJaODQ9amVvVdV0VBmg6UO9ASeWyPQMIvxtrEUnxtzBOA3iWoKUoGKDY/UYLqxpi
         P1gLVkdG0XeyxFN92ZBgf5723NP29OpFsCOwNsIESicey4lETuX5xp579Wu0b5S95L4k
         wxX+ZC0PmwrbEKpOTJ3AKYPoNiWsCtlMmAJuU=
Date: Mon, 9 May 2011 12:10:55 +0200
From: Tejun Heo <tj@kernel.org>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: oleg@redhat.com, jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, indan@nul.nu
Subject: Re: [PATCH 11/11] ptrace: implement group stop notification for
 ptracer
Message-ID: <20110509101055.GI1661@htj.dyndns.org>
References: <1304869745-1073-1-git-send-email-tj@kernel.org>
 <1304869745-1073-12-git-send-email-tj@kernel.org>
 <201105090042.55599.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201105090042.55599.vda.linux@googlemail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, May 09, 2011 at 12:42:55AM +0200, Denys Vlasenko wrote:
> To clarify on "sticky":
> 
> Does this mean that if tracer userspace won't query PTRACE_GETSIGINFO,
> but will simply do:
> 
>                   waitid(P_PID, tracee, NULL, WSTOPPED);
>                   ptrace(PTRACE_CONT, tracee, NULL, NULL);
> 
> then kernel will generate INTERRUPT trap again and again
> (without letting tracee run) if job stop state of the tracee has changed?

Correct, it will be in infinite trap loop.

Thanks.

-- 
tejun
