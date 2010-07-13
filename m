Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755175Ab0GMBkr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 21:40:47 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:59790 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116Ab0GMBkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 21:40:46 -0400
Subject: Re: 2.6.33.5 rt23: machine lockup (nfs/autofs related?)
From: john stultz <johnstul@us.ibm.com>
To: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        rt-users <linux-rt-users@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, Nick Piggin <npiggin@suse.de>
In-Reply-To: <1278983426.6489.57.camel@localhost.localdomain>
References: <1278609590.7527.11.camel@localhost.localdomain>
	 <1278628386.3008.11.camel@localhost.localdomain>
	 <1278629044.12059.6.camel@localhost.localdomain>
	 <1278630050.3008.18.camel@localhost.localdomain>
	 <1278702134.5102.9.camel@localhost.localdomain>
	 <1278705254.2349.14.camel@localhost.localdomain>
	 <1278713600.7122.22.camel@localhost.localdomain>
	 <1278716222.2349.20.camel@localhost.localdomain>
	 <1278977858.6489.52.camel@localhost.localdomain>
	 <1278978834.2404.12.camel@localhost.localdomain>
	 <1278983426.6489.57.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 12 Jul 2010 18:40:31 -0700
Message-ID: <1278985231.2404.60.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-07-12 at 18:10 -0700, Fernando Lopez-Lezcano wrote:
> On Mon, 2010-07-12 at 16:53 -0700, john stultz wrote:
> > 
> > Hrm. Ok.. I think the line 2100 above gives us a hint: (aparent == anon)
> > So if that were the case, we would have already locked aparent and that
> > would explain the blowup.
> > 
> > How does it do with the following change?
> 
> Ok, you are on to something. The machine did not crash hard!
> But the serial console printed this:

Sigh. Its never easy, is it? :)


> --------
> BUG: unable to handle kernel NULL pointer dereference at 0000008c
> IP: [<c045e50a>] rt_spin_lock_fastunlock.clone.2+0x6/0x3e
...
> Pid: 2855, comm: nautilus Not tainted
> 2.6.33.6-147.rt23.3.fc12.ccrma.i686.rt #3 P5K/EPU/P5K/EPU
> EIP: 0060:[<c045e50a>] EFLAGS: 00210246 CPU: 0
> EIP is at rt_spin_lock_fastunlock.clone.2+0x6/0x3e
> EAX: 00000078 EBX: ef45393c ECX: 00000000 EDX: 00000078
> ESI: ef716edc EDI: 00000000 EBP: f1977c8c ESP: f1977c88
>  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068 preempt:00000000
> Process nautilus (pid: 2855, ti=f1976000 task=f2347130 task.ti=f1976000)
> Stack:
>  ef45393c f1977c94 c0781206 f1977cc8 c04d842e 00000000 ef703e54 faadd5bc
> <0> f1977cdc 126bc87a ef703ddc 00000000 ef45393c ef716edc ef6f5494
> faafdc6c
> <0> f1977df8 faad9041 c3604b5c faafdc6c ef452bfc 00007e7f f5eb41e8
> 00000007
> Call Trace:
>  [<c0781206>] ? rt_spin_unlock+0x8/0xa
>  [<c04d842e>] ? d_materialise_unique+0x210/0x2aa

Can you gdb list *0xc04d842e ?

Thanks again for all the testing here! Its really appreciated!
-john

