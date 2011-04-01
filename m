Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758137Ab1DAQIZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 12:08:25 -0400
Received: from oproxy2-pub.bluehost.com ([67.222.39.60]:57178 "HELO
	oproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758082Ab1DAQIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 12:08:24 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=pLS0KOvMrbwXoon0XfyUTpp9iub4ySgddcLsY1EfnWfEwpQ9ka3O3aW9bRk/KghtlsRYzfgcWfX8DdJullyqwtHQfi1Pi8iaiQdNsKl/VPJR9k/ewlWh+754UFcXmoTs;
Date: Fri, 1 Apr 2011 09:08:17 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Norbert Preining <preining@logic.at>
Cc: dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: Lenovo resume from suspends hangs in i915_gpu_busy or so
Message-ID: <20110401090817.01717af0@jbarnes-desktop>
In-Reply-To: <20110401051511.GE9128@gamma.logic.tuwien.ac.at>
References: <20110401021055.GB6071@gamma.logic.tuwien.ac.at>
	<20110401051511.GE9128@gamma.logic.tuwien.ac.at>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Apr 2011 14:15:11 +0900
Norbert Preining <preining@logic.at> wrote:

> Hi all,
> 
> adding dri-devel as I found it is actually not completely dead, 
> but hanging in some i915 problem.
> 
> Copyied from screen:
> Process ips-adjust (....
> Stack:
>   ....
>    ....
>   ...
> Call Trace:
>   <IRQ>
>   ... ? tick_program_event
>   call_sortirq
>   do_softirq
>   irq_exit
>   smp_apic_timer_interrupt
>   apic_timer_interrupt
>   <EOI>
>   ? _raw_spin_lock
>   i915_gpu_busy
>   ips_adjust
>   ? show_cpu_temp
>   kthread
>   kernel_thread_helper
>   ? kthread_worker_fn
>   ? gs_change
> Code: ...
> (once more more or less the same as above)

Hm, ok so on resume we're checking GPU busyness, which is normal, but
end up hanging on the spinlock?  Do you see what scrolls by above the
text you took a picture of (probably a "task hung" message?).

Does this happen reliably?  Does a previous kernel work ok?

-- 
Jesse Barnes, Intel Open Source Technology Center
