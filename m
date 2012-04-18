Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753427Ab2DROTH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 10:19:07 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:50672 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752524Ab2DROTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 10:19:05 -0400
Date: Wed, 18 Apr 2012 15:18:52 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        majianpeng <majianpeng@gmail.com>
Subject: Re: Possible memory leaks in proc_sysctl.c
Message-ID: <20120418141851.GG1505@arm.com>
References: <20120418101231.GE1505@arm.com>
 <m1wr5d18fy.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1wr5d18fy.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 18, 2012 at 02:22:09PM +0100, Eric W. Biederman wrote:
> Catalin Marinas <catalin.marinas@arm.com> writes:
> > Following your commit f728019bb (sysctl: register only tables of sysctl
> > files), I get several kmemleak reports. They all seem to be header
> > allocations with kzalloc() in __register_sysctl_table() and
> > __register_sysctl_paths(). The patch isn't simple to quickly figure out
> > what may be wrong.
> 
> Due to a change in the data structure places where we register the
> sysctl permanently and ignore the result from the register_sysctl_...
> family of functions now report this leak.

But is the header (or subheader, basically any pointer inside the
kmalloc'ed object) never referenced from anywhere? I'm just trying to
understand why kmemleak reports it as it seems that the header object is
inserted in a ctl_dir.

> majianpeng has done a good of getting kmemleak_not_leak annotations into
> the net tree, and I have one of his patches pending to put into my
> sysctl tree (see below).

If the header is referenced from somewhere, we can tell kmemleak where
it is referenced from and avoid the not_leak annotations. But I'm not
familiar with this code to be sure.

Thanks.

-- 
Catalin
