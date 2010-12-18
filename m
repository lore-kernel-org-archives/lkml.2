Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756842Ab0LRBWq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 20:22:46 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44099 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756741Ab0LRBWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 20:22:44 -0500
Date: Fri, 17 Dec 2010 17:22:31 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dan Rosenberg <drosenberg@vsecurity.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        netdev@vger.kernel.org, jmorris@namei.org, eugeneteo@kernel.org,
        kees.cook@canonical.com, mingo@elte.hu, davem@davemloft.net
Subject: Re: [PATCH v2] kptr_restrict for hiding kernel pointers from
 unprivileged users
Message-Id: <20101217172231.8842f5cc.akpm@linux-foundation.org>
In-Reply-To: <1292634759.9764.26.camel@Dan>
References: <1292025924.2965.20.camel@Dan>
	<20101217164431.08f3e730.akpm@linux-foundation.org>
	<1292634759.9764.26.camel@Dan>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Dec 2010 20:12:39 -0500
Dan Rosenberg <drosenberg@vsecurity.com> wrote:

> > 
> > So what's next?  We need to convert 1,000,000 %p callsites to use %pK? 
> > That'll be fun.  Please consider adding a new checkpatch rule which
> > detects %p and asks people whether they should have used %pK.
> 
> The goal of this format specifier is specifically for pointers that are
> exposed to unprivileged users.  I agree that hiding all kernel pointers
> would be nice, but I don't expect the angry masses to ever agree to
> that.  For now, I'll isolate specific cases, especially in /proc, that
> are clear risks in terms of information leakage.  I'll also be skipping
> over pointers written to the syslog, since I think hiding that
> information is dmesg_restrict's job.

Well...  some administrators may wish to hide the pointer values even
for privileged callers.  That's a pretty trivial add-on for the code
which you have, and means that those admins can also suppress the
pointers for IRQ-time callers.  More /proc knobs :)

Then again, perhaps those admins would be OK if we simply disabled
plain old %p everywhere.  In which case we're looking at a separate
patch, I suggest.  

