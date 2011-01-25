Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387Ab1AYRlQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 12:41:16 -0500
Received: from mail.perches.com ([173.55.12.10]:3343 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752750Ab1AYRlP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 12:41:15 -0500
Subject: Re: RFC: introduce "K" flag for printf, similar to %pK
From: Joe Perches <joe@perches.com>
To: Kees Cook <kees.cook@canonical.com>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        Tejun Heo <tj@kernel.org>, Marcus Meissner <meissner@suse.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        Eugene Teo <eugeneteo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>, Len Brown <len.brown@intel.com>,
        Changli Gao <xiaosuo@gmail.com>,
        Dan Rosenberg <drosenberg@vsecurity.com>
In-Reply-To: <20110125172841.GY4979@outflux.net>
References: <20110125020321.GK4979@outflux.net>
	 <1295921824.14459.28.camel@Joe-Laptop>  <20110125172841.GY4979@outflux.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 25 Jan 2011 09:41:13 -0800
Message-ID: <1295977273.4316.3.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-01-25 at 09:28 -0800, Kees Cook wrote:
> On Mon, Jan 24, 2011 at 06:17:04PM -0800, Joe Perches wrote:
> > On Mon, 2011-01-24 at 18:03 -0800, Kees Cook wrote:
> > > In the interests of hiding kernel addresses from userspace (without
> > > messing with file permissions), I want to use %pK for /proc/kallsyms and
> > > /proc/modules, but this results in changing several %x's to %p's. The
> > > primary side-effects is that some legitimately "0" value things in
> > > /proc/kallsyms turn into "(null)".
> > 
> > Another option would be to allow '0' for
> > kernel pointers.
> 
> But then this changes the behavior of %p where (null) is expected. (i.e.
> when switching from %p to %pK.)

If you really want no change to any existing cases,
change it to "%pk" and a new case label.

> I'm personally fine with that, as I suspect anything parsing the output
> that can handle finding "(null)" will be fine with "0" too. But the other
> way around, not so much. :)

Maybe there's a case where somebody changed a kernel pointer
from %p to %pK that demands "(null)", but I can't think of one.

cheers, Joe

