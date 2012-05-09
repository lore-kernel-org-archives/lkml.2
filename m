Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760252Ab2EISy6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 14:54:58 -0400
Received: from mta112.f1.k8.com.br ([187.73.32.184]:46998 "EHLO
	mta112.f1.k8.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760057Ab2EISy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 14:54:56 -0400
X-Greylist: delayed 1106 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 May 2012 14:54:56 EDT
Message-ID: <1336588657.26723.23.camel@andre>
Subject: About cgroup memory limits
From: Andre Nathan <andre@digirati.com.br>
To: linux-kernel@vger.kernel.org
Cc: balbir@linux.vnet.ibm.com, andre@digirati.com.br
Date: Wed, 09 May 2012 15:37:37 -0300
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

I'm doing some tests with LXC and how it interacts with the memory
cgroup limits, more specifically the memory.limit_in_bytes control file.

Am I correct in my understanding of the memory cgroup documentation[1]
that the limit set in memory.limit_in_bytes is applied to the sum of the
fields 'cache', 'rss' and 'mapped_file' in the memory.stat file?

I am also trying to understand the values reported in memory.stat when
compared to the statistics in /proc/$PID/statm.

Below is the sum of each field in /proc/$PID/statm for every process
running inside a test container, converted to bytes:

       size  resident     share     text  lib       data  dt
  897208320  28741632  20500480  1171456    0  170676224   0

Compare this with the usage reports from memory.stat (fields total_*,
hierarchical_* and pg* omitted):

cache                     16834560
rss                       8192000
mapped_file               3743744
swap                      0
inactive_anon             0
active_anon               8192000
inactive_file             13996032
active_file               2838528
unevictable               0

Is there a way to reconcile these numbers somehow? I understand that the
fields from the two files represent different things. What I'm trying to
do is to combine, for example, the fields from memory.stat to
approximately reach what is displayed by statm.

Thank you in advance,
Andre

[1] http://www.kernel.org/doc/Documentation/cgroups/memory.txt

