Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515Ab1FNANf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 20:13:35 -0400
Received: from yumi.tdiedrich.de ([85.10.210.183]:40815 "EHLO mx.tdiedrich.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755054Ab1FNANe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 20:13:34 -0400
Date: Tue, 14 Jun 2011 02:13:33 +0200
From: Tobias Diedrich <ranma+xen@tdiedrich.de>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        xen-users@lists.xensource.com, linux-kernel@vger.kernel.org
Subject: Re: 3.0.0-rc2: Xen: powernow-k8: Kernel panic - not syncing:
 Attempted to kill init!
Message-ID: <20110614001333.GC7417@yumi.tdiedrich.de>
Mail-Followup-To: Tobias Diedrich <ranma+xen@tdiedrich.de>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	xen-users@lists.xensource.com, linux-kernel@vger.kernel.org
References: <20110613202622.GC20616@yumi.tdiedrich.de>
 <20110613215123.GA19117@dumpdata.com>
 <20110613235221.GA7417@yumi.tdiedrich.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110613235221.GA7417@yumi.tdiedrich.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tobias Diedrich wrote:
> Konrad Rzeszutek Wilk wrote:
> > > [    5.523199] rtc_cmos 00:05: setting system clock to 2011-06-13 20:20:00 UTC (1307996400)
> > > [    5.523400] powernow-k8: Found 1 AMD Athlon(tm) 64 Processor 3700+ (1 cpu cores) (version 2.20.00)
> > > [    5.530956] powernow-k8: fid 0x2 (1000 MHz), vid 0x12
> > > [    5.531072] powernow-k8: fid 0xa (1800 MHz), vid 0xa
> > > [    5.531187] powernow-k8: fid 0xc (2000 MHz), vid 0x8
> > > [    5.531301] powernow-k8: fid 0xe (2200 MHz), vid 0x8
> > > [    5.531460] Marking TSC unstable due to cpufreq changes
> > > [    5.531680] powernow-k8: fid trans failed, fid 0x2, curr 0x0
> > > [    5.531802] BUG: unable to handle kernel paging request at ffff880807e07b78
> > > [    5.531982] IP: [<ffffffff81479163>] cpufreq_stats_update+0x46/0x5b
> > 
> > For this one, you will have to fire out gdb and disassemble the code to
> > figure out where it failed. Look for 'gdb vmlinux' and 'disassembly' on this
> > mailing list - that should provide some hints.
> 
> Probably because of the 'fid trans failed' stat->last_index is -1

It's set to -1 in cpufreq_stats_create_table(), the second call to
freq_table_get_index() doesn't check against -1 (expecting the call
to always succeed):

	stat->last_time = get_jiffies_64();
	stat->last_index = freq_table_get_index(stat, policy->cur);

-- 
Tobias						PGP: http://8ef7ddba.uguu.de
