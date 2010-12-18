Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751640Ab0LRFWw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Dec 2010 00:22:52 -0500
Received: from mx1.vsecurity.com ([209.67.252.12]:57366 "EHLO
	mx1.vsecurity.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387Ab0LRFWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Dec 2010 00:22:49 -0500
Subject: Re: [PATCH v2] kptr_restrict for hiding kernel pointers from
 unprivileged users
From: Dan Rosenberg <drosenberg@vsecurity.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        netdev@vger.kernel.org, jmorris@namei.org, eugeneteo@kernel.org,
        kees.cook@canonical.com, mingo@elte.hu, davem@davemloft.net
In-Reply-To: <20101217172231.8842f5cc.akpm@linux-foundation.org>
References: <1292025924.2965.20.camel@Dan>
	 <20101217164431.08f3e730.akpm@linux-foundation.org>
	 <1292634759.9764.26.camel@Dan>
	 <20101217172231.8842f5cc.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 18 Dec 2010 00:22:44 -0500
Message-ID: <1292649765.10804.42.camel@dan>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-12-17 at 17:22 -0800, Andrew Morton wrote:
> On Fri, 17 Dec 2010 20:12:39 -0500
> Dan Rosenberg <drosenberg@vsecurity.com> wrote:
> 
> > > 
> > > So what's next?  We need to convert 1,000,000 %p callsites to use %pK? 
> > > That'll be fun.  Please consider adding a new checkpatch rule which
> > > detects %p and asks people whether they should have used %pK.
> > 
> > The goal of this format specifier is specifically for pointers that are
> > exposed to unprivileged users.  I agree that hiding all kernel pointers
> > would be nice, but I don't expect the angry masses to ever agree to
> > that.  For now, I'll isolate specific cases, especially in /proc, that
> > are clear risks in terms of information leakage.  I'll also be skipping
> > over pointers written to the syslog, since I think hiding that
> > information is dmesg_restrict's job.
> 
> Well...  some administrators may wish to hide the pointer values even
> for privileged callers.  That's a pretty trivial add-on for the code
> which you have, and means that those admins can also suppress the
> pointers for IRQ-time callers.  More /proc knobs :)
> 

I can add a "2" setting that hides %pK pointers regardless of privilege
level, which I agree is a useful option.  But because it would be built
into the same format specifier, you still couldn't use %pK in interrupt
context (in case the sysctl wasn't set to 2).

> Then again, perhaps those admins would be OK if we simply disabled
> plain old %p everywhere.  In which case we're looking at a separate
> patch, I suggest.  

I would be happy to do this from a security perspective, but I'd imagine
there's a pretty high risk of things breaking by doing such a sweeping
change.

-Dan

