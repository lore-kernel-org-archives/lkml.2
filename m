Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933148Ab1FACC7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 22:02:59 -0400
Received: from smtp.outflux.net ([198.145.64.163]:52334 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933030Ab1FACC5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 22:02:57 -0400
Date: Tue, 31 May 2011 19:02:54 -0700
From: Kees Cook <kees.cook@canonical.com>
To: James Morris <jmorris@namei.org>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] AppArmor: fix oops in apparmor_setprocattr
Message-ID: <20110601020254.GT19633@outflux.net>
References: <20110531183141.GH19633@outflux.net>
 <alpine.LRH.2.00.1106011024150.16178@tundra.namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.1106011024150.16178@tundra.namei.org>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James,

On Wed, Jun 01, 2011 at 10:25:37AM +1000, James Morris wrote:
> On Tue, 31 May 2011, Kees Cook wrote:
> > When invalid parameters are passed to apparmor_setprocattr a NULL deref
> > oops occurs when it tries to record an audit message. This is because
> > it is passing NULL for the profile parameter for aa_audit. But aa_audit
> > now requires that the profile passed is not NULL.
> > 
> > Fix this by passing the current profile on the task that is trying to
> > setprocattr.
> 
> Is this trigger able by unprivileged users?

Yes, but the Oops kills the process doing the write as it triggers
the BUG_ON, not the process being written to.

> >From which upstream commit is this an issue?

b5e95b48685e3481139a5634d14d630d12c7d5ce

-Kees

-- 
Kees Cook
Ubuntu Security Team
