Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755609Ab2FTM2h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 08:28:37 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:53947 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751950Ab2FTM2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 08:28:36 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18+/m89j4Y+nrafJLtY3X4VoJLrJuFUWtneK5zBu6
	2J/gk9ujKEPea/
Message-ID: <1340195298.15707.3.camel@marge.simpson.net>
Subject: Re: Attaching a process to cgroups
From: Mike Galbraith <efault@gmx.de>
To: Alexey Vlasov <renton@renton.name>
Cc: linux-kernel@vger.kernel.org
Date: Wed, 20 Jun 2012 14:28:18 +0200
In-Reply-To: <20120619185856.GC31797@beaver>
References: <20120619185856.GC31797@beaver>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-06-19 at 22:58 +0400, Alexey Vlasov wrote: 
> Hi.
> 
> Is it possible to somehow fasten a process of pid attaching to cgroup?
> The problem is the pid attaches to a task-file with some strange delay:
> 
> 22:28:00.788224 open("/sys/fs/cgroup/memory/virtwww/w_test-l24-apache1_4bdf3d13/apache/tasks", O_WRONLY|O_CREAT|O_APPEND, 0666) = 3 <0.000035>
> 22:28:00.788289 fstat(3, {st_mode=S_IFREG|0644, st_size=0, ...}) = 0 <0.000004>
> 22:28:00.788326 mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f5e78074000 <0.000005>
> 22:28:00.788355 fstat(3, {st_mode=S_IFREG|0644, st_size=0, ...}) = 0 <0.000004>
> 22:28:00.788389 lseek(3, 0, SEEK_SET)   = 0 <0.000004>
> 22:28:00.788426 write(3, "16317\n", 6)  = 6 <0.128094>
> 22:28:00.916578 close(3)                = 0 <0.000006>


kernel/cgroup.c::cgroup_attach_task()
{
...
	synchronize_rcu();
...
}

