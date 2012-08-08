Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758891Ab2HHQm0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 12:42:26 -0400
Received: from mail.renton.name ([90.155.165.44]:39824 "EHLO
	beaver.old-horrors.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758837Ab2HHQmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 12:42:25 -0400
Date: Wed, 8 Aug 2012 20:40:33 +0400
From: Alexey Vlasov <renton@renton.name>
To: Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com
Subject: Re: Attaching a process to cgroups
Message-ID: <20120808164033.GB13735@beaver>
References: <20120619185856.GC31797@beaver>
 <1340195298.15707.3.camel@marge.simpson.net>
 <20120725133637.GA9169@beaver>
 <1343224667.5745.67.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1343224667.5745.67.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2012 at 03:57:47PM +0200, Mike Galbraith wrote:
> > Hanging on read():
> > 
> > # strace -ttT cat /proc/cgroups 
> > 
> > 17:30:43.825005 fstat(1, {st_mode=S_IFCHR|0620, st_rdev=makedev(136, 13), ...}) = 0 <0.000005>
> > 17:30:43.825048 open("/proc/cgroups", O_RDONLY) = 3 <0.000014>
> > 17:30:43.825085 fstat(3, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0 <0.000004>
> > 17:30:43.825125 fadvise64(3, 0, 0, POSIX_FADV_SEQUENTIAL) = 0 <0.000005>
> > 17:30:43.825161 read(3, "#subsys_name\thierarchy\tnum_cgrou"..., 32768) = 112 <7.447084>
 
In general I've changed it to synchronize_rcu_expedited () and all the
delays have gone both on writing and reading files from cgroups.

-- 
BRGDS. Alexey Vlasov.
