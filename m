Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752360Ab2G0Ivk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 04:51:40 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:46349 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751889Ab2G0Ivh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 04:51:37 -0400
Date: Fri, 27 Jul 2012 14:10:55 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, lkml <linux-kernel@vger.kernel.org>,
        benh@kernel.crashing.org, Paul Mackerras <paulus@samba.org>,
        Anton Blanchard <anton@samba.org>, michael@ellerman.id.au,
        Ingo Molnar <mingo@elte.hu>, peterz@infradead.org, oleg@redhat.com
Subject: Re: [PATCH v3 2/2] powerpc: Uprobes port to powerpc
Message-ID: <20120727084055.GA6679@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120726051902.GA29466@in.ibm.com>
 <20120726052029.GB29466@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120726052029.GB29466@in.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12072708-8974-0000-0000-00000B879B7A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ananth N Mavinakayanahalli <ananth@in.ibm.com> [2012-07-26 10:50:29]:

> From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> 
> This is the port of uprobes to powerpc. Usage is similar to x86.
> 
> [root@xxxx ~]# ./bin/perf probe -x /lib64/libc.so.6 malloc
> Added new event:
>   probe_libc:malloc    (on 0xb4860)
> 
> You can now use it in all perf tools, such as:
> 
> 	perf record -e probe_libc:malloc -aR sleep 1
> 
> [root@xxxx ~]# ./bin/perf record -e probe_libc:malloc -aR sleep 20
> [ perf record: Woken up 22 times to write data ]
> [ perf record: Captured and wrote 5.843 MB perf.data (~255302 samples) ]
> [root@xxxx ~]# ./bin/perf report --stdio
> ...
> 
> # Samples: 83K of event 'probe_libc:malloc'
> # Event count (approx.): 83484
> #
> # Overhead       Command  Shared Object      Symbol
> # ........  ............  .............  ..........
> #
>     69.05%           tar  libc-2.12.so   [.] malloc
>     28.57%            rm  libc-2.12.so   [.] malloc
>      1.32%  avahi-daemon  libc-2.12.so   [.] malloc
>      0.58%          bash  libc-2.12.so   [.] malloc
>      0.28%          sshd  libc-2.12.so   [.] malloc
>      0.08%    irqbalance  libc-2.12.so   [.] malloc
>      0.05%         bzip2  libc-2.12.so   [.] malloc
>      0.04%         sleep  libc-2.12.so   [.] malloc
>      0.03%    multipathd  libc-2.12.so   [.] malloc
>      0.01%      sendmail  libc-2.12.so   [.] malloc
>      0.01%     automount  libc-2.12.so   [.] malloc
> 
> Patch applies on the current master branch of Linus' tree (bdc0077af).
> The trap_nr addition patch is a prereq.
> 
> Signed-off-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>

Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com> 
 

