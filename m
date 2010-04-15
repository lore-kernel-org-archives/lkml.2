Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753738Ab0DOOzd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 10:55:33 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:38210 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752297Ab0DOOzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 10:55:32 -0400
Message-ID: <4BC728DD.5020404@petalogix.com>
Date: Thu, 15 Apr 2010 16:55:25 +0200
From: Michal Simek <michal.simek@petalogix.com>
Reply-To: michal.simek@petalogix.com
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
CC: Wu Zhangjin <wuzhangjin@gmail.com>
Subject: sched_clock - microblaze
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas and Steven,

I would like to improve time measuring for ftrace (Log below)

I looked at http://lkml.org/lkml/2009/11/16/181
where Thomas suggested to create sched_clock() function.
I used the same solution as Wu proposed but it is not nice.

Is unimplemented sched_clock the reason why ftrace not show fine grain time?

Or is there any other thing which is wrong?

Thanks,
Michal



Dumping ftrace buffer:
---------------------------------
  0) ! 10000.00 us |                                }
  0)   <========== |
  0) ! 10000.00 us |                            }
  0) ! 10000.00 us |                          }
  0)   0.000 us    |                          get_seconds();
  0)   0.000 us    |                          tcp_rcv_rtt_update();
  0)   0.000 us    |                          tcp_ack();
  0)   0.000 us    |                          tcp_rcv_rtt_update();
  0)   0.000 us    |                          tcp_urg();
  0)               |                          tcp_data_queue() {
  0)   0.000 us    |                            __sk_mem_schedule();
  0)   0.000 us    |                            tcp_event_data_recv();
  0)   0.000 us    |                            sock_def_readable();
  0)   0.000 us    |                          }
  0)   0.000 us    |                          tcp_check_space();
  0)               |                          __tcp_ack_snd_check() {


-- 
Michal Simek, Ing. (M.Eng)
PetaLogix - Linux Solutions for a Reconfigurable World
w: www.petalogix.com p: +61-7-30090663,+42-0-721842854 f: +61-7-30090663
