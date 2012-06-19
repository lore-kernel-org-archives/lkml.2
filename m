Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677Ab2FSTE1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 15:04:27 -0400
Received: from mail.renton.name ([90.155.165.44]:33998 "EHLO
	beaver.old-horrors.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753043Ab2FSTE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 15:04:26 -0400
X-Greylist: delayed 321 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 Jun 2012 15:04:26 EDT
Date: Tue, 19 Jun 2012 22:58:56 +0400
From: Alexey Vlasov <renton@renton.name>
To: linux-kernel@vger.kernel.org
Subject: Attaching a process to cgroups
Message-ID: <20120619185856.GC31797@beaver>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

Is it possible to somehow fasten a process of pid attaching to cgroup?
The problem is the pid attaches to a task-file with some strange delay:

22:28:00.788224 open("/sys/fs/cgroup/memory/virtwww/w_test-l24-apache1_4bdf3d13/apache/tasks", O_WRONLY|O_CREAT|O_APPEND, 0666) = 3 <0.000035>
22:28:00.788289 fstat(3, {st_mode=S_IFREG|0644, st_size=0, ...}) = 0 <0.000004>
22:28:00.788326 mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f5e78074000 <0.000005>
22:28:00.788355 fstat(3, {st_mode=S_IFREG|0644, st_size=0, ...}) = 0 <0.000004>
22:28:00.788389 lseek(3, 0, SEEK_SET)   = 0 <0.000004>
22:28:00.788426 write(3, "16317\n", 6)  = 6 <0.128094>
22:28:00.916578 close(3)                = 0 <0.000006>

For a comparison here's a test attaching pid-file in placed tmpfs: 

22:24:41.892562 open("/tmp/w_test-l24-apache1_4bdf3d13/tasks", O_WRONLY|O_CREAT|O_APPEND, 0666) = 3 <0.000010>
22:24:41.892597 fstat(3, {st_mode=S_IFREG|0644, st_size=6, ...}) = 0 <0.000004>
22:24:41.892631 mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f5685b6f000 <0.000006>
22:24:41.892664 fstat(3, {st_mode=S_IFREG|0644, st_size=6, ...}) = 0 <0.000004>
22:24:41.892701 lseek(3, 6, SEEK_SET)   = 6 <0.000004>
22:24:41.892738 write(3, "25966\n", 6)  = 6 <0.000008>
22:24:41.892767 close(3)                = 0 <0.000005>

Here goes it immediately.

-- 
BRGDS. Alexey Vlasov.
