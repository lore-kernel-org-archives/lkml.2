Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195Ab0IAJdg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 05:33:36 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64662 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752767Ab0IAJdb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 05:33:31 -0400
Message-ID: <4C7E1F12.8030304@cn.fujitsu.com>
Date: Wed, 01 Sep 2010 17:38:26 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, kvm-devel <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: ftrace/perf_event leak
References: <4C7E11E5.1040402@redhat.com> <1283331868.2059.808.camel@laptop> <4C7E1C36.6070400@redhat.com>
In-Reply-To: <4C7E1C36.6070400@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
>  On 09/01/2010 12:04 PM, Peter Zijlstra wrote:
>>
>> Does something like the below cure that?
>>
> 
> Unfortunately not.
> 

Then try this:

The bug should be caused by commit 1c024eca51fdc965290acf342ae16a476c2189d0.

---
diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
index 8a2b73f..9d1d1f2 100644
--- a/kernel/trace/trace_event_perf.c
+++ b/kernel/trace/trace_event_perf.c
@@ -161,6 +161,7 @@ void perf_trace_destroy(struct perf_event *p_event)
 		}
 	}
 out:
+	module_put(tp_event->mod);
 	mutex_unlock(&event_mutex);
 }
 
