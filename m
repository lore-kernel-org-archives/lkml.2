Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756025Ab0HIJqe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 05:46:34 -0400
Received: from smtp-out-166.synserver.de ([212.40.180.166]:1058 "HELO
	smtp-out-165.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1755919Ab0HIJqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 05:46:33 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: markus@trippelsdorf.de
X-SynServer-PPID: 9347
Date: Mon, 9 Aug 2010 11:46:30 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Tejun Heo <htejun@gmail.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, walt <w41ter@gmail.com>,
        linux-kernel@vger.kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH wq#for-linus] workqueue: workqueue_cpu_callback()
 should be cpu_notifier not hotcpu_notifier
Message-ID: <20100809094630.GA1603@arch.tripp.de>
References: <i3n3dh$t48$1@dough.gmane.org>
 <20100809063742.GA1632@arch.tripp.de>
 <20100809083053.GB2169@osiris.boeblingen.de.ibm.com>
 <20100809083451.GC2169@osiris.boeblingen.de.ibm.com>
 <4C5FC49B.9040208@kernel.org>
 <4C5FCC14.6030901@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4C5FCC14.6030901@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 09, 2010 at 11:36:20AM +0200, Tejun Heo wrote:
> Commit 6ee0578b (workqueue: mark init_workqueues as early_initcall)
> made workqueue SMP initialization depend on workqueue_cpu_callback(),
> which however was registered as hotcpu_notifier() and didn't get
> called if CONFIG_HOTPLUG_CPU is not set.  This made gcwqs on non-boot
> CPUs not create their initial workers leading to boot failures.  Fix
> it by making it a cpu_notifier.
> 
> So, something like this.  Can you please verify the fix?

This fixes the boot problem here. Thanks.
(The drm delayed enqueue problem, which I mentioned earlier still
persists.)

-- 
»A man who doesn't know he is in prison can never escape.«
William S. Burroughs
