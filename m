Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752714Ab1GYTFi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 15:05:38 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46639 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751666Ab1GYTFf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 15:05:35 -0400
Date: Mon, 25 Jul 2011 21:04:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaud Lacombe <lacombar@gmail.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] core/locking changes for v3.1
Message-ID: <20110725190444.GA8302@elte.hu>
References: <20110722125236.GA24832@elte.hu>
 <CACqU3MUW81UmBK7qBQCZRqzfosrukYM9=o0EZP_DvSjgywfK8g@mail.gmail.com>
 <1311588599.2617.56.camel@laptop>
 <CA+55aFwxqVXb0cFrkgdrDH4J_aF9J7iw8i6ypAda2HiAyeFYpw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+55aFwxqVXb0cFrkgdrDH4J_aF9J7iw8i6ypAda2HiAyeFYpw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Mon, Jul 25, 2011 at 3:09 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> >
> > Argh, I really need -Werror to even see warnings, compiler output just
> > flies by waaaaaay too fast.
> 
> Do what I do:
> 
>   make -j32 > ../makes
> 
> that way the only thing you see is the warnings (and the final link report).
> 
> That pattern was one reason why I wanted me default compile to be 
> warning-clean. Of course, then gcc started adding more warnings, 
> and it's not clean any more ("warning: statement with no effect" 
> from the fact that we just define many functions to '(0)' when they 
> are disabled) but my current personal compile config only gets four 
> warnings.
> 
> I realize there are *many* more warnings once you start enabling 
> more special code - as usual, the core code tends to be better 
> quality, and the further away from that base you get, the worse 
> things get.
> 
> But it would definitely be good if most kernel developers did the 
> above. Do it for just your personal config - at least you'll see 
> the warnings in code you write (because presumably your personal 
> config will have that code enabled ;)

Here is what i see on 'make defconfig' (which enables common core and 
common drivers):

sound/pci/hda/patch_sigmatel.c: In function ‘stac92xx_init’:
sound/pci/hda/patch_sigmatel.c:4385:3: warning: statement with no 
effect [-Wunused-value]
sound/pci/hda/patch_sigmatel.c: In function ‘stac92xx_resume’:
sound/pci/hda/patch_sigmatel.c:4925:3: warning: statement with no 
effect [-Wunused-value]
sound/pci/hda/patch_realtek.c: In function ‘alc_init’:
sound/pci/hda/patch_realtek.c:4176:2: warning: statement with no 
effect [-Wunused-value]
sound/pci/hda/patch_realtek.c: In function ‘alc_resume’:
sound/pci/hda/patch_realtek.c:4558:2: warning: statement with no 
effect [-Wunused-value]
sound/pci/hda/patch_realtek.c: In function ‘alc269_resume’:
sound/pci/hda/patch_realtek.c:14878:2: warning: statement with no 
effect [-Wunused-value]
net/sched/sch_generic.c: In function ‘dev_graft_qdisc’:
net/sched/sch_generic.c:678:2: warning: the comparison will always 
evaluate as ‘true’ for the address of ‘noop_qdisc’ will never be NULL 
[-Waddress]
net/netfilter/nf_conntrack_core.c: In function ‘nf_conntrack_init’:
net/netfilter/nf_conntrack_core.c:1579:3: warning: the comparison 
will always evaluate as ‘true’ for the address of 
‘nf_conntrack_attach’ will never be NULL [-Waddress]
net/netfilter/nf_conntrack_core.c:1580:3: warning: the comparison 
will always evaluate as ‘true’ for the address of ‘destroy_conntrack’ 
will never be NULL [-Waddress]
sound/pci/hda/hda_codec.c: In function 
‘snd_hda_mixer_amp_switch_put’:
sound/pci/hda/hda_codec.c:2320:2: warning: statement with no effect 
[-Wunused-value]
net/netfilter/nf_conntrack_proto.c: In function 
‘nf_conntrack_l3proto_unregister’:
net/netfilter/nf_conntrack_proto.c:210:2: warning: the comparison 
will always evaluate as ‘true’ for the address of 
‘nf_conntrack_l3proto_generic’ will never be NULL [-Waddress]
net/netfilter/nf_conntrack_proto.c: In function 
‘nf_conntrack_l4proto_unregister’:
net/netfilter/nf_conntrack_proto.c:345:2: warning: the comparison 
will always evaluate as ‘true’ for the address of 
‘nf_conntrack_l4proto_generic’ will never be NULL [-Waddress]
net/netfilter/nf_conntrack_proto.c: In function 
‘nf_conntrack_proto_init’:
net/netfilter/nf_conntrack_proto.c:370:3: warning: the comparison 
will always evaluate as ‘true’ for the address of 
‘nf_conntrack_l3proto_generic’ will never be NULL [-Waddress]
drivers/md/dm.c: In function ‘split_bvec’:
drivers/md/dm.c:1052:3: warning: statement with no effect 
[-Wunused-value]
drivers/md/dm.c: In function ‘clone_bio’:
drivers/md/dm.c:1079:3: warning: statement with no effect 
[-Wunused-value]
drivers/md/dm-table.c: In function ‘dm_table_set_integrity’:
drivers/md/dm-table.c:1193:2: warning: statement with no effect 
[-Wunused-value]
net/ipv4/netfilter/nf_nat_standalone.c: In function 
‘nf_nat_standalone_init’:
net/ipv4/netfilter/nf_nat_standalone.c:287:2: warning: the comparison 
will always evaluate as ‘true’ for the address of 
‘nat_decode_session’ will never be NULL [-Waddress]
net/ipv4/netfilter/nf_nat_core.c: In function 
‘nf_nat_protocol_unregister’:
net/ipv4/netfilter/nf_nat_core.c:528:2: warning: the comparison will 
always evaluate as ‘true’ for the address of 
‘nf_nat_unknown_protocol’ will never be NULL [-Waddress]
net/ipv4/netfilter/nf_nat_core.c: In function ‘nf_nat_init’:
net/ipv4/netfilter/nf_nat_core.c:739:3: warning: the comparison will 
always evaluate as ‘true’ for the address of 
‘nf_nat_unknown_protocol’ will never be NULL [-Waddress]
net/ipv4/netfilter/nf_nat_core.c:740:2: warning: the comparison will 
always evaluate as ‘true’ for the address of ‘nf_nat_protocol_tcp’ 
will never be NULL [-Waddress]
net/ipv4/netfilter/nf_nat_core.c:741:2: warning: the comparison will 
always evaluate as ‘true’ for the address of ‘nf_nat_protocol_udp’ 
will never be NULL [-Waddress]
net/ipv4/netfilter/nf_nat_core.c:742:2: warning: the comparison will 
always evaluate as ‘true’ for the address of ‘nf_nat_protocol_icmp’ 
will never be NULL [-Waddress]
net/ipv4/netfilter/nf_nat_core.c:751:2: warning: the comparison will 
always evaluate as ‘true’ for the address of ‘nf_nat_seq_adjust’ will 
never be NULL [-Waddress]
net/ipv4/netfilter/nf_nat_core.c:753:2: warning: the comparison will 
always evaluate as ‘true’ for the address of 
‘nfnetlink_parse_nat_setup’ will never be NULL [-Waddress]
net/ipv4/netfilter/nf_nat_core.c:756:2: warning: the comparison will 
always evaluate as ‘true’ for the address of ‘nf_nat_get_offset’ will 
never be NULL [-Waddress]
net/ipv4/netfilter/nf_nat_ftp.c: In function ‘nf_nat_ftp_init’:
net/ipv4/netfilter/nf_nat_ftp.c:123:2: warning: the comparison will 
always evaluate as ‘true’ for the address of ‘nf_nat_ftp’ will never 
be NULL [-Waddress]
net/ipv4/netfilter/nf_nat_irc.c: In function ‘nf_nat_irc_init’:
net/ipv4/netfilter/nf_nat_irc.c:85:2: warning: the comparison will 
always evaluate as ‘true’ for the address of ‘help’ will never be 
NULL [-Waddress]
In file included from drivers/usb/host/ohci-hcd.c:101:0:
drivers/usb/host/ohci-dbg.c: In function ‘fill_registers_buffer’:
drivers/usb/host/ohci-dbg.c:642:2: warning: the comparison will 
always evaluate as ‘true’ for the address of ‘next’ will never be 
NULL [-Waddress]
drivers/usb/host/ohci-dbg.c:661:3: warning: the comparison will 
always evaluate as ‘true’ for the address of ‘next’ will never be 
NULL [-Waddress]
net/ipv4/netfilter/nf_nat_sip.c: In function ‘nf_nat_sip_init’:
net/ipv4/netfilter/nf_nat_sip.c:550:2: warning: the comparison will 
always evaluate as ‘true’ for the address of ‘ip_nat_sip’ will never 
be NULL [-Waddress]
net/ipv4/netfilter/nf_nat_sip.c:551:2: warning: the comparison will 
always evaluate as ‘true’ for the address of ‘ip_nat_sip_seq_adjust’ 
will never be NULL [-Waddress]
net/ipv4/netfilter/nf_nat_sip.c:552:2: warning: the comparison will 
always evaluate as ‘true’ for the address of ‘ip_nat_sip_expect’ will 
never be NULL [-Waddress]
net/ipv4/netfilter/nf_nat_sip.c:553:2: warning: the comparison will 
always evaluate as ‘true’ for the address of ‘ip_nat_sdp_addr’ will 
never be NULL [-Waddress]
net/ipv4/netfilter/nf_nat_sip.c:554:2: warning: the comparison will 
always evaluate as ‘true’ for the address of ‘ip_nat_sdp_port’ will 
never be NULL [-Waddress]
net/ipv4/netfilter/nf_nat_sip.c:555:2: warning: the comparison will 
always evaluate as ‘true’ for the address of ‘ip_nat_sdp_session’ 
will never be NULL [-Waddress]
net/ipv4/netfilter/nf_nat_sip.c:556:2: warning: the comparison will 
always evaluate as ‘true’ for the address of ‘ip_nat_sdp_media’ will 
never be NULL [-Waddress]
Setup is 15260 bytes (padded to 15360 bytes).
System is 4654 kB
CRC 43bdb86

Not pretty :-/

Thanks,

	Ingo
