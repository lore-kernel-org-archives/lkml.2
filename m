Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517Ab1KVTXG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 14:23:06 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58796 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623Ab1KVTXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 14:23:05 -0500
Date: Tue, 22 Nov 2011 23:20:28 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: Serge Hallyn <serge.hallyn@canonical.com>
Cc: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        kernel-hardening@lists.openwall.com,
        "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [RFC] Make Yama pid_ns aware
Message-ID: <20111122192028.GA10458@albatros>
References: <1319672956-17114-1-git-send-email-keescook@chromium.org>
 <20111121191811.GA24039@albatros>
 <20111122181310.GA4235@sergelap>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111122181310.GA4235@sergelap>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Serge,

On Tue, Nov 22, 2011 at 12:13 -0600, Serge Hallyn wrote:
> Quoting Vasiliy Kulikov (segoon@openwall.com):
> > As Yama's sysctls are about defining a security policy for the system,
> > it is reasonable to define it per container in case of LXC containers
> > (or out-of-tree alternatives like OpenVZ).  In my opinion they belong
> > to pid namespace.  With per-pid_ns sysctls it is possible to create
> > multiple containers with different ptrace, /tmp, etc. policies.
> 
> tying the ptrace policy to pidns makes some sense, but is it definately
> what we want?
> 
> Is the idea that the container should never be able to bypass the
> restrictions, or should root in the container eventually be able to
> bypass it as he can on the host?

In-container root already has CAP_SYS_PTRACE, so he can avoid the check
even if Yama's ptrace policy is enabled.


> Would a securebits interface be more or less suitable?  It would allow
> per-process setting, inherited from parent on fork.

IMHO securebits doesn't belong to such finegrained type of things.
I don't find anything dangerous for privileged process (i.e. with
CAP_SYS_ADMIN and CAP_SYS_PTRACE) to be able to fork from
ptrace-restricted pid namespace, unshare pid namespace and relax ptrace
policy.  Because (1) process which is able to do unshare is already able
to ptrace everybody and (2) unshared namespace cannot explicitly
interact with parent namespace.


> It would however
> not allow a root shell on the desktop, after the fact, saying that
> a running gdb should be allowed to access firefox.  But, it would be
> able to say "I, from now on, am exempt, so that I can debug the
> running firefox", without the rest of the system having its setting
> changed.

Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
