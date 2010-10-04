Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757392Ab0JDX0r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 19:26:47 -0400
Received: from ms01.sssup.it ([193.205.80.99]:56864 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752194Ab0JDX0q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 19:26:46 -0400
X-Greylist: delayed 3601 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 Oct 2010 19:26:46 EDT
Message-ID: <4CAA54A1.6050507@sssup.it>
Date: Tue, 05 Oct 2010 00:26:41 +0200
From: Tommaso Cucinotta <tommaso.cucinotta@sssup.it>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100915 Thunderbird/3.0.8
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Dhaval Giani <dhaval.giani@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dario Faggioli <faggioli@gandalf.sssup.it>,
        Fabio Checconi <fabio@gandalf.sssup.it>, linux-kernel@vger.kernel.org
Subject: 1 RT task blocks 4-core machine ?
References: <AANLkTim2icGqFWB1S6TVcQwmo+sCcGdNDPO3s8LFqzR=@mail.gmail.com>
In-Reply-To: <AANLkTim2icGqFWB1S6TVcQwmo+sCcGdNDPO3s8LFqzR=@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I noticed that I can loose control of a 2.6.35 kernel running on a 
4-core system in a way which I find quite unexpected:

   chrt -r 1 /usr/bin/yes > /dev/null

(default 95% per-cpu throttling). Ok, with rt bandwidth migration
among cores, my yes process will take undisturbed 100% of *one* core,
but I would be supposed to keep controlling the system using the
other three ones, wouldn't I ?

Instead, If I'm from a terminal, then I loose control of it, console
switching does not work anymore. Apparently I cannot do anything, but
sometimes I can log via ssh from another system.
A similar behavior happens if I try from ssh or from X.

Sometimes, my key presses (e.g., Alt-F2) are followed many many second
later. Except Alt-Sys-rq, which keep working, unless I come up with the
very bad idea of trying to "Nice all RT Tasks". This causes a real
freeze.

A possible explanation might be that the CFS load balancing logic sees
my only active task (e.g., the ssh server or shell etc.) as running
alone on its core, and does not detect that it is inhibited to actually
run due to RT tasks on the same core. Therefore, it will not migrate
the task to the free cores. Does this explanation make sense
or is it completely wrong ?

Also, I'd like to hear whether this is considered the "normal/desired"
behavior of intermixing RT and non-RT tasks.

Thanks and regards,

	Tommaso
-- 
Tommaso Cucinotta, Computer Engineering PhD, Researcher
ReTiS Lab, Scuola Superiore Sant'Anna, Pisa, Italy
Tel +39 050 882 024, Fax +39 050 882 003
http://retis.sssup.it/people/tommaso
