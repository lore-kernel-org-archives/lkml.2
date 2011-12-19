Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753023Ab1LSUww (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 15:52:52 -0500
Received: from tundra.namei.org ([65.99.196.166]:44794 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752629Ab1LSUwu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 15:52:50 -0500
Date: Tue, 20 Dec 2011 07:52:34 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Kees Cook <keescook@chromium.org>
cc: kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        Roland McGrath <roland@hack.frob.com>
Subject: Re: [kernel-hardening] [PATCH 2/2] security: Yama LSM
In-Reply-To: <20111219194136.GG12321@outflux.net>
Message-ID: <alpine.LRH.2.00.1112200751260.30800@tundra.namei.org>
References: <1324017197-3292-1-git-send-email-keescook@chromium.org> <1324017197-3292-3-git-send-email-keescook@chromium.org> <alpine.LRH.2.00.1112191130530.22702@tundra.namei.org> <20111219194136.GG12321@outflux.net>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Dec 2011, Kees Cook wrote:

> Hi James,
> 
> On Mon, Dec 19, 2011 at 11:33:10AM +1100, James Morris wrote:
> > On Thu, 15 Dec 2011, Kees Cook wrote:
> > > +#ifdef CONFIG_SECURITY_YAMA
> > > +	ns->ptrace_scope = parent_pid_ns->ptrace_scope;
> > > +#endif
> > > +
> > 
> > I'd like to see this implemented as an LSM hook, something like 
> > security_ptrace_set_scope().
> 
> I must be dense, but I fail to understand the purpose of this. The "ptrace
> scope" implemented by Yama is a sysctl, not an system interface. I don't
> understand why (or where) other LSMs would want to catch changing this.
> Can you explain what you're looking for in more detail?
> 

We should not see YAMA-specific code in the core kernel.  However you do 
it, the above should happen in LSM.


- James
-- 
James Morris
<jmorris@namei.org>
