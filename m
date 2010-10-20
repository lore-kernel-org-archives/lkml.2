Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756648Ab0JTBkm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 21:40:42 -0400
Received: from [120.204.251.227] ([120.204.251.227]:45380 "EHLO
	LC-SHMAIL-01.SHANGHAI.LEADCORETECH.COM" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753454Ab0JTBkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 21:40:41 -0400
Subject: Re: oom_killer crash linux system
From: "Figo.zhang" <zhangtianfei@leadcoretech.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rientjes@google.com" <rientjes@google.com>,
        figo1802 <figo1802@gmail.com>
In-Reply-To: <20101019152249.e268b1e9.kamezawa.hiroyu@jp.fujitsu.com>
References: <20101018021126.GB8654@localhost>
	 <1287389631.1997.9.camel@myhost>
	 <20101018180919.3AF8.A69D9226@jp.fujitsu.com>
	 <1287454058.2078.12.camel@myhost>
	 <20101019152249.e268b1e9.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Oct 2010 09:36:47 +0800
Message-ID: <1287538607.2031.5.camel@myhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.0 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Oct 2010 01:40:38.0173 (UTC) FILETIME=[CC1514D0:01CB6FF7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> >
> > echo 5 > /proc/sys/vm/dirty_ratio
>
> reduce the dirty_ratio, i can use memory up to 1.75GB, and then it
will
> call oom-killer.
>So it helps.  Are there intensive IO after reducing dirty_ratio?

> > - enable vmscan trace
> >
> > mount -t debugfs none /sys/kernel/debug
> > echo 1 > /sys/kernel/debug/tracing/events/vmscan/enable
> > <eat memory and wait for crash>
> > cat /sys/kernel/debug/tracing/trace > trace.log
> would you like to help to see the trace.log , i add attached file.
> There are many vmscan writes showing up in the trace.

yes, the DiskIO is be not aggressive when i reduce the dirty_ratio, but
when i use memory up to 1.75GB (total 2GB), the system suddenly crashed.
when i reboot and want to see the /var/log/message, it is without useful
information.

so it is other useful debug approach to find the issue?



