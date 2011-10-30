Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752843Ab1J3V0v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Oct 2011 17:26:51 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:35410 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752516Ab1J3V0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Oct 2011 17:26:50 -0400
X-Sasl-enc: xqkMVvtN9QvOVw/zvLiadxz+BxMp5ulVLe8d40R+kq4B 1320010009
Date: Sun, 30 Oct 2011 19:26:45 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: "Artem S. Tashkinov" <t.artem@lycos.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: HT (Hyper Threading) aware process scheduling doesn't work as
 it should
Message-ID: <20111030212644.GA7106@khazad-dum.debian.net>
References: <269467866.49093.1320004632156.JavaMail.mail@webmail17>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <269467866.49093.1320004632156.JavaMail.mail@webmail17>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 30 Oct 2011, Artem S. Tashkinov wrote:
> I've found out that even on Linux 3.0.8 the process scheduler doesn't correctly distributes
> the load amongst virtual CPUs. E.g. on a 4-core system (8 total virtual CPUs) the process
> scheduler often run some instances of four different tasks on the same physical CPU.

Please check how your sched_mc_power_savings and sched_smt_power_savings
tunables.   Here's the doc from lesswats.org:

'sched_mc_power_savings' tunable under /sys/devices/system/cpu/ controls
the Multi-core related tunable. By default, this is set to '0' (for
optimal performance). By setting this to '1', under light load
scenarios, the process load is distributed such that all the cores in a
processor package are busy before distributing the process load to other
processor packages.

[...]

'sched_smt_power_savings' tunable under /sys/devices/system/cpu/
controls the multi-threading related tunable. By default, this is set to
'0' (for optimal performance). By setting this to '1', under light load
scenarios, the process load is distributed such that all the threads in
a core and all the cores in a processor package are busy before
distributing the process load to threads and cores, in other processor
packages. 

Please make sure both are set to 0.  If they were not 0 at the time you
ran your tests, please retest and report back.

You also want to make sure you _do_ have the SMT scheduler compiled in
whatever kernel you're using, just in case.

It is certainly possible that there is a bug in the scheduler, but it is
best to make sure it is not something else, first.

You may also want to refer to: http://oss.intel.com/pdfs/mclinux.pdf and
to the irqbalance and hwloc[1] utilities, since you're apparently
interested in SMP/SMT/NUMA scheduler performance.

[1] http://www.open-mpi.org/projects/hwloc/

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
