Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132Ab0JTQiA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 12:38:00 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:43245 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753477Ab0JTQh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 12:37:59 -0400
X-Authority-Analysis: v=1.1 cv=6ptpMFIBtxRk0xdOb6IhJTbTLVRlKjWFes7R4SsWCrA= c=1 sm=0 a=LuwKl7ggZIAA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=7KzPQ-Dkr8-vfGu7gIcA:9 a=urOMrG_zfDDw4csN5aHEImh0ZIIA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH][GIT PULL] tracing: Fix compile issue for
 trace_sched_wakeup.c
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jason Baron <jbaron@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
In-Reply-To: <20101020154045.GA18353@elte.hu>
References: <1287508282.16971.386.camel@gandalf.stny.rr.com>
	 <20101019184111.GA17266@elte.hu>  <20101020154045.GA18353@elte.hu>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 20 Oct 2010 12:37:55 -0400
Message-ID: <1287592675.16971.559.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-10-20 at 17:40 +0200, Ingo Molnar wrote:
> FYI, there's a new mystery hang (sometimes crash) that triggers in -tip - and which 
> seems to be tracing related. See the crashlog below - config attached.
> 
> It's not bisectable - small changes in the kernel make the bug come/go. (might be a 
> race of some sorts)
> 

[...]

> [   38.424656] Running tests on all trace events:
> [   38.428006] Testing all events: OK
> [   38.604658] Running tests again, along with the function tracer
> [   38.608024] Running tests on trace events:

[...]

> [   42.321523] Running tests on all trace events:
> [   42.324027] Testing all events: 
> [  245.668090] INFO: task swapper:1 blocked for more than 120 seconds.
> [  245.672051] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [  245.676026] swapper       D f6420b40  6544     1      0 0x00000000
> [  245.684051]  f6437dac 00000046 f694aac0 f6420b40 f6438000 f6437d74 f6438294 f6438290
> [  245.692237]  c2192ac0 c204e6c0 c2192ac0 c2192ac0 f6438290 00000000 f6438000 ff2ffa7d
> [  245.701068]  00000009 f6420b40 f6437e5c 7fffffff f6438000 f6437dfc f6437e5c 7fffffff
> [  245.709071] Call Trace:
> [  245.711551]  [<c1a7f561>] schedule_timeout+0x1c/0x1e7
> [  245.712036]  [<c1a818b6>] ? _raw_spin_unlock_irq+0x2d/0x43
> [  245.716037]  [<c1027f2d>] ? sub_preempt_count+0x4/0x98
> [  245.720061]  [<c1a818b6>] ? _raw_spin_unlock_irq+0x2d/0x43
> [  245.724036]  [<c1027fb4>] ? sub_preempt_count+0x8b/0x98
> [  245.728036]  [<c1a7e76b>] wait_for_common+0xc1/0x11a
> [  245.732062]  [<c102de32>] ? default_wake_function+0x0/0x12
> [  245.736041]  [<c1a7e863>] wait_for_completion+0x17/0x19
> [  245.740069]  [<c10667a2>] __stop_cpus+0xdd/0x103
> [  245.744072]  [<c1a7e6db>] ? wait_for_common+0x31/0x11a
> [  245.748040]  [<c10665a4>] ? stop_machine_cpu_stop+0x0/0x9a
> [  245.752040]  [<c106683d>] stop_cpus+0x2c/0x3f


> [  245.756069]  [<c10668af>] __stop_machine+0x5f/0x67
> [  245.760186]  [<c1006240>] ? stop_machine_text_poke+0x0/0x43
> [  245.764040]  [<c1006240>] ? stop_machine_text_poke+0x0/0x43
> [  245.768071]  [<c19f0a73>] ? cfdgml_create+0x2b/0xde
> [  245.772040]  [<c10060fd>] text_poke_smp+0x3a/0x42
> [  245.776039]  [<c19f0a73>] ? cfdgml_create+0x2b/0xde
> [  245.780098]  [<c1005b9c>] arch_jump_label_transform+0x53/0x67
> [  245.784042]  [<c104ef0d>] jump_label_update+0x49/0x98

jump_label_update uses stop_machine to enable each tracepoint. Thus this
is stressing stop machine.

Does this only happen on i386, or do we get this on x86_64 too?

-- Steve


> [  245.788041]  [<c1070b33>] tracepoint_update_probe_range+0xec/0x116
> [  245.792070]  [<c1070c74>] tracepoint_probe_unregister+0x51/0x6b
> [  245.796040]  [<c107f3c0>] ftrace_event_reg+0x48/0x4c
> [  245.800041]  [<c107e87c>] ftrace_event_enable_disable+0x39/0x8a
> [  245.804070]  [<c107ebdf>] __ftrace_set_clr_event+0x91/0xbc
> [  245.808043]  [<c1fbee72>] event_trace_self_tests+0x1cd/0x239
> [  245.812040]  [<c1fbf025>] event_trace_self_tests_init+0x2a/0x39
> [  245.816230]  [<c1fab282>] do_one_initcall+0x47/0x113
> [  245.820069]  [<c1fbeffb>] ? event_trace_self_tests_init+0x0/0x39
> [  245.824040]  [<c1fbeffb>] ? event_trace_self_tests_init+0x0/0x39
> [  245.828069]  [<c1fab477>] kernel_init+0x10d/0x18e
> [  245.832040]  [<c1fab36a>] ? kernel_init+0x0/0x18e
> [  245.836040]  [<c1002c7e>] kernel_thread_helper+0x6/0x10
> [  245.840060] 5 locks held by swapper/1:
> [  245.844028]  #0:  (event_mutex){......}, at: [<c107eb6a>] __ftrace_set_clr_event+0x1c/0xbc
> [  245.852058]  #1:  (tracepoints_mutex){......}, at: [<c1070a6e>] tracepoint_update_probe_range+0x27/0x116
> [  245.860195]  #2:  (jump_label_mutex){......}, at: [<c104eee3>] jump_label_update+0x1f/0x98
> [  245.872028]  #3:  (text_mutex){......}, at: [<c1005b8d>] arch_jump_label_transform+0x44/0x67
> [  245.880028]  #4:  (stop_cpus_mutex){......}, at: [<c1066831>] stop_cpus+0x20/0x3f
> [  324.576593] kworker/u:0 used greatest stack depth: 6484 bytes left
> [  365.888113] INFO: task swapper:1 blocked for more than 120 seconds.
> [  365.892050] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [  365.896026] swapper       D f6420b40  6544     1      0 0x00000000
> [  365.904026]  f6437dac 00000046 f694aac0 f6420b40 f6438000 f6437d74 f6438294 f6438290
> [  365.912254]  c2192ac0 c204e6c0 c2192ac0 c2192ac0 f6438290 00000000 f6438000 ff2ffa7d
> [  365.921041]  00000009 f6420b40 f6437e5c 7fffffff f6438000 f6437dfc f6437e5c 7fffffff
> [  365.929044] Call Trace:
> [  365.931527]  [<c1a7f561>] schedule_timeout+0x1c/0x1e7
> [  365.932060]  [<c1a818b6>] ? _raw_spin_unlock_irq+0x2d/0x43
> [  365.936061]  [<c1027f2d>] ? sub_preempt_count+0x4/0x98
> [  365.940036]  [<c1a818b6>] ? _raw_spin_unlock_irq+0x2d/0x43
> [  365.944036]  [<c1027fb4>] ? sub_preempt_count+0x8b/0x98
> [  365.948061]  [<c1a7e76b>] wait_for_common+0xc1/0x11a
> [  365.952036]  [<c102de32>] ? default_wake_function+0x0/0x12
> [  365.956035]  [<c1a7e863>] wait_for_completion+0x17/0x19
> [  365.960060]  [<c10667a2>] __stop_cpus+0xdd/0x103
> [  365.964038]  [<c1a7e6db>] ? wait_for_common+0x31/0x11a
> [  365.968035]  [<c10665a4>] ? stop_machine_cpu_stop+0x0/0x9a
> [  365.972085]  [<c106683d>] stop_cpus+0x2c/0x3f
> [  365.976035]  [<c10668af>] __stop_machine+0x5f/0x67
> [  365.980035]  [<c1006240>] ? stop_machine_text_poke+0x0/0x43
> [  365.984061]  [<c1006240>] ? stop_machine_text_poke+0x0/0x43
> [  365.988036]  [<c19f0a73>] ? cfdgml_create+0x2b/0xde
> [  365.992035]  [<c10060fd>] text_poke_smp+0x3a/0x42
> [  365.996069]  [<c19f0a73>] ? cfdgml_create+0x2b/0xde
> [  366.000324]  [<c1005b9c>] arch_jump_label_transform+0x53/0x67
> [  366.004042]  [<c104ef0d>] jump_label_update+0x49/0x98
> [  366.008070]  [<c1070b33>] tracepoint_update_probe_range+0xec/0x116
> [  366.012069]  [<c1070c74>] tracepoint_probe_unregister+0x51/0x6b
> [  366.016040]  [<c107f3c0>] ftrace_event_reg+0x48/0x4c
> [  366.020070]  [<c107e87c>] ftrace_event_enable_disable+0x39/0x8a
> [  366.024041]  [<c107ebdf>] __ftrace_set_clr_event+0x91/0xbc
> [  366.028042]  [<c1fbee72>] event_trace_self_tests+0x1cd/0x239
> [  366.032069]  [<c1fbf025>] event_trace_self_tests_init+0x2a/0x39
> [  366.036040]  [<c1fab282>] do_one_initcall+0x47/0x113
> [  366.040040]  [<c1fbeffb>] ? event_trace_self_tests_init+0x0/0x39
> [  366.044069]  [<c1fbeffb>] ? event_trace_self_tests_init+0x0/0x39
> [  366.048040]  [<c1fab477>] kernel_init+0x10d/0x18e
> [  366.052068]  [<c1fab36a>] ? kernel_init+0x0/0x18e
> [  366.056069]  [<c1002c7e>] kernel_thread_helper+0x6/0x10
> [  366.060031] 5 locks held by swapper/1:
> [  366.064029]  #0:  (event_mutex){......}, at: [<c107eb6a>] __ftrace_set_clr_event+0x1c/0xbc
> [  366.072029]  #1:  (tracepoints_mutex){......}, at: [<c1070a6e>] tracepoint_update_probe_range+0x27/0x116
> [  366.080058]  #2:  (jump_label_mutex){......}, at: [<c104eee3>] jump_label_update+0x1f/0x98
> [  366.092086]  #3:  (text_mutex){......}, at: [<c1005b8d>] arch_jump_label_transform+0x44/0x67
> [  366.100166]  #4:  (stop_cpus_mutex){......}, at: [<c1066831>] stop_cpus+0x20/0x3f
> [  486.108087] INFO: task swapper:1 blocked for more than 120 seconds.
> [  486.112027] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [  486.116051] swapper       D f6420b40  6544     1      0 0x00000000
> [  486.124026]  f6437dac 00000046 f694aac0 f6420b40 f6438000 f6437d74 f6438294 f6438290
> [  486.132232]  c2192ac0 c204e6c0 c2192ac0 c2192ac0 f6438290 00000000 f6438000 ff2ffa7d
> [  486.140411]  00000009 f6420b40 f6437e5c 7fffffff f6438000 f6437dfc f6437e5c 7fffffff
> [  486.149040] Call Trace:
> [  486.151516]  [<c1a7f561>] schedule_timeout+0x1c/0x1e7
> [  486.152061]  [<c1a818b6>] ? _raw_spin_unlock_irq+0x2d/0x43
> [  486.156035]  [<c1027f2d>] ? sub_preempt_count+0x4/0x98
> [  486.160035]  [<c1a818b6>] ? _raw_spin_unlock_irq+0x2d/0x43
> [  486.164061]  [<c1027fb4>] ? sub_preempt_count+0x8b/0x98
> [  486.168035]  [<c1a7e76b>] wait_for_common+0xc1/0x11a
> [  486.172036]  [<c102de32>] ? default_wake_function+0x0/0x12
> [  486.176061]  [<c1a7e863>] wait_for_completion+0x17/0x19
> [  486.180060]  [<c10667a2>] __stop_cpus+0xdd/0x103
> [  486.184037]  [<c1a7e6db>] ? wait_for_common+0x31/0x11a
> [  486.188060]  [<c10665a4>] ? stop_machine_cpu_stop+0x0/0x9a
> [  486.192035]  [<c106683d>] stop_cpus+0x2c/0x3f
> [  486.196035]  [<c10668af>] __stop_machine+0x5f/0x67
> [  486.200060]  [<c1006240>] ? stop_machine_text_poke+0x0/0x43
> [  486.204035]  [<c1006240>] ? stop_machine_text_poke+0x0/0x43
> [  486.208041]  [<c19f0a73>] ? cfdgml_create+0x2b/0xde
> [  486.212070]  [<c10060fd>] text_poke_smp+0x3a/0x42
> [  486.216039]  [<c19f0a73>] ? cfdgml_create+0x2b/0xde
> [  486.220070]  [<c1005b9c>] arch_jump_label_transform+0x53/0x67
> [  486.224070]  [<c104ef0d>] jump_label_update+0x49/0x98
> [  486.228041]  [<c1070b33>] tracepoint_update_probe_range+0xec/0x116
> [  486.232041]  [<c1070c74>] tracepoint_probe_unregister+0x51/0x6b
> [  486.236069]  [<c107f3c0>] ftrace_event_reg+0x48/0x4c
> [  486.240179]  [<c107e87c>] ftrace_event_enable_disable+0x39/0x8a
> [  486.244041]  [<c107ebdf>] __ftrace_set_clr_event+0x91/0xbc
> [  486.248071]  [<c1fbee72>] event_trace_self_tests+0x1cd/0x239
> [  486.252041]  [<c1fbf025>] event_trace_self_tests_init+0x2a/0x39
> [  486.256040]  [<c1fab282>] do_one_initcall+0x47/0x113
> [  486.260098]  [<c1fbeffb>] ? event_trace_self_tests_init+0x0/0x39
> [  486.264040]  [<c1fbeffb>] ? event_trace_self_tests_init+0x0/0x39
> [  486.268041]  [<c1fab477>] kernel_init+0x10d/0x18e
> [  486.272069]  [<c1fab36a>] ? kernel_init+0x0/0x18e
> [  486.276040]  [<c1002c7e>] kernel_thread_helper+0x6/0x10
> [  486.280031] 5 locks held by swapper/1:
> [  486.284058]  #0:  (event_mutex){......}, at: [<c107eb6a>] __ftrace_set_clr_event+0x1c/0xbc
> [  486.292029]  #1:  (tracepoints_mutex){......}, at: [<c1070a6e>] tracepoint_update_probe_range+0x27/0x116
> [  486.300057]  #2:  (jump_label_mutex){......}, at: [<c104eee3>] jump_label_update+0x1f/0x98
> [  486.311742]  #3:  (text_mutex){......}, at: [<c1005b8d>] arch_jump_label_transform+0x44/0x67
> [  486.320058]  #4:  (stop_cpus_mutex){......}, at: [<c1066831>] stop_cpus+0x20/0x3f
> [  606.328087] INFO: task swapper:1 blocked for more than 120 seconds.
> [  606.332051] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [  606.336026] swapper       D f6420b40  6544     1      0 0x00000000
> [  606.344051]  f6437dac 00000046 f694aac0 f6420b40 f6438000 f6437d74 f6438294 f6438290
> [  606.352229]  c2192ac0 c204e6c0 c2192ac0 c2192ac0 f6438290 00000000 f6438000 ff2ffa7d
> [  606.360229]  00000009 f6420b40 f6437e5c 7fffffff f6438000 f6437dfc f6437e5c 7fffffff
> [  606.368255] Call Trace:
> [  606.370731]  [<c1a7f561>] schedule_timeout+0x1c/0x1e7
> [  606.372035]  [<c1a818b6>] ? _raw_spin_unlock_irq+0x2d/0x43
> [  606.376035]  [<c1027f2d>] ? sub_preempt_count+0x4/0x98
> [  606.380187]  [<c1a818b6>] ? _raw_spin_unlock_irq+0x2d/0x43
> [  606.384036]  [<c1027fb4>] ? sub_preempt_count+0x8b/0x98
> [  606.388035]  [<c1a7e76b>] wait_for_common+0xc1/0x11a
> [  606.392062]  [<c102de32>] ? default_wake_function+0x0/0x12
> [  606.396061]  [<c1a7e863>] wait_for_completion+0x17/0x19
> [  606.400034]  [<c10667a2>] __stop_cpus+0xdd/0x103
> [  606.404063]  [<c1a7e6db>] ? wait_for_common+0x31/0x11a
> [  606.408035]  [<c10665a4>] ? stop_machine_cpu_stop+0x0/0x9a
> [  606.412035]  [<c106683d>] stop_cpus+0x2c/0x3f
> [  606.416061]  [<c10668af>] __stop_machine+0x5f/0x67
> [  606.420035]  [<c1006240>] ? stop_machine_text_poke+0x0/0x43
> [  606.424035]  [<c1006240>] ? stop_machine_text_poke+0x0/0x43
> [  606.428070]  [<c19f0a73>] ? cfdgml_create+0x2b/0xde
> [  606.432040]  [<c10060fd>] text_poke_smp+0x3a/0x42
> [  606.436068]  [<c19f0a73>] ? cfdgml_create+0x2b/0xde
> [  606.440070]  [<c1005b9c>] arch_jump_label_transform+0x53/0x67
> [  606.444041]  [<c104ef0d>] jump_label_update+0x49/0x98
> [  606.448041]  [<c1070b33>] tracepoint_update_probe_range+0xec/0x116
> [  606.452070]  [<c1070c74>] tracepoint_probe_unregister+0x51/0x6b
> [  606.456040]  [<c107f3c0>] ftrace_event_reg+0x48/0x4c
> [  606.460041]  [<c107e87c>] ftrace_event_enable_disable+0x39/0x8a
> [  606.464070]  [<c107ebdf>] __ftrace_set_clr_event+0x91/0xbc
> [  606.468042]  [<c1fbee72>] event_trace_self_tests+0x1cd/0x239
> [  606.472041]  [<c1fbf025>] event_trace_self_tests_init+0x2a/0x39
> [  606.476098]  [<c1fab282>] do_one_initcall+0x47/0x113
> [  606.480179]  [<c1fbeffb>] ? event_trace_self_tests_init+0x0/0x39
> [  606.484040]  [<c1fbeffb>] ? event_trace_self_tests_init+0x0/0x39
> [  606.488070]  [<c1fab477>] kernel_init+0x10d/0x18e
> [  606.492040]  [<c1fab36a>] ? kernel_init+0x0/0x18e
> [  606.496040]  [<c1002c7e>] kernel_thread_helper+0x6/0x10
> [  606.500060] 5 locks held by swapper/1:
> [  606.504029]  #0:  (event_mutex){......}, at: [<c107eb6a>] __ftrace_set_clr_event+0x1c/0xbc
> [  606.512058]  #1:  (tracepoints_mutex){......}, at: [<c1070a6e>] tracepoint_update_probe_range+0x27/0x116
> [  606.520029]  #2:  (jump_label_mutex){......}, at: [<c104eee3>] jump_label_update+0x1f/0x98
> [  606.531719]  #3:  (text_mutex){......}, at: [<c1005b8d>] arch_jump_label_transform+0x44/0x67
> [  606.540029]  #4:  (stop_cpus_mutex){......}, at: [<c1066831>] stop_cpus+0x20/0x3f
> [  726.548112] INFO: task swapper:1 blocked for more than 120 seconds.
> [  726.552025] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [  726.556026] swapper       D f6420b40  6544     1      0 0x00000000
> [  726.564026]  f6437dac 00000046 f694aac0 f6420b40 f6438000 f6437d74 f6438294 f6438290
> [  726.572254]  c2192ac0 c204e6c0 c2192ac0 c2192ac0 f6438290 00000000 f6438000 ff2ffa7d
> [  726.580256]  00000009 f6420b40 f6437e5c 7fffffff f6438000 f6437dfc f6437e5c 7fffffff
> [  726.589045] Call Trace:
> [  726.591527]  [<c1a7f561>] schedule_timeout+0x1c/0x1e7
> [  726.592035]  [<c1a818b6>] ? _raw_spin_unlock_irq+0x2d/0x43
> [  726.596061]  [<c1027f2d>] ? sub_preempt_count+0x4/0x98
> [  726.600036]  [<c1a818b6>] ? _raw_spin_unlock_irq+0x2d/0x43
> [  726.604036]  [<c1027fb4>] ? sub_preempt_count+0x8b/0x98
> [  726.608061]  [<c1a7e76b>] wait_for_common+0xc1/0x11a
> [  726.612036]  [<c102de32>] ? default_wake_function+0x0/0x12
> [  726.616036]  [<c1a7e863>] wait_for_completion+0x17/0x19
> [  726.620211]  [<c10667a2>] __stop_cpus+0xdd/0x103
> [  726.624038]  [<c1a7e6db>] ? wait_for_common+0x31/0x11a
> [  726.628035]  [<c10665a4>] ? stop_machine_cpu_stop+0x0/0x9a
> [  726.632060]  [<c106683d>] stop_cpus+0x2c/0x3f
> [  726.636035]  [<c10668af>] __stop_machine+0x5f/0x67
> [  726.640035]  [<c1006240>] ? stop_machine_text_poke+0x0/0x43
> [  726.644061]  [<c1006240>] ? stop_machine_text_poke+0x0/0x43
> [  726.648041]  [<c19f0a73>] ? cfdgml_create+0x2b/0xde
> [  726.652040]  [<c10060fd>] text_poke_smp+0x3a/0x42
> [  726.656069]  [<c19f0a73>] ? cfdgml_create+0x2b/0xde
> [  726.660070]  [<c1005b9c>] arch_jump_label_transform+0x53/0x67
> [  726.664041]  [<c104ef0d>] jump_label_update+0x49/0x98
> [  726.668070]  [<c1070b33>] tracepoint_update_probe_range+0xec/0x116
> [  726.672041]  [<c1070c74>] tracepoint_probe_unregister+0x51/0x6b
> [  726.676040]  [<c107f3c0>] ftrace_event_reg+0x48/0x4c
> [  726.680070]  [<c107e87c>] ftrace_event_enable_disable+0x39/0x8a
> [  726.684041]  [<c107ebdf>] __ftrace_set_clr_event+0x91/0xbc
> [  726.688041]  [<c1fbee72>] event_trace_self_tests+0x1cd/0x239
> [  726.692070]  [<c1fbf025>] event_trace_self_tests_init+0x2a/0x39
> [  726.696040]  [<c1fab282>] do_one_initcall+0x47/0x113
> [  726.700069]  [<c1fbeffb>] ? event_trace_self_tests_init+0x0/0x39
> [  726.704070]  [<c1fbeffb>] ? event_trace_self_tests_init+0x0/0x39
> [  726.708040]  [<c1fab477>] kernel_init+0x10d/0x18e
> [  726.712040]  [<c1fab36a>] ? kernel_init+0x0/0x18e
> [  726.716069]  [<c1002c7e>] kernel_thread_helper+0x6/0x10
> [  726.720170] 5 locks held by swapper/1:
> [  726.724029]  #0:  (event_mutex){......}, at: [<c107eb6a>] __ftrace_set_clr_event+0x1c/0xbc
> [  726.732029]  #1:  (tracepoints_mutex){......}, at: [<c1070a6e>] tracepoint_update_probe_range+0x27/0x116
> [  726.740086]  #2:  (jump_label_mutex){......}, at: [<c104eee3>] jump_label_update+0x1f/0x98
> [  726.751716]  #3:  (text_mutex){......}, at: [<c1005b8d>] arch_jump_label_transform+0x44/0x67
> [  726.760029]  #4:  (stop_cpus_mutex){......}, at: [<c1066831>] stop_cpus+0x20/0x3f
> [  846.768087] INFO: task swapper:1 blocked for more than 120 seconds.
> [  846.772025] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [  846.776051] swapper       D f6420b40  6544     1      0 0x00000000
> [  846.784026]  f6437dac 00000046 f694aac0 f6420b40 f6438000 f6437d74 f6438294 f6438290
> [  846.792228]  c2192ac0 c204e6c0 c2192ac0 c2192ac0 f6438290 00000000 f6438000 ff2ffa7d
> [  846.800257]  00000009 f6420b40 f6437e5c 7fffffff f6438000 f6437dfc f6437e5c 7fffffff
> [  846.808228] Call Trace:
> [  846.810704]  [<c1a7f561>] schedule_timeout+0x1c/0x1e7
> [  846.812061]  [<c1a818b6>] ? _raw_spin_unlock_irq+0x2d/0x43
> [  846.816035]  [<c1027f2d>] ? sub_preempt_count+0x4/0x98
> [  846.820061]  [<c1a818b6>] ? _raw_spin_unlock_irq+0x2d/0x43
> [  846.824061]  [<c1027fb4>] ? sub_preempt_count+0x8b/0x98
> [  846.828035]  [<c1a7e76b>] wait_for_common+0xc1/0x11a
> [  846.832036]  [<c102de32>] ? default_wake_function+0x0/0x12
> [  846.836061]  [<c1a7e863>] wait_for_completion+0x17/0x19
> [  846.840034]  [<c10667a2>] __stop_cpus+0xdd/0x103
> [  846.844037]  [<c1a7e6db>] ? wait_for_common+0x31/0x11a
> [  846.848060]  [<c10665a4>] ? stop_machine_cpu_stop+0x0/0x9a
> [  846.852035]  [<c106683d>] stop_cpus+0x2c/0x3f
> [  846.856036]  [<c10668af>] __stop_machine+0x5f/0x67
> [  846.860211]  [<c1006240>] ? stop_machine_text_poke+0x0/0x43
> [  846.864035]  [<c1006240>] ? stop_machine_text_poke+0x0/0x43
> [  846.868035]  [<c19f0a73>] ? cfdgml_create+0x2b/0xde
> [  846.872061]  [<c10060fd>] text_poke_smp+0x3a/0x42
> [  846.876039]  [<c19f0a73>] ? cfdgml_create+0x2b/0xde
> [  846.880041]  [<c1005b9c>] arch_jump_label_transform+0x53/0x67
> [  846.884070]  [<c104ef0d>] jump_label_update+0x49/0x98
> [  846.888041]  [<c1070b33>] tracepoint_update_probe_range+0xec/0x116
> [  846.892041]  [<c1070c74>] tracepoint_probe_unregister+0x51/0x6b
> [  846.896069]  [<c107f3c0>] ftrace_event_reg+0x48/0x4c
> [  846.900069]  [<c107e87c>] ftrace_event_enable_disable+0x39/0x8a
> [  846.904041]  [<c107ebdf>] __ftrace_set_clr_event+0x91/0xbc
> [  846.908071]  [<c1fbee72>] event_trace_self_tests+0x1cd/0x239
> [  846.912041]  [<c1fbf025>] event_trace_self_tests_init+0x2a/0x39
> [  846.916040]  [<c1fab282>] do_one_initcall+0x47/0x113
> [  846.920069]  [<c1fbeffb>] ? event_trace_self_tests_init+0x0/0x39
> [  846.928045]  [<c1fbeffb>] ? event_trace_self_tests_init+0x0/0x39
> [  846.932066]  [<c1fab477>] kernel_init+0x10d/0x18e
> [  846.936040]  [<c1fab36a>] ? kernel_init+0x0/0x18e
> [  846.940069]  [<c1002c7e>] kernel_thread_helper+0x6/0x10
> [  846.944060] 5 locks held by swapper/1:
> [  846.948029]  #0:  (event_mutex){......}, at: [<c107eb6a>] __ftrace_set_clr_event+0x1c/0xbc
> [  846.956058]  #1:  (tracepoints_mutex){......}, at: [<c1070a6e>] tracepoint_update_probe_range+0x27/0x116
> [  846.964029]  #2:  (jump_label_mutex){......}, at: [<c104eee3>] jump_label_update+0x1f/0x98
> [  846.975709]  #3:  (text_mutex){......}, at: [<c1005b8d>] arch_jump_label_transform+0x44/0x67
> [  846.984029]  #4:  (stop_cpus_mutex){......}, at: [<c1066831>] stop_cpus+0x20/0x3f
> [  966.992112] INFO: task swapper:1 blocked for more than 120 seconds.
> [  966.996025] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [  967.000275] swapper       D f6420b40  6544     1      0 0x00000000
> [  967.008026]  f6437dac 00000046 f694aac0 f6420b40 f6438000 f6437d74 f6438294 f6438290
> [  967.017042]  c2192ac0 c204e6c0 c2192ac0 c2192ac0 f6438290 00000000 f6438000 ff2ffa7d
> [  967.025044]  00000009 f6420b40 f6437e5c 7fffffff f6438000 f6437dfc f6437e5c 7fffffff
> [  967.033044] Call Trace:
> [  967.035520]  [<c1a7f561>] schedule_timeout+0x1c/0x1e7
> [  967.036035]  [<c1a818b6>] ? _raw_spin_unlock_irq+0x2d/0x43
> [  967.040061]  [<c1027f2d>] ? sub_preempt_count+0x4/0x98
> [  967.044036]  [<c1a818b6>] ? _raw_spin_unlock_irq+0x2d/0x43
> [  967.048036]  [<c1027fb4>] ? sub_preempt_count+0x8b/0x98
> [  967.052061]  [<c1a7e76b>] wait_for_common+0xc1/0x11a
> [  967.056036]  [<c102de32>] ? default_wake_function+0x0/0x12
> [  967.060061]  [<c1a7e863>] wait_for_completion+0x17/0x19
> [  967.064060]  [<c10667a2>] __stop_cpus+0xdd/0x103
> [  967.068038]  [<c1a7e6db>] ? wait_for_common+0x31/0x11a
> [  967.072035]  [<c10665a4>] ? stop_machine_cpu_stop+0x0/0x9a
> [  967.076060]  [<c106683d>] stop_cpus+0x2c/0x3f
> [  967.080035]  [<c10668af>] __stop_machine+0x5f/0x67
> [  967.084035]  [<c1006240>] ? stop_machine_text_poke+0x0/0x43
> [  967.088061]  [<c1006240>] ? stop_machine_text_poke+0x0/0x43
> [  967.092041]  [<c19f0a73>] ? cfdgml_create+0x2b/0xde
> [  967.096040]  [<c10060fd>] text_poke_smp+0x3a/0x42
> [  967.100236]  [<c19f0a73>] ? cfdgml_create+0x2b/0xde
> [  967.104041]  [<c1005b9c>] arch_jump_label_transform+0x53/0x67
> [  967.108041]  [<c104ef0d>] jump_label_update+0x49/0x98
> [  967.112070]  [<c1070b33>] tracepoint_update_probe_range+0xec/0x116
> [  967.116041]  [<c1070c74>] tracepoint_probe_unregister+0x51/0x6b
> [  967.120040]  [<c107f3c0>] ftrace_event_reg+0x48/0x4c
> [  967.124070]  [<c107e87c>] ftrace_event_enable_disable+0x39/0x8a
> [  967.128041]  [<c107ebdf>] __ftrace_set_clr_event+0x91/0xbc
> [  967.132042]  [<c1fbee72>] event_trace_self_tests+0x1cd/0x239
> [  967.136070]  [<c1fbf025>] event_trace_self_tests_init+0x2a/0x39
> [  967.140069]  [<c1fab282>] do_one_initcall+0x47/0x113
> [  967.144040]  [<c1fbeffb>] ? event_trace_self_tests_init+0x0/0x39
> [  967.148070]  [<c1fbeffb>] ? event_trace_self_tests_init+0x0/0x39
> [  967.152041]  [<c1fab477>] kernel_init+0x10d/0x18e
> [  967.156040]  [<c1fab36a>] ? kernel_init+0x0/0x18e
> [  967.164032]  [<c1002c7e>] kernel_thread_helper+0x6/0x10
> [  967.168031] 5 locks held by swapper/1:
> [  967.172058]  #0:  (event_mutex){......}, at: [<c107eb6a>] __ftrace_set_clr_event+0x1c/0xbc
> [  967.180057]  #1:  (tracepoints_mutex){......}, at: [<c1070a6e>] tracepoint_update_probe_range+0x27/0x116
> [  967.188029]  #2:  (jump_label_mutex){......}, at: [<c104eee3>] jump_label_update+0x1f/0x98
> [  967.200158]  #3:  (text_mutex){......}, at: [<c1005b8d>] arch_jump_label_transform+0x44/0x67
> [  967.208058]  #4:  (stop_cpus_mutex){......}, at: [<c1066831>] stop_cpus+0x20/0x3f
> [ 1087.216087] INFO: task swapper:1 blocked for more than 120 seconds.
> [ 1087.220076] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [ 1087.224026] swapper       D f6420b40  6544     1      0 0x00000000
> [ 1087.232051]  f6437dac 00000046 f694aac0 f6420b40 f6438000 f6437d74 f6438294 f6438290
> [ 1087.240358]  c2192ac0 c204e6c0 c2192ac0 c2192ac0 f6438290 00000000 f6438000 ff2ffa7d
> [ 1087.249034]  00000009 f6420b40 f6437e5c 7fffffff f6438000 f6437dfc f6437e5c 7fffffff
> [ 1087.257071] Call Trace:
> [ 1087.259553]  [<c1a7f561>] schedule_timeout+0x1c/0x1e7
> [ 1087.260060]  [<c1a818b6>] ? _raw_spin_unlock_irq+0x2d/0x43
> [ 1087.264035]  [<c1027f2d>] ? sub_preempt_count+0x4/0x98
> [ 1087.268061]  [<c1a818b6>] ? _raw_spin_unlock_irq+0x2d/0x43
> [ 1087.272037]  [<c1027fb4>] ? sub_preempt_count+0x8b/0x98
> [ 1087.276035]  [<c1a7e76b>] wait_for_common+0xc1/0x11a
> [ 1087.280061]  [<c102de32>] ? default_wake_function+0x0/0x12
> [ 1087.284036]  [<c1a7e863>] wait_for_completion+0x17/0x19
> [ 1087.288034]  [<c10667a2>] __stop_cpus+0xdd/0x103
> [ 1087.292063]  [<c1a7e6db>] ? wait_for_common+0x31/0x11a
> [ 1087.296035]  [<c10665a4>] ? stop_machine_cpu_stop+0x0/0x9a
> [ 1087.300060]  [<c106683d>] stop_cpus+0x2c/0x3f
> [ 1087.304060]  [<c10668af>] __stop_machine+0x5f/0x67
> [ 1087.308035]  [<c1006240>] ? stop_machine_text_poke+0x0/0x43
> [ 1087.312035]  [<c1006240>] ? stop_machine_text_poke+0x0/0x43
> [ 1087.316070]  [<c19f0a73>] ? cfdgml_create+0x2b/0xde
> [ 1087.320040]  [<c10060fd>] text_poke_smp+0x3a/0x42
> [ 1087.324039]  [<c19f0a73>] ? cfdgml_create+0x2b/0xde
> [ 1087.328070]  [<c1005b9c>] arch_jump_label_transform+0x53/0x67
> [ 1087.332041]  [<c104ef0d>] jump_label_update+0x49/0x98
> [ 1087.336041]  [<c1070b33>] tracepoint_update_probe_range+0xec/0x116
> [ 1087.340237]  [<c1070c74>] tracepoint_probe_unregister+0x51/0x6b
> [ 1087.344040]  [<c107f3c0>] ftrace_event_reg+0x48/0x4c
> [ 1087.348041]  [<c107e87c>] ftrace_event_enable_disable+0x39/0x8a
> [ 1087.352070]  [<c107ebdf>] __ftrace_set_clr_event+0x91/0xbc
> [ 1087.356042]  [<c1fbee72>] event_trace_self_tests+0x1cd/0x239
> [ 1087.360041]  [<c1fbf025>] event_trace_self_tests_init+0x2a/0x39
> [ 1087.364070]  [<c1fab282>] do_one_initcall+0x47/0x113
> [ 1087.368040]  [<c1fbeffb>] ? event_trace_self_tests_init+0x0/0x39
> [ 1087.372040]  [<c1fbeffb>] ? event_trace_self_tests_init+0x0/0x39
> [ 1087.376070]  [<c1fab477>] kernel_init+0x10d/0x18e
> [ 1087.380069]  [<c1fab36a>] ? kernel_init+0x0/0x18e
> [ 1087.384040]  [<c1002c7e>] kernel_thread_helper+0x6/0x10
> [ 1087.388060] 5 locks held by swapper/1:
> [ 1087.392029]  #0:  (event_mutex){......}, at: [<c107eb6a>] __ftrace_set_clr_event+0x1c/0xbc
> [ 1087.400058]  #1:  (tracepoints_mutex){......}, at: [<c1070a6e>] tracepoint_update_probe_range+0x27/0x116
> [ 1087.408029]  #2:  (jump_label_mutex){......}, at: [<c104eee3>] jump_label_update+0x1f/0x98
> [ 1087.419709]  #3:  (text_mutex){......}, at: [<c1005b8d>] arch_jump_label_transform+0x44/0x67
> [ 1087.428029]  #4:  (stop_cpus_mutex){......}, at: [<c1066831>] stop_cpus+0x20/0x3f
> [ 1207.436112] INFO: task swapper:1 blocked for more than 120 seconds.
> [ 1207.440025] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [ 1207.444026] swapper       D f6420b40  6544     1      0 0x00000000
> [ 1207.452025]  f6437dac 00000046 f694aac0 f6420b40 f6438000 f6437d74 f6438294 f6438290
> [ 1207.460254]  c2192ac0 c204e6c0 c2192ac0 c2192ac0 f6438290 00000000 f6438000 ff2ffa7d
> [ 1207.468228]  00000009 f6420b40 f6437e5c 7fffffff f6438000 f6437dfc f6437e5c 7fffffff
> [ 1207.477044] Call Trace:
> [ 1207.479519]  [<c1a7f561>] schedule_timeout+0x1c/0x1e7
> [ 1207.480161]  [<c1a818b6>] ? _raw_spin_unlock_irq+0x2d/0x43
> [ 1207.484061]  [<c1027f2d>] ? sub_preempt_count+0x4/0x98
> [ 1207.488061]  [<c1a818b6>] ? _raw_spin_unlock_irq+0x2d/0x43
> [ 1207.492036]  [<c1027fb4>] ? sub_preempt_count+0x8b/0x98
> [ 1207.496061]  [<c1a7e76b>] wait_for_common+0xc1/0x11a
> [ 1207.500036]  [<c102de32>] ? default_wake_function+0x0/0x12
> [ 1207.504036]  [<c1a7e863>] wait_for_completion+0x17/0x19
> [ 1207.508060]  [<c10667a2>] __stop_cpus+0xdd/0x103
> [ 1207.512037]  [<c1a7e6db>] ? wait_for_common+0x31/0x11a
> [ 1207.516035]  [<c10665a4>] ? stop_machine_cpu_stop+0x0/0x9a
> [ 1207.520060]  [<c106683d>] stop_cpus+0x2c/0x3f
> [ 1207.524035]  [<c10668af>] __stop_machine+0x5f/0x67
> [ 1207.528060]  [<c1006240>] ? stop_machine_text_poke+0x0/0x43
> [ 1207.532061]  [<c1006240>] ? stop_machine_text_poke+0x0/0x43
> [ 1207.536041]  [<c19f0a73>] ? cfdgml_create+0x2b/0xde
> [ 1207.540040]  [<c10060fd>] text_poke_smp+0x3a/0x42
> [ 1207.544069]  [<c19f0a73>] ? cfdgml_create+0x2b/0xde
> [ 1207.548041]  [<c1005b9c>] arch_jump_label_transform+0x53/0x67
> [ 1207.552041]  [<c104ef0d>] jump_label_update+0x49/0x98
> [ 1207.556070]  [<c1070b33>] tracepoint_update_probe_range+0xec/0x116
> [ 1207.560041]  [<c1070c74>] tracepoint_probe_unregister+0x51/0x6b
> [ 1207.564040]  [<c107f3c0>] ftrace_event_reg+0x48/0x4c
> [ 1207.568098]  [<c107e87c>] ftrace_event_enable_disable+0x39/0x8a
> [ 1207.572041]  [<c107ebdf>] __ftrace_set_clr_event+0x91/0xbc
> [ 1207.576042]  [<c1fbee72>] event_trace_self_tests+0x1cd/0x239
> [ 1207.580208]  [<c1fbf025>] event_trace_self_tests_init+0x2a/0x39
> [ 1207.584040]  [<c1fab282>] do_one_initcall+0x47/0x113
> [ 1207.588040]  [<c1fbeffb>] ? event_trace_self_tests_init+0x0/0x39
> [ 1207.592070]  [<c1fbeffb>] ? event_trace_self_tests_init+0x0/0x39
> [ 1207.596041]  [<c1fab477>] kernel_init+0x10d/0x18e
> [ 1207.600040]  [<c1fab36a>] ? kernel_init+0x0/0x18e
> [ 1207.604069]  [<c1002c7e>] kernel_thread_helper+0x6/0x10
> [ 1207.608060] 5 locks held by swapper/1:
> [ 1207.612029]  #0:  (event_mutex){......}, at: [<c107eb6a>] __ftrace_set_clr_event+0x1c/0xbc
> [ 1207.620029]  #1:  (tracepoints_mutex){......}, at: [<c1070a6e>] tracepoint_update_probe_range+0x27/0x116
> [ 1207.628058]  #2:  (jump_label_mutex){......}, at: [<c104eee3>] jump_label_update+0x1f/0x98
> [ 1207.639716]  #3:  (text_mutex){......}, at: [<c1005b8d>] arch_jump_label_transform+0x44/0x67
> [ 1207.648057]  #4:  (stop_cpus_mutex){......}, at: [<c1066831>] stop_cpus+0x20/0x3f
> [ 1327.656087] INFO: task swapper:1 blocked for more than 120 seconds.
> [ 1327.660050] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [ 1327.664051] swapper       D f6420b40  6544     1      0 0x00000000
> [ 1327.672026]  f6437dac 00000046 f694aac0 f6420b40 f6438000 f6437d74 f6438294 f6438290
> [ 1327.680229]  c2192ac0 c204e6c0 c2192ac0 c2192ac0 f6438290 00000000 f6438000 ff2ffa7d
> [ 1327.688257]  00000009 f6420b40 f6437e5c 7fffffff f6438000 f6437dfc f6437e5c 7fffffff
> [ 1327.697044] Call Trace:
> [ 1327.699526]  [<c1a7f561>] schedule_timeout+0x1c/0x1e7
> [ 1327.700086]  [<c1a818b6>] ? _raw_spin_unlock_irq+0x2d/0x43
> [ 1327.704035]  [<c1027f2d>] ? sub_preempt_count+0x4/0x98
> [ 1327.708035]  [<c1a818b6>] ? _raw_spin_unlock_irq+0x2d/0x43
> [ 1327.712062]  [<c1027fb4>] ? sub_preempt_count+0x8b/0x98
> [ 1327.716035]  [<c1a7e76b>] wait_for_common+0xc1/0x11a
> [ 1327.720162]  [<c102de32>] ? default_wake_function+0x0/0x12
> [ 1327.724061]  [<c1a7e863>] wait_for_completion+0x17/0x19
> [ 1327.728034]  [<c10667a2>] __stop_cpus+0xdd/0x103
> [ 1327.732037]  [<c1a7e6db>] ? wait_for_common+0x31/0x11a
> [ 1327.736060]  [<c10665a4>] ? stop_machine_cpu_stop+0x0/0x9a
> [ 1327.740060]  [<c106683d>] stop_cpus+0x2c/0x3f
> [ 1327.744035]  [<c10668af>] __stop_machine+0x5f/0x67
> [ 1327.748060]  [<c1006240>] ? stop_machine_text_poke+0x0/0x43
> [ 1327.752035]  [<c1006240>] ? stop_machine_text_poke+0x0/0x43
> [ 1327.756035]  [<c19f0a73>] ? cfdgml_create+0x2b/0xde
> [ 1327.760061]  [<c10060fd>] text_poke_smp+0x3a/0x42
> [ 1327.764039]  [<c19f0a73>] ? cfdgml_create+0x2b/0xde
> [ 1327.768041]  [<c1005b9c>] arch_jump_label_transform+0x53/0x67
> [ 1327.772070]  [<c104ef0d>] jump_label_update+0x49/0x98
> [ 1327.776041]  [<c1070b33>] tracepoint_update_probe_range+0xec/0x116
> [ 1327.780070]  [<c1070c74>] tracepoint_probe_unregister+0x51/0x6b
> [ 1327.784069]  [<c107f3c0>] ftrace_event_reg+0x48/0x4c
> [ 1327.788040]  [<c107e87c>] ftrace_event_enable_disable+0x39/0x8a
> [ 1327.792041]  [<c107ebdf>] __ftrace_set_clr_event+0x91/0xbc
> [ 1327.796071]  [<c1fbee72>] event_trace_self_tests+0x1cd/0x239
> [ 1327.800041]  [<c1fbf025>] event_trace_self_tests_init+0x2a/0x39
> [ 1327.804040]  [<c1fab282>] do_one_initcall+0x47/0x113
> [ 1327.808069]  [<c1fbeffb>] ? event_trace_self_tests_init+0x0/0x39
> [ 1327.812040]  [<c1fbeffb>] ? event_trace_self_tests_init+0x0/0x39
> [ 1327.816041]  [<c1fab477>] kernel_init+0x10d/0x18e
> [ 1327.820236]  [<c1fab36a>] ? kernel_init+0x0/0x18e
> [ 1327.824040]  [<c1002c7e>] kernel_thread_helper+0x6/0x10
> [ 1327.828031] 5 locks held by swapper/1:
> [ 1327.832058]  #0:  (event_mutex){......}, at: [<c107eb6a>] __ftrace_set_clr_event+0x1c/0xbc
> [ 1327.840029]  #1:  (tracepoints_mutex){......}, at: [<c1070a6e>] tracepoint_update_probe_range+0x27/0x116
> [ 1327.848029]  #2:  (jump_label_mutex){......}, at: [<c104eee3>] jump_label_update+0x1f/0x98
> [ 1327.859745]  #3:  (text_mutex){......}, at: [<c1005b8d>] arch_jump_label_transform+0x44/0x67
> [ 1327.868058]  #4:  (stop_cpus_mutex){......}, at: [<c1066831>] stop_cpus+0x20/0x3f


