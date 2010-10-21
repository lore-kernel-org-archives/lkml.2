Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751949Ab0JUH7k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 03:59:40 -0400
Received: from [120.204.251.227] ([120.204.251.227]:28251 "EHLO
	LC-SHMAIL-01.SHANGHAI.LEADCORETECH.COM" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750901Ab0JUH7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 03:59:39 -0400
Subject: Ftrace: can trace kthread?
From: "Figo.zhang" <zhangtianfei@leadcoretech.com>
To: Li Zefan <lizf@cn.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Steven Rostedt <srostedt@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 21 Oct 2010 15:55:32 +0800
Message-ID: <1287647732.2237.7.camel@myhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.0 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 Oct 2010 07:59:32.0747 (UTC) FILETIME=[E55B85B0:01CB70F5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

is it ftrace in 2.6.36-rc8 can trace the kthread? i want to trace the
kswapd/bdi_writeback_thread, but not success. i am sure that kswapd is
running, because i let the system eat huge memory. i can trace some
function such as __do_fault. what is issue on it? 

Best,
Figo.zhang


here is my ftrace script.
i = 1
while true;
do
	echo 1 > /proc/sys/kernel/ftrace_enabled
	echo function_graph > /sys/kernel/debug/tracing/current_tracer
	echo kswapd > /sys/kernel/debug/tracing/set_graph_function
	echo 1 > /sys/kernel/debug/tracing/tracing_on
	echo 1 > /sys/kernel/debug/tracing/tracing_enabled
	sleep 1
	echo 0 > /sys/kernel/debug/tracing/tracing_enabled
	cat /sys/kernel/debug/tracing/trace > ftrace.kswap.log.$i

	let i=i+1;

done



