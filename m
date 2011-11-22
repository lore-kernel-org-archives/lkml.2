Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756224Ab1KVUKW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 15:10:22 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:49106 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755093Ab1KVUKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 15:10:19 -0500
Date: Tue, 22 Nov 2011 14:10:07 -0600
From: Serge Hallyn <serge.hallyn@canonical.com>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        kernel-hardening@lists.openwall.com,
        "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [RFC] Make Yama pid_ns aware
Message-ID: <20111122201007.GA21722@sergelap>
References: <1319672956-17114-1-git-send-email-keescook@chromium.org>
 <20111121191811.GA24039@albatros>
 <20111122181310.GA4235@sergelap>
 <20111122192028.GA10458@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111122192028.GA10458@albatros>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Vasiliy Kulikov (segoon@openwall.com):
> Hi Serge,
> 
> On Tue, Nov 22, 2011 at 12:13 -0600, Serge Hallyn wrote:
> > Quoting Vasiliy Kulikov (segoon@openwall.com):
> > > As Yama's sysctls are about defining a security policy for the system,
> > > it is reasonable to define it per container in case of LXC containers
> > > (or out-of-tree alternatives like OpenVZ).  In my opinion they belong
> > > to pid namespace.  With per-pid_ns sysctls it is possible to create
> > > multiple containers with different ptrace, /tmp, etc. policies.
> > 
> > tying the ptrace policy to pidns makes some sense, but is it definately
> > what we want?
> > 
> > Is the idea that the container should never be able to bypass the
> > restrictions, or should root in the container eventually be able to
> > bypass it as he can on the host?
> 
> In-container root already has CAP_SYS_PTRACE, so he can avoid the check
> even if Yama's ptrace policy is enabled.

Well, not necessarily  :)  But in general.

But still, is turning this on and off per-container, and leaving it off
on the host, something people will reasonably want to do?  I'm just
wondering whether adding the extra data on the pidns is worth it.  It's
fine if it is, but I'm having a hard time imagining someone using it
like that.

thanks,
-serge
