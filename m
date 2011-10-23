Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752239Ab1JWWH7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 18:07:59 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:56253 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752023Ab1JWWH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 18:07:58 -0400
X-Sasl-enc: PoKgCY43Rnr7pKmp6RbLNf6GHtmUythb54WYa8uo67+d 1319407677
Date: Mon, 24 Oct 2011 00:07:31 +0200
From: Greg KH <greg@kroah.com>
To: Ruben Kerkhof <ruben@rubenkerkhof.com>
Cc: linux-kernel@vger.kernel.org, seto.hidetoshi@jp.fujitsu.com,
        Peter Zijlstra <peterz@infradead.org>,
        MINOURA Makoto <minoura@valinux.co.jp>, Ingo Molnar <mingo@elte.hu>,
        stable@kernel.org,
        =?iso-8859-1?Q?Herv=E9?= Commowick <hcommowick@exosec.fr>,
        john stultz <johnstul@us.ibm.com>, Rand@jasper.es,
        Andrew Morton <akpm@linux-foundation.org>, Willy Tarreau <w@1wt.eu>,
        Faidon Liambotis <paravoid@debian.org>
Subject: Re: [stable] 2.6.32.21 - uptime related crashes?
Message-ID: <20111023220731.GB402@kroah.com>
References: <1310752795.2945.4.camel@work-vm>
 <20110721072256.GE9216@elte.hu>
 <1311251098.29152.130.camel@twins>
 <20110721125008.GF11246@pcnci.linuxbox.cz>
 <1311252799.29152.147.camel@twins>
 <20110721184524.GB381@elte.hu>
 <20110825185616.GA17078@faidon.noc.grnet.gr>
 <20110830223829.GB17450@kroah.com>
 <20110904232657.GC6749@tty.gr>
 <CAPed3OHzO5usHfyeD_rK8dDhcGakZF+ByzEyZZb_Tdh3U00vOg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPed3OHzO5usHfyeD_rK8dDhcGakZF+ByzEyZZb_Tdh3U00vOg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 23, 2011 at 08:31:32PM +0200, Ruben Kerkhof wrote:
> On Mon, Sep 5, 2011 at 01:26, Faidon Liambotis <paravoid@debian.org> wrote:
> > On Tue, Aug 30, 2011 at 03:38:29PM -0700, Greg KH wrote:
> >> On Thu, Aug 25, 2011 at 09:56:16PM +0300, Faidon Liambotis wrote:
> >> > On Thu, Jul 21, 2011 at 08:45:25PM +0200, Ingo Molnar wrote:
> >> > > * Peter Zijlstra <peterz@infradead.org> wrote:
> >> > >
> >> > > > On Thu, 2011-07-21 at 14:50 +0200, Nikola Ciprich wrote:
> >> > > > > thanks for the patch! I'll put this on our testing boxes...
> >> > > >
> >> > > > With a patch that frobs the starting value close to overflowing I hope,
> >> > > > otherwise we'll not hear from you in like 7 months ;-)
> >> > > >
> >> > > > > Are You going to push this upstream so we can ask Greg to push this to
> >> > > > > -stable?
> >> > > >
> >> > > > Yeah, I think we want to commit this with a -stable tag, Ingo?
> >> > >
> >> > > yeah - and we also want a Reported-by tag and an explanation of how
> >> > > it can crash and why it matters in practice. I can then stick it into
> >> > > the urgent branch for Linus. (probably will only hit upstream in the
> >> > > merge window though.)
> >> >
> >> > Has this been pushed or has the problem been solved somehow? Time is
> >> > against us on this bug as more boxes will crash as they reach 200 days
> >> > of uptime...
> >> >
> >> > In any case, feel free to use me as a Reported-by, my full report of the
> >> > problem being <20110430173905.GA25641@tty.gr>.
> >> >
> >> > FWIW and if I understand correctly, my symptoms were caused by *two*
> >> > different bugs:
> >> > a) the 54 bits wraparound at 208 days that Peter fixed above,
> >> > b) a kernel crash at ~215 days related to RT tasks, fixed by
> >> > 305e6835e05513406fa12820e40e4a8ecb63743c (already in -stable).
> >>
> >> So, what do I do here as part of the .32-longterm kernel?  Is there a
> >> fix that is in Linus's tree that I need to apply here?
> >>
> >> confused,
> >
> > Is this even pushed upstream? I checked Linus' tree and the proposed
> > patch is *not* merged there. I'm not really sure if it was fixed some
> > other way, though. I thought this was intended to be an "urgent" fix or
> > something?
> >
> > Regards,
> > Faidon
> 
> I just had two crashes on two different machines, both with an uptime
> of 208 days.
> Both were 5520's running 2.6.34.8, but with a CONFIG_HZ of 1000
> 
> 2011-10-23T16:49:18.618029+02:00 phy001 kernel: BUG: soft lockup -
> CPU#0 stuck for 17163091968s! [qemu-kvm:16949]
> 2011-10-23T16:49:18.618054+02:00 phy001 kernel: Modules linked in:
> xt_limit ebt_log ebt_limit ebt_arp ebtable_filter ebtable_nat ebtables
> ufs nls_utf8 tun ipmi_devintf ipmi_si ipmi_msghandler bridge 8021q
> garp stp llc bonding xt_comment xt_recent ip6t_REJECT
> nf_conntrack_ipv6 ip6table_filter ip6_tables ipv6 kvm_intel kvm
> ioatdma i2c_i801 igb iTCO_wdt dca iTCO_vendor_support serio_raw
> i2c_core 3w_9xxx [last unloaded: scsi_wait_scan]
> 2011-10-23T16:49:18.618060+02:00 phy001 kernel: CPU 0
> 2011-10-23T16:49:18.618068+02:00 phy001 kernel: Modules linked in:
> xt_limit ebt_log ebt_limit ebt_arp ebtable_filter ebtable_nat ebtables
> ufs nls_utf8 tun ipmi_devintf ipmi_si ipmi_msghandler bridge 8021q
> garp stp llc bonding xt_comment xt_recent ip6t_REJECT
> nf_conntrack_ipv6 ip6table_filter ip6_tables ipv6 kvm_intel kvm
> ioatdma i2c_i801 igb iTCO_wdt dca iTCO_vendor_support serio_raw
> i2c_core 3w_9xxx [last unloaded: scsi_wait_scan]
> 2011-10-23T16:49:18.618072+02:00 phy001 kernel:
> 2011-10-23T16:49:18.618077+02:00 phy001 kernel: Pid: 16949, comm:
> qemu-kvm Tainted: G   M       2.6.34.8-68.local.fc13.x86_64 #1
> X8DTU/X8DTU
> 2011-10-23T16:49:18.618083+02:00 phy001 kernel: RIP:
> 0010:[<ffffffffa007f92f>]  [<ffffffffa007f92f>]
> kvm_arch_vcpu_ioctl_run+0x764/0xa74 [kvm]
> 2011-10-23T16:49:18.618086+02:00 phy001 kernel: RSP:
> 0018:ffff880bafa29d18  EFLAGS: 00000202
> 2011-10-23T16:49:18.618088+02:00 phy001 kernel: RAX: ffff880002000000
> RBX: ffff880bafa29dc8 RCX: ffff8805e45128a0
> 2011-10-23T16:49:18.618091+02:00 phy001 kernel: RDX: 000000000000cb80
> RSI: 0000000004b2a3a0 RDI: 000000000b630000
> 2011-10-23T16:49:18.618093+02:00 phy001 kernel: RBP: ffffffff8100a60e
> R08: 000000000000002b R09: 00000000760d0735
> 2011-10-23T16:49:18.618095+02:00 phy001 kernel: R10: 0000000000000000
> R11: 0000000000000000 R12: 0000000000000001
> 2011-10-23T16:49:18.618097+02:00 phy001 kernel: R13: ffff880bafa29cc8
> R14: ffffffffa007b536 R15: ffff880bafa29ca8
> 2011-10-23T16:49:18.618100+02:00 phy001 kernel: FS:
> 00007fe92cd38700(0000) GS:ffff880002000000(0000)
> knlGS:fffff880009b8000
> 2011-10-23T16:49:18.618102+02:00 phy001 kernel: CS:  0010 DS: 002b ES:
> 002b CR0: 0000000080050033
> 2011-10-23T16:49:18.618104+02:00 phy001 kernel: CR2: 00000000c1a00044
> CR3: 00000006b3f2e000 CR4: 00000000000026e0
> 2011-10-23T16:49:18.618107+02:00 phy001 kernel: DR0: 0000000000000000
> DR1: 0000000000000000 DR2: 0000000000000000
> 2011-10-23T16:49:18.618109+02:00 phy001 kernel: DR3: 0000000000000000
> DR6: 00000000ffff0ff0 DR7: 0000000000000400
> 2011-10-23T16:49:18.618112+02:00 phy001 kernel: Process qemu-kvm (pid:
> 16949, threadinfo ffff880bafa28000, task ffff880c242e0000)
> 2011-10-23T16:49:18.618114+02:00 phy001 kernel: Stack:
> 2011-10-23T16:49:18.618116+02:00 phy001 kernel: ffff88077b1a3ca8
> ffffffff81d3cf38 ffff8805e4513f00 ffff880c242e0000
> 2011-10-23T16:49:18.618119+02:00 phy001 kernel: <0> ffff880c242e0000
> ffff880bafa29fd8 ffff8805e4513ef8 0000000000015fd0
> 2011-10-23T16:49:18.618121+02:00 phy001 kernel: <0> 000000000000cb80
> ffff880c242e0000 ffff880bafa28000 ffff880ab43f4038
> 2011-10-23T16:49:18.618123+02:00 phy001 kernel: Call Trace:
> 2011-10-23T16:49:18.618126+02:00 phy001 kernel: [<ffffffffa006e5ba>] ?
> kvm_vcpu_ioctl+0xfd/0x56e [kvm]
> 2011-10-23T16:49:18.618129+02:00 phy001 kernel: [<ffffffff81011252>] ?
> __switch_to_xtra+0x121/0x141
> 2011-10-23T16:49:18.618131+02:00 phy001 kernel: [<ffffffff8111ad5f>] ?
> vfs_ioctl+0x32/0xa6
> 2011-10-23T16:49:18.618134+02:00 phy001 kernel: [<ffffffff8111b2d2>] ?
> do_vfs_ioctl+0x483/0x4c9
> 2011-10-23T16:49:18.618137+02:00 phy001 kernel: [<ffffffff8111b36e>] ?
> sys_ioctl+0x56/0x79
> 2011-10-23T16:49:18.618139+02:00 phy001 kernel: [<ffffffff81009c72>] ?
> system_call_fastpath+0x16/0x1b
> 2011-10-23T16:49:18.618142+02:00 phy001 kernel: Code: df ff 90 48 01
> 00 00 48 8b 55 90 65 48 8b 04 25 90 e8 00 00 f6 04 10 aa 74 05 e8 05
> 06 f9 e0 f0 41 80 0f 02 fb 66 0f 1f 44 00 00 <ff> 83 b0 00 00 00 48 8b
> b5 68 ff ff ff 83 66 14 ef 48 8b 3b 48
> 
> Can the necessary fix please be pushed upstream?

I agree, again, can someone please do this?

greg k-h
