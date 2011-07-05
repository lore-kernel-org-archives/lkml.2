Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932345Ab1GEMVH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 08:21:07 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:44417 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932333Ab1GEMVG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 08:21:06 -0400
From: Richard Weinberger <richard@nod.at>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Subject: Re: [PATCH][Resend v2] Fix infinite loop in search_binary_handler()
Date: Tue, 5 Jul 2011 14:21:02 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.37.6-0.5-desktop; KDE/4.6.4; x86_64; ; )
Cc: viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <1309779003-8668-1-git-send-email-richard@nod.at> <201107051155.18465.richard@nod.at> <201107052102.BHE69234.OLQOVMJFOFFHSt@I-love.SAKURA.ne.jp>
In-Reply-To: <201107052102.BHE69234.OLQOVMJFOFFHSt@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107051421.02658.richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag 05 Juli 2011, 14:02:34 schrieb Tetsuo Handa:
> Richard Weinberger wrote:
> > But IMHO adding a new attribute to task_struct is a bit overkill.
> > Why is your variant better than my strcmp() in fs/exec.c?
> 
> Say, there are multiple /sbin/modprobe
> 
> /sbin/modprobe
> /var/chroot/sbin/modprobe
> 
> and only /var/chroot/sbin/modprobe needs request_module() whereas
> /sbin/modprobe does not need request_module(). Why do we need to make
> execl("/sbin/modprobe", "--help", NULL) from chroot("/var/chroot/") fail
> by denying request_module() that does not cause recursion?

*headdesk*, bprm->filename will contain "/sbin/modprobe" and the strcmp()
will falsely match.
Thanks for the pointer!

//richard
