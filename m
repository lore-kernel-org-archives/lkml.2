Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755222Ab2KITpV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 14:45:21 -0500
Received: from nm30-vm0.access.bullet.mail.mud.yahoo.com ([66.94.237.86]:24664
	"EHLO nm30-vm0.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753311Ab2KITpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 14:45:20 -0500
X-Greylist: delayed 384 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Nov 2012 14:45:19 EST
X-Yahoo-Newman-Id: 159691.27623.bm@smtp110.sbc.mail.mud.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: pSYcKmcVM1k7F4qN7akitru3kPIce15cTmlm16h.YM84BAf
 DMQsGN02O.1mtGKWvqtrTtWFq3bPcwkxC02QzX5DnEmTw4wJA47UP6_bJXGw
 BnsBVpywlzO.Wtq1wm1YJ.RtnlRZYEp9jkn.jw5I4q4fH.05yTjJ5JTkJxSW
 DkhRDj9PmqdNFkE5Q81oYzp79ki7VSJEHIZ7sLqRAbYaLefYZWaYTQxDTaWs
 gPNKYAyy_t0CVXd1rCP.4898y__uSHR.uHoa4qLQLJ5DNgC_RoG.N3BkLAWR
 aQJWQektn7OdH0f7cW75lb0K9Hj30KZK0XZgxJeGCyqTEEFMZyDCzjAaR7gN
 91_jSFqkaDBrGp5p6HICYANGwoQnJNWLqhw9rKt171YHgq6Z4kkg__rWSdRP
 q8_lq20Tmm_4j4BDdvkblSW9IahLH8b9s1fdw_4rORWaUTagXwNWwjW537SB
 COkyAqio92LXIVjyh1THF1NoScToeZApnyLG1eKcK4X7m2pTZtOTc8B4hbd.
 1wKbzCO0XIdnevUgLUzEjA0vtNhRRXDmtoo3ZSWigxBsK3FMmv3Tmf1CHIOU
 NuXQOYVIv3rl0kIKjhTl744H_vr.2ON8dBwY-
X-Yahoo-SMTP: x3UJDw2swBBmiVP7941KaiyaoilgwM.0jf7QxQtKIw--
Message-ID: <509D5BCD.3010901@pacbell.net>
Date: Fri, 09 Nov 2012 11:38:53 -0800
From: Richard <richjunk@pacbell.net>
Reply-To: richjunk@pacbell.net
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120919 Thunderbird/15.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: kernel 3.6.5 and 3.6.6 GPF when use CONFIG_USB_SERIAL_KEYSPAN_USA49W
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On my Gentoo system using kernel.org kernel sources, 3.6.5 and 3.6.6, I
receive a "general protection fault" (GPF) when a program tries to
access my Keyspan 4-port serial to usb adapter using the
USB_SERIAL_KEYSPAN_USA49W driver moddule.  This GPF does not occur when
using kernel versions less than 3.6.5.

The GPF occurs when running C or Python based programs as well as
running minicom.

Below is part of /var/log/messages that shows the GPF when I tried to
run whozzcalling.py  -- a script I wrote that communicates with a serial
device.  It has worked through years of kernel upgrades.

If I can provide any more information, please ask.

Please CC my e-mail address with any replies, I do not subscribe to the
linux kernel list:   richjunk@pacbell.net

Richard



Nov  7 18:57:43 runner kernel: general protection fault: 0000 [#1] SMP
Nov  7 18:57:43 runner kernel: Modules linked in: xt_recent xt_tcpudp
xt_LOG xt_limit xt_state ipt_MASQUERADE iptable_nat iptable_filter
nf_nat_ftp nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack_ftp
nf_conntrack ip_tables x_tables ipv6 snd_pcm_oss snd_mixer_oss
hid_generic usbhid hid usblp keyspan usbserial snd_hda_codec_hdmi sr_mod
cdrom sg uhci_hcd coretemp crc32c_intel ghash_clmulni_intel aesni_intel
snd_hda_codec_realtek xhci_hcd ehci_hcd ablk_helper cryptd aes_x86_64
usbcore sky2 usb_common aes_generic snd_hda_intel snd_hda_codec i2c_i801
snd_pcm snd_timer snd soundcore snd_page_alloc pcspkr hwmon [last
unloaded: asus_atk0110]
Nov  7 18:57:43 runner kernel: CPU 2
Nov  7 18:57:43 runner kernel: Pid: 4150, comm: whozzcalling-ge Not
tainted 3.6.6-rr01 #1 System manufacturer System Product Name/P6X58D PREMIUM
Nov  7 18:57:43 runner kernel: RIP: 0010:[<ffffffffa0176a4c>]
[<ffffffffa0176a4c>] keyspan_open+0x11c/0x190 [keyspan]
Nov  7 18:57:43 runner kernel: RSP: 0018:ffff880625619a68  EFLAGS: 00010246
Nov  7 18:57:43 runner kernel: RAX: 0000000000000000 RBX:
ffff8806256b9a00 RCX: 0000000000000000
Nov  7 18:57:43 runner kernel: RDX: 0000000000000000 RSI:
0000000022e95810 RDI: 0000000000002580
Nov  7 18:57:43 runner kernel: RBP: ffff880625619ab8 R08:
0000000000000000 R09: 0000000000000000
Nov  7 18:57:43 runner kernel: R10: ffff880622fb49c0 R11:
0000000000000000 R12: 0000000000000cbd
Nov  7 18:57:45 runner kernel: R13: ffff880623d4b000 R14:
0000000000002580 R15: ffff880620c06000
Nov  7 18:57:45 runner kernel: FS:  00007f047f6c3700(0000)
GS:ffff88063fc40000(0000) knlGS:0000000000000000
Nov  7 18:57:45 runner kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
0000000080050033
Nov  7 18:57:45 runner kernel: CR2: 00007f047f6f5000 CR3:
000000061fe58000 CR4: 00000000000007e0
Nov  7 18:57:45 runner kernel: DR0: 0000000000000000 DR1:
0000000000000000 DR2: 0000000000000000
Nov  7 18:57:45 runner kernel: DR3: 0000000000000000 DR6:
00000000ffff0ff0 DR7: 0000000000000400
Nov  7 18:57:45 runner kernel: Process whozzcalling-ge (pid: 4150,
threadinfo ffff880625618000, task ffff880625711990)
Nov  7 18:57:45 runner kernel: Stack:
Nov  7 18:57:45 runner kernel: ffff880625680a00 ffff880620c06000
0000880620c064a8 ffff880622fb49c0
Nov  7 18:57:45 runner kernel: ffff880625680a00 ffff8806218671e8
ffff880623d4b008 ffff880620c06000
Nov  7 18:57:45 runner kernel: ffff880621867180 ffff880623d4b000
ffff880625619b08 ffffffffa0158645
Nov  7 18:57:45 runner kernel: Call Trace:
Nov  7 18:57:45 runner kernel: [<ffffffffa0158645>]
serial_activate+0x75/0xa0 [usbserial]
Nov  7 18:57:45 runner kernel: [<ffffffff8129b027>] tty_port_open+0x87/0xd0
Nov  7 18:57:45 runner kernel: [<ffffffffa0158c2a>]
serial_open+0x3a/0x70 [usbserial]
Nov  7 18:57:45 runner kernel: [<ffffffff8129315c>] tty_open+0x29c/0x600
Nov  7 18:57:45 runner kernel: [<ffffffff812d51a4>] ?
kobj_lookup+0x104/0x160
Nov  7 18:57:45 runner kernel: [<ffffffff810dfbd0>] chrdev_open+0xa0/0x180
Nov  7 18:57:45 runner kernel: [<ffffffff810dfb30>] ? cdev_put+0x30/0x30
Nov  7 18:57:45 runner kernel: [<ffffffff810da106>]
do_dentry_open.clone.18+0x206/0x280
Nov  7 18:57:45 runner kernel: [<ffffffff810da19d>] finish_open+0x1d/0x30
Nov  7 18:57:45 runner kernel: [<ffffffff810ea44e>] do_last+0x76e/0xe30
Nov  7 18:57:45 runner kernel: [<ffffffff810e723c>] ?
link_path_walk+0x8c/0x9a0
Nov  7 18:57:45 runner kernel: [<ffffffff810a5adf>] ?
release_pages+0x1bf/0x210
Nov  7 18:57:45 runner kernel: [<ffffffff810eabbe>] path_openat+0xae/0x4e0
Nov  7 18:57:45 runner kernel: [<ffffffff810b750f>] ?
tlb_flush_mmu+0x5f/0xa0
Nov  7 18:57:45 runner kernel: [<ffffffff810eb344>] do_filp_open+0x44/0xa0
Nov  7 18:57:45 runner kernel: [<ffffffff810f6ea7>] ? alloc_fd+0x47/0x130
Nov  7 18:57:45 runner kernel: [<ffffffff810dafb5>] do_sys_open+0x105/0x1f0
Nov  7 18:57:45 runner kernel: [<ffffffff810db0bc>] sys_open+0x1c/0x20
Nov  7 18:57:45 runner kernel: [<ffffffff813ce562>]
system_call_fastpath+0x16/0x1b
Nov  7 18:57:45 runner kernel: Code: 08 e8 b9 16 12 e1 41 89 c6 85 c0 78
2d 44 0f b6 4d c7 0f b6 45 c6 4c 8b 55 c8 41 29 c1 45 31 c0 31 c9 31 d2
41 8b 72 68 44 89 f7 <41> ff 52 60 85 c0 75 07 44 89 b3 88 01 00 00 44
89 e0 c1 e8 1f
Nov  7 18:57:45 runner kernel: RIP  [<ffffffffa0176a4c>]
keyspan_open+0x11c/0x190 [keyspan]
Nov  7 18:57:45 runner kernel: RSP <ffff880625619a68>
Nov  7 18:57:45 runner kernel: ---[ end trace e474011534926a5c ]---
