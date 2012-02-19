Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751582Ab2BSXPM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 18:15:12 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:32865 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061Ab2BSXPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 18:15:11 -0500
Date: Sun, 19 Feb 2012 15:15:45 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: Re: linux-next: build failure after merge of the final tree (akpm
 tree related)
Message-Id: <20120219151545.349172cc.akpm@linux-foundation.org>
In-Reply-To: <20120220100436.5fbbf5cc1b1df539ed8aca24@canb.auug.org.au>
References: <20120217212037.0859c427418b73b2cb17428d@canb.auug.org.au>
	<20120220100436.5fbbf5cc1b1df539ed8aca24@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Feb 2012 10:04:36 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Andrew,
> 
> On Fri, 17 Feb 2012 21:20:37 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >
> > Today's linux-next fails to build (s390 allnoconfig) like this:
> > 
> > In file included from arch/s390/mm/maccess.c:15:
> > include/linux/gfp.h: In function 'gfp_zonelist':
> > include/linux/gfp.h:267: error: '__enabled_CONFIG_NUMA' undeclared (first use in this function)
> > include/linux/gfp.h:267: error: (Each undeclared identifier is reported only once
> > include/linux/gfp.h:267: error: for each function it appears in.)
> > include/linux/gfp.h:267: error: '__enabled_CONFIG_NUMA_MODULE' undeclared (first use in this function)
> > 
> > and many more.  This also happens in other architectures and configs but
> > (obviously) not all builds.
> > 
> > Presumably caused by commit 053361e1a072 ("mm: replace NUMA_BUILD with
> > IS_ENABLED(CONFIG_NUMA)").
> 
> I have removed that patch from the akpm tree until a solution is worked out.
> 
> Everything seemed to rebase ok with out it and I can't see much actually
> depending on it.

yup, I've removed it from the for-next sections and will probably drop
it altogether.

