Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752622Ab2GRF1H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 01:27:07 -0400
Received: from mailout05.t-online.de ([194.25.134.82]:41987 "EHLO
	mailout05.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826Ab2GRF1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 01:27:00 -0400
Message-ID: <5006491D.8070004@t-online.de>
Date: Wed, 18 Jul 2012 07:26:53 +0200
From: Knut Petersen <Knut_Petersen@t-online.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:13.0) Gecko/20120601 Thunderbird/13.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: reiserfs-devel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [Bug 3.4.5] reiserfs: mutex_destroy called with locked mutex
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-ID: VrqQQiZp8h2ZPj-oEuHRj-MRYUsc1do-lh+1kgDpnWaKkp21JSoegZ560-aHSBig51
X-TOI-MSGID: 89cca4b2-2f88-4d55-b73a-7ab99dbb66d9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I hit the following problem during a heavy compile job on kernel 3.4.5:

Jul 17 20:29:59 golem kernel: [27408.140718] ------------[ cut here ]------------
Jul 17 20:29:59 golem kernel: [27408.140739] WARNING: at kernel/mutex-debug.c:106 mutex_destroy+0x35/0x3f()
Jul 17 20:29:59 golem kernel: [27408.140748] Hardware name:
Jul 17 20:29:59 golem kernel: [27408.140753] Modules linked in: ipt_MASQUERADE xt_pkttype xt_TCPMSS xt_tcpudp xt_LOG xt_limit iptable_nat nf_nat pppoe pppox af_packet ppp_generic s
lhc ir_kbd_i2c snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_raw xt_NOTRACK ipt_REJECT iptable_raw iptable_filter ip6table_
mangle nf_conntrack_netbios_ns nf_conntrack_broadcast nf_conntrack_ipv4 nf_defrag_ipv4 ip_tables xt_conntrack nf_conntrack ip6table_filter ip6_tables x_tables ipv6 isl6421 ir_lirc_
codec cx24116 lirc_dev ir_mce_kbd_decoder ir_sanyo_decoder cx88_dvb ir_sony_decoder ir_jvc_decoder ir_rc6_decoder videobuf_dvb snd_hda_codec_realtek dvb_core ir_rc5_decoder ir_nec_
decoder snd_hda_intel rc_hauppauge snd_hda_codec tuner snd_rme96 snd_hwdep snd_pcm cx8800 cx8802 cx88xx snd_timer snd rc_core tveeprom v4l2_common soundcore videodev btcx_risc vide
obuf_dma_sg videobuf_core snd_page_alloc
Jul 17 20:29:59 golem kernel: [27408.140933] Pid: 17424, comm: mkdir Not tainted 3.4.5-main #49
Jul 17 20:29:59 golem kernel: [27408.140940] Call Trace:
Jul 17 20:29:59 golem kernel: [27408.140950]  [<c01218bb>] ? console_unlock+0x1bc/0x1e2
Jul 17 20:29:59 golem kernel: [27408.140960]  [<c0120dfc>] warn_slowpath_common+0x68/0x7d
Jul 17 20:29:59 golem kernel: [27408.140969]  [<c01505a5>] ? mutex_destroy+0x35/0x3f
Jul 17 20:29:59 golem kernel: [27408.140978]  [<c0120e25>] warn_slowpath_null+0x14/0x18
Jul 17 20:29:59 golem kernel: [27408.140987]  [<c01505a5>] mutex_destroy+0x35/0x3f
Jul 17 20:29:59 golem kernel: [27408.140998]  [<c01cad96>] lockdep_annotate_inode_mutex_key+0x3a/0x69
Jul 17 20:29:59 golem kernel: [27408.141008]  [<c01cadd6>] unlock_new_inode+0x11/0x55
Jul 17 20:29:59 golem kernel: [27408.141018]  [<c020914c>] reiserfs_mkdir+0x274/0x29b
Jul 17 20:29:59 golem kernel: [27408.141030]  [<c01c153c>] vfs_mkdir+0x8f/0xdd
Jul 17 20:29:59 golem kernel: [27408.141039]  [<c029a9a2>] ? apparmor_path_mkdir+0x1b/0x1d
Jul 17 20:29:59 golem kernel: [27408.141049]  [<c01c388b>] sys_mkdirat+0x76/0xa9
Jul 17 20:29:59 golem kernel: [27408.141058]  [<c01c38d5>] sys_mkdir+0x17/0x19
Jul 17 20:29:59 golem kernel: [27408.141069]  [<c049f1dd>] syscall_call+0x7/0xb
Jul 17 20:29:59 golem kernel: [27408.141077] ---[ end trace ea73962172137cb3 ]---

cu,
  Knut

