Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755909Ab1G0VwX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 17:52:23 -0400
Received: from www.linutronix.de ([62.245.132.108]:36121 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755882Ab1G0VwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 17:52:20 -0400
Date: Wed, 27 Jul 2011 23:52:18 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Yong Zhang <yong.zhang0@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: Re: migrate_disable() race with cpu hotplug?
In-Reply-To: <CAM2zO=AxRYEG=iJqrefOL34GW5ukoQKxYQdJ02mez=s5UZPoJg@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1107272350560.2660@ionos>
References: <CAM2zO=AxRYEG=iJqrefOL34GW5ukoQKxYQdJ02mez=s5UZPoJg@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Jul 2011, Yong Zhang wrote:

> When reading the code, I'm afraid there is a race between migrate_disable()
> and cpu hotplug. A scenario will like below:
> 
> 	CPU0			CPU1
> _cpu_down();
>   cpu_unplug_begin();
>     wait_for_completion()
>   			sync_unplug_thread();
> 			  complete();
> 			race_window? /*
> 				      * migrate_disable() will
> 				      * not take effect since
> 				      * hotplug is in progress
> 				      */

Rightfully so. The caller will just block on the cpu_hotplug.lock
mutex until the unplug operation will be done.

Thanks,

	tglx
