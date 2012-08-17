Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758401Ab2HQQSy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 12:18:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53307 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758280Ab2HQQSo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 12:18:44 -0400
Date: Fri, 17 Aug 2012 13:18:36 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/8] perf tools: Various updates
Message-ID: <20120817161836.GB7764@infradead.org>
References: <1345144224-27280-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345144224-27280-1-git-send-email-robert.richter@amd.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Aug 16, 2012 at 09:10:16PM +0200, Robert Richter escreveu:
> This patch set contains various perf tools updates. Most patches deal
> with event naming. If the event name is unknown it is named like the
> command line string of it. This is esp. valueable for pmu events like
> for AMD IBS:
> 
>      $ perf report | grep '^#.*event'
>      # event : name = ibs_op/cnt_ctl=1/GH, type = 7, config = 0x80000, config1 = 0x0, config2 = 0x0, excl_usr = 0, excl_kern = 0, excl_host = 0, excl_guest = 0, precise_ip = 0, id = { 
>      # event : name = ibs_fetch/config=0/, type = 6, config = 0x0, config1 = 0x0, config2 = 0x0, excl_usr = 0, excl_kern = 0, excl_host = 0, excl_guest = 1, precise_ip = 0, id = { 57, 
>      # Samples: 20K of event 'ibs_op/cnt_ctl=1/GH'
>      # Samples: 4K of event 'ibs_fetch/config=0/'

There is a command for that pipe sequence:

[root@sandy ~]# perf record -e cache-misses:u,cycles:k,instructions usleep 1
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.020 MB perf.data (~861 samples) ]
[root@sandy ~]# perf evlist
cache-misses:u
cycles:k
instructions
[root@sandy ~]# perf evlist -v
cache-misses:u: sample_freq=4000, config: 3, size: 96, sample_type: 327, read_format: 7, disabled: 1, inherit: 1, exclude_kernel: 1, exclude_hv: 1, mmap: 1, comm: 1, freq: 1, enable_on_exec: 1, sample_id_all: 1
cycles:k: sample_freq=4000, size: 96, sample_type: 327, read_format: 7, disabled: 1, inherit: 1, exclude_user: 1, exclude_hv: 1, freq: 1, enable_on_exec: 1, sample_id_all: 1
instructions: sample_freq=4000, config: 1, size: 96, sample_type: 327, read_format: 7, disabled: 1, inherit: 1, freq: 1, enable_on_exec: 1, sample_id_all: 1, exclude_guest: 1
[root@sandy ~]#

- Arnaldo
