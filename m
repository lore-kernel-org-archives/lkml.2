Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269Ab1AYR3a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 12:29:30 -0500
Received: from smtp.outflux.net ([198.145.64.163]:47252 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751571Ab1AYR33 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 12:29:29 -0500
Date: Tue, 25 Jan 2011 09:28:41 -0800
From: Kees Cook <kees.cook@canonical.com>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        Tejun Heo <tj@kernel.org>, Marcus Meissner <meissner@suse.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        Eugene Teo <eugeneteo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>, Len Brown <len.brown@intel.com>,
        Changli Gao <xiaosuo@gmail.com>,
        Dan Rosenberg <drosenberg@vsecurity.com>
Subject: Re: RFC: introduce "K" flag for printf, similar to %pK
Message-ID: <20110125172841.GY4979@outflux.net>
References: <20110125020321.GK4979@outflux.net>
 <1295921824.14459.28.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295921824.14459.28.camel@Joe-Laptop>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

On Mon, Jan 24, 2011 at 06:17:04PM -0800, Joe Perches wrote:
> On Mon, 2011-01-24 at 18:03 -0800, Kees Cook wrote:
> > In the interests of hiding kernel addresses from userspace (without
> > messing with file permissions), I want to use %pK for /proc/kallsyms and
> > /proc/modules, but this results in changing several %x's to %p's. The
> > primary side-effects is that some legitimately "0" value things in
> > /proc/kallsyms turn into "(null)".
> 
> Another option would be to allow '0' for
> kernel pointers.

But then this changes the behavior of %p where (null) is expected. (i.e.
when switching from %p to %pK.)

I'm personally fine with that, as I suspect anything parsing the output
that can handle finding "(null)" will be fine with "0" too. But the other
way around, not so much. :)

-Kees

-- 
Kees Cook
Ubuntu Security Team
