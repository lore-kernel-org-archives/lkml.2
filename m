Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417Ab2FTDgj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 23:36:39 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:43590 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754022Ab2FTDgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 23:36:37 -0400
Date: Wed, 20 Jun 2012 12:34:31 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: Alexey Vlasov <renton@renton.name>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        linux-kernel@vger.kernel.org
Subject: Re: Attaching a process to cgroups
Message-Id: <20120620123431.aff6e049.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20120619185856.GC31797@beaver>
References: <20120619185856.GC31797@beaver>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 3.1.4 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

What does "cat /sys/fs/cgroup/.../apache/memory.move_charge_at_immigrate" show ?

If it shows non-zero value, you can make the pid attachment faster by writing "0" to
memory.move_charge_at_immigrate before attaching the process.
But note that if you disable the feature, current memory usage of the process is not
moved to the new cgroup.

Thanks,
Daisuke Nishimura.

On Tue, 19 Jun 2012 22:58:56 +0400
Alexey Vlasov <renton@renton.name> wrote:

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
> 
> For a comparison here's a test attaching pid-file in placed tmpfs: 
> 
> 22:24:41.892562 open("/tmp/w_test-l24-apache1_4bdf3d13/tasks", O_WRONLY|O_CREAT|O_APPEND, 0666) = 3 <0.000010>
> 22:24:41.892597 fstat(3, {st_mode=S_IFREG|0644, st_size=6, ...}) = 0 <0.000004>
> 22:24:41.892631 mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f5685b6f000 <0.000006>
> 22:24:41.892664 fstat(3, {st_mode=S_IFREG|0644, st_size=6, ...}) = 0 <0.000004>
> 22:24:41.892701 lseek(3, 6, SEEK_SET)   = 6 <0.000004>
> 22:24:41.892738 write(3, "25966\n", 6)  = 6 <0.000008>
> 22:24:41.892767 close(3)                = 0 <0.000005>
> 
> Here goes it immediately.
> 
> -- 
> BRGDS. Alexey Vlasov.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
