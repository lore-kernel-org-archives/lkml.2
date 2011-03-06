Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753443Ab1CFO0c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 09:26:32 -0500
Received: from dion.org.ua ([193.104.35.153]:39951 "EHLO dion.org.ua"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752730Ab1CFO03 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 09:26:29 -0500
X-Greylist: delayed 1521 seconds by postgrey-1.27 at vger.kernel.org; Sun, 06 Mar 2011 09:26:28 EST
Date: Sun, 6 Mar 2011 16:01:04 +0200
From: Dmitry Nezhevenko <dion@inhex.net>
To: linux-kernel@vger.kernel.org
Subject: 2.6.38-rc7: Some strange soft-lockup
Message-ID: <20110306140104.GA7700@laptop.local>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="xHFwDpU9dbj6ez1V"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

I've got some strange soft lockup on my laptop using 2.6.38-rc7. Basically
every command that plays with processes freezes. For example "top" and
"pidof".

In this state I'm able to do some other stuff like browse web with FF.
However laptop don't detect power supply plug/unplug.

I'm attaching output of Alt-SysRq+W and Alt-SysRQ+L.

I don't know, what is this and how to reproduce it. So maybe it will help
somebody

-- 
WBR, Dmitry

--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="backtrace_cpu.txt"
Content-Transfer-Encoding: quoted-printable

Mar  6 15:55:49 laptop kernel: [11277.498368] SysRq : Show backtrace of all=
 active CPUs
Mar  6 15:55:49 laptop kernel: [11277.498377] sending NMI to all CPUs:
Mar  6 15:55:49 laptop kernel: [11277.498385] NMI backtrace for cpu 1
Mar  6 15:55:49 laptop kernel: [11277.498389] Modules linked in: nfs lockd =
fscache nfs_acl auth_rpcgss sunrpc tun xt_recent ipt_LOG ipt_REJECT xt_tcpu=
dp xt_state iptable_filter iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrac=
k nf_defrag_ipv4 ip_tables x_tables acpi_cpufreq mperf fuse coretemp loop a=
rc4 ecb snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_code=
c iwlagn snd_hwdep iwlcore snd_pcm asus_laptop snd_seq snd_timer snd_seq_de=
vice uvcvideo psmouse sparse_keymap joydev mac80211 pcspkr snd cfg80211 vid=
eodev ac soundcore tpm_tis tpm serio_raw snd_page_alloc tpm_bios battery ev=
dev processor rfkill sha256_generic cryptd aes_i586 aes_generic cbc dm_cryp=
t hid_microsoft usbhid hid dm_mod btrfs zlib_deflate crc32c libcrc32c reise=
rfs lzo ext3 jbd mbcache i915 drm_kms_helper drm i2c_algo_bit i2c_core sg s=
r_mod sd_mod cdrom crc_t10dif usb_storage uas uhci_hcd ahci libahci libata =
scsi_mod video thermal ehci_hcd thermal_sys button usbcore r8169 mii nls_ba=
se [last unloaded: scsi_wait_scan]
Mar  6 15:55:49 laptop kernel: [11277.498578]=20
Mar  6 15:55:49 laptop kernel: [11277.498581] Pid: 0, comm: kworker/0:0 Not=
 tainted 2.6.38-rc7 #1 ASUSTeK Computer Inc.         F6A                 /F=
6A      =20
Mar  6 15:55:49 laptop kernel: [11277.498588] EIP: 0060:[<c1154cce>] EFLAGS=
: 00000006 CPU: 1
Mar  6 15:55:49 laptop kernel: [11277.498595] EIP is at delay_tsc+0x24/0x9e
Mar  6 15:55:49 laptop kernel: [11277.498597] EAX: 615074a4 EBX: 001e32ab E=
CX: 00000800 EDX: 00000bb4
Mar  6 15:55:49 laptop kernel: [11277.498600] ESI: 00000001 EDI: 00000007 E=
BP: f4cb9ce0 ESP: f4cb9cd0
Mar  6 15:55:49 laptop kernel: [11277.498603]  DS: 007b ES: 007b FS: 00d8 G=
S: 00e0 SS: 0068
Mar  6 15:55:49 laptop kernel: [11277.498608] Process kworker/0:0 (pid: 0, =
ti=3Df4cb8000 task=3Df4cb0c80 task.ti=3Df4ca6000)
Mar  6 15:55:49 laptop kernel: [11277.498610] Stack:
Mar  6 15:55:49 laptop kernel: [11277.498612]  c1436b58 00000001 c1436b58 0=
0000007 f4cb9ce8 c1154c8b f4cb9cf4 c1017473
Mar  6 15:55:49 laptop kernel: [11277.498620]  0000006c f4cb9cfc c11b897c f=
4cb9d20 c11b8bd4 c1388da2 c13b60c2 c14b0501
Mar  6 15:55:49 laptop kernel: [11277.498629]  00000096 f3a8c0c0 00000026 0=
0000001 f4cb9d3c c11b8d62 f4cb9d01 f3a8c0c0
Mar  6 15:55:49 laptop kernel: [11277.498637] Call Trace:
Mar  6 15:55:49 laptop kernel: [11277.498642]  [<c1154c8b>] __const_udelay+=
0x1b/0x1d
Mar  6 15:55:49 laptop kernel: [11277.498647]  [<c1017473>] arch_trigger_al=
l_cpu_backtrace+0x51/0x66
Mar  6 15:55:49 laptop kernel: [11277.498653]  [<c11b897c>] sysrq_handle_sh=
owallcpus+0x8/0xa
Mar  6 15:55:49 laptop kernel: [11277.498657]  [<c11b8bd4>] __handle_sysrq+=
0x9b/0x110
Mar  6 15:55:49 laptop kernel: [11277.498661]  [<c11b8d62>] sysrq_filter+0x=
ee/0x13c
Mar  6 15:55:49 laptop kernel: [11277.498666]  [<c11e6c78>] input_pass_even=
t+0x86/0xb9
Mar  6 15:55:49 laptop kernel: [11277.498670]  [<c11b8c74>] ? sysrq_filter+=
0x0/0x13c
Mar  6 15:55:49 laptop kernel: [11277.498674]  [<c11e7dad>] input_handle_ev=
ent+0x427/0x430
Mar  6 15:55:49 laptop kernel: [11277.498679]  [<c11cb365>] ? add_timer_ran=
domness+0xda/0xf4
Mar  6 15:55:49 laptop kernel: [11277.498683]  [<c11e7e77>] input_event+0x4=
f/0x64
Mar  6 15:55:49 laptop kernel: [11277.498696]  [<f9af3329>] hidinput_hid_ev=
ent+0x276/0x2a1 [hid]
Mar  6 15:55:49 laptop kernel: [11277.498701]  [<f9b3f001>] ? ms_report_fix=
up+0x1/0x5a [hid_microsoft]
Mar  6 15:55:49 laptop kernel: [11277.498709]  [<f9aefea8>] hid_process_eve=
nt+0xc3/0xf2 [hid]
Mar  6 15:55:49 laptop kernel: [11277.498714]  [<f9b3f05a>] ? ms_event+0x0/=
0x87 [hid_microsoft]
Mar  6 15:55:49 laptop kernel: [11277.498720]  [<f9af0268>] hid_report_raw_=
event+0x391/0x39d [hid]
Mar  6 15:55:49 laptop kernel: [11277.498726]  [<c12a6b0d>] ? _raw_spin_unl=
ock_irqrestore+0x25/0x30
Mar  6 15:55:49 laptop kernel: [11277.498734]  [<f9af0411>] hid_input_repor=
t+0x19d/0x1b5 [hid]
Mar  6 15:55:49 laptop kernel: [11277.498742]  [<f9b2db65>] hid_irq_in+0x91=
/0x182 [usbhid]
Mar  6 15:55:49 laptop kernel: [11277.498760]  [<f8490836>] usb_hcd_givebac=
k_urb+0x63/0x94 [usbcore]
Mar  6 15:55:49 laptop kernel: [11277.498770]  [<f868f9f6>] ehci_urb_done+0=
x61/0x6e [ehci_hcd]
Mar  6 15:55:49 laptop kernel: [11277.498778]  [<f868fd48>] qh_completions+=
0x345/0x3c1 [ehci_hcd]
Mar  6 15:55:49 laptop kernel: [11277.498785]  [<f8691a25>] ehci_work+0x1e0=
/0x70d [ehci_hcd]
Mar  6 15:55:49 laptop kernel: [11277.498793]  [<f8693217>] ehci_irq+0x18e/=
0x1b4 [ehci_hcd]
Mar  6 15:55:49 laptop kernel: [11277.498797]  [<c12a6add>] ? _raw_spin_unl=
ock+0x1b/0x26
Mar  6 15:55:49 laptop kernel: [11277.498803]  [<c1054af4>] ? tick_handle_o=
neshot_broadcast+0xda/0xe2
Mar  6 15:55:49 laptop kernel: [11277.498819]  [<f849013d>] usb_hcd_irq+0x3=
2/0x6a [usbcore]
Mar  6 15:55:49 laptop kernel: [11277.498824]  [<c1074266>] handle_IRQ_even=
t+0x58/0x114
Mar  6 15:55:49 laptop kernel: [11277.498828]  [<c1075bd4>] handle_fasteoi_=
irq+0x7c/0xb3
Mar  6 15:55:49 laptop kernel: [11277.498831]  [<c1075b58>] ? handle_fasteo=
i_irq+0x0/0xb3
Mar  6 15:55:49 laptop kernel: [11277.498833]  <IRQ>=20
Mar  6 15:55:49 laptop kernel: [11277.498838]  [<c10040fd>] ? do_IRQ+0x37/0=
x8f
Mar  6 15:55:49 laptop kernel: [11277.498842]  [<c1003670>] ? common_interr=
upt+0x30/0x38
Mar  6 15:55:49 laptop kernel: [11277.498846]  [<c104007b>] ? block_all_sig=
nals+0x2c/0x54
Mar  6 15:55:49 laptop kernel: [11277.498856]  [<fa19bd01>] ? acpi_idle_ent=
er_bm+0x24c/0x288 [processor]
Mar  6 15:55:49 laptop kernel: [11277.498862]  [<c11f1f17>] ? cpuidle_idle_=
call+0xcd/0x14a
Mar  6 15:55:49 laptop kernel: [11277.498866]  [<c1002354>] ? cpu_idle+0x91=
/0xc1
Mar  6 15:55:49 laptop kernel: [11277.498870]  [<c12a24e1>] ? start_seconda=
ry+0x1bd/0x1c4
Mar  6 15:55:49 laptop kernel: [11277.498873] Code: e8 c8 ff ff ff 5d c3 55=
 89 e5 57 56 53 89 c3 83 ec 04 b8 01 00 00 00 e8 61 49 15 00 e8 98 58 00 00=
 89 c6 8d 76 00 0f ae e8 0f 31 <8d> 74 26 00 89 45 f0 8d 76 00 0f ae e8 0f =
31 8d 74 26 00 89 c7=20
Mar  6 15:55:49 laptop kernel: [11277.498917] Call Trace:
Mar  6 15:55:49 laptop kernel: [11277.498920]  [<c1154c8b>] __const_udelay+=
0x1b/0x1d
Mar  6 15:55:49 laptop kernel: [11277.498924]  [<c1017473>] arch_trigger_al=
l_cpu_backtrace+0x51/0x66
Mar  6 15:55:49 laptop kernel: [11277.498929]  [<c11b897c>] sysrq_handle_sh=
owallcpus+0x8/0xa
Mar  6 15:55:49 laptop kernel: [11277.498932]  [<c11b8bd4>] __handle_sysrq+=
0x9b/0x110
Mar  6 15:55:49 laptop kernel: [11277.498936]  [<c11b8d62>] sysrq_filter+0x=
ee/0x13c
Mar  6 15:55:49 laptop kernel: [11277.498940]  [<c11e6c78>] input_pass_even=
t+0x86/0xb9
Mar  6 15:55:49 laptop kernel: [11277.498944]  [<c11b8c74>] ? sysrq_filter+=
0x0/0x13c
Mar  6 15:55:49 laptop kernel: [11277.498948]  [<c11e7dad>] input_handle_ev=
ent+0x427/0x430
Mar  6 15:55:49 laptop kernel: [11277.498952]  [<c11cb365>] ? add_timer_ran=
domness+0xda/0xf4
Mar  6 15:55:49 laptop kernel: [11277.498956]  [<c11e7e77>] input_event+0x4=
f/0x64
Mar  6 15:55:49 laptop kernel: [11277.498966]  [<f9af3329>] hidinput_hid_ev=
ent+0x276/0x2a1 [hid]
Mar  6 15:55:49 laptop kernel: [11277.498971]  [<f9b3f001>] ? ms_report_fix=
up+0x1/0x5a [hid_microsoft]
Mar  6 15:55:49 laptop kernel: [11277.498978]  [<f9aefea8>] hid_process_eve=
nt+0xc3/0xf2 [hid]
Mar  6 15:55:49 laptop kernel: [11277.498983]  [<f9b3f05a>] ? ms_event+0x0/=
0x87 [hid_microsoft]
Mar  6 15:55:49 laptop kernel: [11277.498990]  [<f9af0268>] hid_report_raw_=
event+0x391/0x39d [hid]
Mar  6 15:55:49 laptop kernel: [11277.498994]  [<c12a6b0d>] ? _raw_spin_unl=
ock_irqrestore+0x25/0x30
Mar  6 15:55:49 laptop kernel: [11277.499002]  [<f9af0411>] hid_input_repor=
t+0x19d/0x1b5 [hid]
Mar  6 15:55:49 laptop kernel: [11277.499009]  [<f9b2db65>] hid_irq_in+0x91=
/0x182 [usbhid]
Mar  6 15:55:49 laptop kernel: [11277.499024]  [<f8490836>] usb_hcd_givebac=
k_urb+0x63/0x94 [usbcore]
Mar  6 15:55:49 laptop kernel: [11277.499034]  [<f868f9f6>] ehci_urb_done+0=
x61/0x6e [ehci_hcd]
Mar  6 15:55:49 laptop kernel: [11277.499041]  [<f868fd48>] qh_completions+=
0x345/0x3c1 [ehci_hcd]
Mar  6 15:55:49 laptop kernel: [11277.499049]  [<f8691a25>] ehci_work+0x1e0=
/0x70d [ehci_hcd]
Mar  6 15:55:49 laptop kernel: [11277.499056]  [<f8693217>] ehci_irq+0x18e/=
0x1b4 [ehci_hcd]
Mar  6 15:55:49 laptop kernel: [11277.499061]  [<c12a6add>] ? _raw_spin_unl=
ock+0x1b/0x26
Mar  6 15:55:49 laptop kernel: [11277.499065]  [<c1054af4>] ? tick_handle_o=
neshot_broadcast+0xda/0xe2
Mar  6 15:55:49 laptop kernel: [11277.499081]  [<f849013d>] usb_hcd_irq+0x3=
2/0x6a [usbcore]
Mar  6 15:55:49 laptop kernel: [11277.499085]  [<c1074266>] handle_IRQ_even=
t+0x58/0x114
Mar  6 15:55:49 laptop kernel: [11277.499089]  [<c1075bd4>] handle_fasteoi_=
irq+0x7c/0xb3
Mar  6 15:55:49 laptop kernel: [11277.499092]  [<c1075b58>] ? handle_fasteo=
i_irq+0x0/0xb3
Mar  6 15:55:49 laptop kernel: [11277.499094]  <IRQ>  [<c10040fd>] ? do_IRQ=
+0x37/0x8f
Mar  6 15:55:49 laptop kernel: [11277.499101]  [<c1003670>] ? common_interr=
upt+0x30/0x38
Mar  6 15:55:49 laptop kernel: [11277.499105]  [<c104007b>] ? block_all_sig=
nals+0x2c/0x54
Mar  6 15:55:49 laptop kernel: [11277.499114]  [<fa19bd01>] ? acpi_idle_ent=
er_bm+0x24c/0x288 [processor]
Mar  6 15:55:49 laptop kernel: [11277.499119]  [<c11f1f17>] ? cpuidle_idle_=
call+0xcd/0x14a
Mar  6 15:55:49 laptop kernel: [11277.499122]  [<c1002354>] ? cpu_idle+0x91=
/0xc1
Mar  6 15:55:49 laptop kernel: [11277.499126]  [<c12a24e1>] ? start_seconda=
ry+0x1bd/0x1c4
Mar  6 15:55:49 laptop kernel: [11277.499131] Pid: 0, comm: kworker/0:0 Not=
 tainted 2.6.38-rc7 #1
Mar  6 15:55:49 laptop kernel: [11277.499133] Call Trace:
Mar  6 15:55:49 laptop kernel: [11277.499136]  [<c1008b0a>] ? show_regs+0x1=
7/0x1a
Mar  6 15:55:49 laptop kernel: [11277.499141]  [<c12a8514>] ? arch_trigger_=
all_cpu_backtrace_handler+0x52/0x72
Mar  6 15:55:49 laptop kernel: [11277.499145]  [<c12a96e0>] ? notifier_call=
_chain+0x26/0x48
Mar  6 15:55:49 laptop kernel: [11277.499149]  [<c12a972a>] ? __atomic_noti=
fier_call_chain+0x28/0x38
Mar  6 15:55:49 laptop kernel: [11277.499154]  [<c12a9746>] ? atomic_notifi=
er_call_chain+0xc/0xe
Mar  6 15:55:49 laptop kernel: [11277.499157]  [<c12a9775>] ? notify_die+0x=
2d/0x2f
Mar  6 15:55:49 laptop kernel: [11277.499161]  [<c12a7b0b>] ? do_nmi+0x56/0=
x24b
Mar  6 15:55:49 laptop kernel: [11277.499165]  [<c12a7740>] ? nmi_stack_cor=
rect+0x2f/0x34
Mar  6 15:55:49 laptop kernel: [11277.499170]  [<c101007b>] ? mce_rdmsrl+0x=
ac/0xd4
Mar  6 15:55:49 laptop kernel: [11277.499173]  [<c1154cce>] ? delay_tsc+0x2=
4/0x9e
Mar  6 15:55:49 laptop kernel: [11277.499177]  [<c1154c8b>] ? __const_udela=
y+0x1b/0x1d
Mar  6 15:55:49 laptop kernel: [11277.499180]  [<c1017473>] ? arch_trigger_=
all_cpu_backtrace+0x51/0x66
Mar  6 15:55:49 laptop kernel: [11277.499185]  [<c11b897c>] ? sysrq_handle_=
showallcpus+0x8/0xa
Mar  6 15:55:49 laptop kernel: [11277.499189]  [<c11b8bd4>] ? __handle_sysr=
q+0x9b/0x110
Mar  6 15:55:49 laptop kernel: [11277.499193]  [<c11b8d62>] ? sysrq_filter+=
0xee/0x13c
Mar  6 15:55:49 laptop kernel: [11277.499196]  [<c11e6c78>] ? input_pass_ev=
ent+0x86/0xb9
Mar  6 15:55:49 laptop kernel: [11277.499200]  [<c11b8c74>] ? sysrq_filter+=
0x0/0x13c
Mar  6 15:55:49 laptop kernel: [11277.499204]  [<c11e7dad>] ? input_handle_=
event+0x427/0x430
Mar  6 15:55:49 laptop kernel: [11277.499208]  [<c11cb365>] ? add_timer_ran=
domness+0xda/0xf4
Mar  6 15:55:49 laptop kernel: [11277.499212]  [<c11e7e77>] ? input_event+0=
x4f/0x64
Mar  6 15:55:49 laptop kernel: [11277.499221]  [<f9af3329>] ? hidinput_hid_=
event+0x276/0x2a1 [hid]
Mar  6 15:55:49 laptop kernel: [11277.499226]  [<f9b3f001>] ? ms_report_fix=
up+0x1/0x5a [hid_microsoft]
Mar  6 15:55:49 laptop kernel: [11277.499234]  [<f9aefea8>] ? hid_process_e=
vent+0xc3/0xf2 [hid]
Mar  6 15:55:49 laptop kernel: [11277.499238]  [<f9b3f05a>] ? ms_event+0x0/=
0x87 [hid_microsoft]
Mar  6 15:55:49 laptop kernel: [11277.499245]  [<f9af0268>] ? hid_report_ra=
w_event+0x391/0x39d [hid]
Mar  6 15:55:49 laptop kernel: [11277.499249]  [<c12a6b0d>] ? _raw_spin_unl=
ock_irqrestore+0x25/0x30
Mar  6 15:55:49 laptop kernel: [11277.499257]  [<f9af0411>] ? hid_input_rep=
ort+0x19d/0x1b5 [hid]
Mar  6 15:55:49 laptop kernel: [11277.499263]  [<f9b2db65>] ? hid_irq_in+0x=
91/0x182 [usbhid]
Mar  6 15:55:49 laptop kernel: [11277.499279]  [<f8490836>] ? usb_hcd_giveb=
ack_urb+0x63/0x94 [usbcore]
Mar  6 15:55:49 laptop kernel: [11277.499289]  [<f868f9f6>] ? ehci_urb_done=
+0x61/0x6e [ehci_hcd]
Mar  6 15:55:49 laptop kernel: [11277.499297]  [<f868fd48>] ? qh_completion=
s+0x345/0x3c1 [ehci_hcd]
Mar  6 15:55:49 laptop kernel: [11277.499304]  [<f8691a25>] ? ehci_work+0x1=
e0/0x70d [ehci_hcd]
Mar  6 15:55:49 laptop kernel: [11277.499312]  [<f8693217>] ? ehci_irq+0x18=
e/0x1b4 [ehci_hcd]
Mar  6 15:55:49 laptop kernel: [11277.499317]  [<c12a6add>] ? _raw_spin_unl=
ock+0x1b/0x26
Mar  6 15:55:49 laptop kernel: [11277.499321]  [<c1054af4>] ? tick_handle_o=
neshot_broadcast+0xda/0xe2
Mar  6 15:55:49 laptop kernel: [11277.499337]  [<f849013d>] ? usb_hcd_irq+0=
x32/0x6a [usbcore]
Mar  6 15:55:49 laptop kernel: [11277.499341]  [<c1074266>] ? handle_IRQ_ev=
ent+0x58/0x114
Mar  6 15:55:49 laptop kernel: [11277.499345]  [<c1075bd4>] ? handle_fasteo=
i_irq+0x7c/0xb3
Mar  6 15:55:49 laptop kernel: [11277.499348]  [<c1075b58>] ? handle_fasteo=
i_irq+0x0/0xb3
Mar  6 15:55:49 laptop kernel: [11277.499350]  <IRQ>  [<c10040fd>] ? do_IRQ=
+0x37/0x8f
Mar  6 15:55:49 laptop kernel: [11277.499357]  [<c1003670>] ? common_interr=
upt+0x30/0x38
Mar  6 15:55:49 laptop kernel: [11277.499361]  [<c104007b>] ? block_all_sig=
nals+0x2c/0x54
Mar  6 15:55:49 laptop kernel: [11277.499370]  [<fa19bd01>] ? acpi_idle_ent=
er_bm+0x24c/0x288 [processor]
Mar  6 15:55:49 laptop kernel: [11277.499375]  [<c11f1f17>] ? cpuidle_idle_=
call+0xcd/0x14a
Mar  6 15:55:49 laptop kernel: [11277.499379]  [<c1002354>] ? cpu_idle+0x91=
/0xc1
Mar  6 15:55:49 laptop kernel: [11277.499383]  [<c12a24e1>] ? start_seconda=
ry+0x1bd/0x1c4
Mar  6 15:55:49 laptop kernel: [11277.499387] NMI backtrace for cpu 0
Mar  6 15:55:49 laptop kernel: [11277.499390] Modules linked in: nfs lockd =
fscache nfs_acl auth_rpcgss sunrpc tun xt_recent ipt_LOG ipt_REJECT xt_tcpu=
dp xt_state iptable_filter iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrac=
k nf_defrag_ipv4 ip_tables x_tables acpi_cpufreq mperf fuse coretemp loop a=
rc4 ecb snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_code=
c iwlagn snd_hwdep iwlcore snd_pcm asus_laptop snd_seq snd_timer snd_seq_de=
vice uvcvideo psmouse sparse_keymap joydev mac80211 pcspkr snd cfg80211 vid=
eodev ac soundcore tpm_tis tpm serio_raw snd_page_alloc tpm_bios battery ev=
dev processor rfkill sha256_generic cryptd aes_i586 aes_generic cbc dm_cryp=
t hid_microsoft usbhid hid dm_mod btrfs zlib_deflate crc32c libcrc32c reise=
rfs lzo ext3 jbd mbcache i915 drm_kms_helper drm i2c_algo_bit i2c_core sg s=
r_mod sd_mod cdrom crc_t10dif usb_storage uas uhci_hcd ahci libahci libata =
scsi_mod video thermal ehci_hcd thermal_sys button usbcore r8169 mii nls_ba=
se [last unloaded: scsi_wait_scan]
Mar  6 15:55:49 laptop kernel: [11277.499486]=20
Mar  6 15:55:49 laptop kernel: [11277.499489] Pid: 0, comm: swapper Not tai=
nted 2.6.38-rc7 #1 ASUSTeK Computer Inc.         F6A                 /F6A  =
    =20
Mar  6 15:55:49 laptop kernel: [11277.499496] EIP: 0060:[<c100857f>] EFLAGS=
: 00000046 CPU: 0
Mar  6 15:55:49 laptop kernel: [11277.499500] EIP is at mwait_idle_with_hin=
ts+0x59/0x5d
Mar  6 15:55:49 laptop kernel: [11277.499503] EAX: 00000020 EBX: 00000001 E=
CX: 00000001 EDX: 00000003
Mar  6 15:55:49 laptop kernel: [11277.499506] ESI: 00000020 EDI: f6fb63f8 E=
BP: c13f3f34 ESP: c13f3f2c
Mar  6 15:55:49 laptop kernel: [11277.499509]  DS: 007b ES: 007b FS: 00d8 G=
S: 00e0 SS: 0068
Mar  6 15:55:49 laptop kernel: [11277.499512] Process swapper (pid: 0, ti=
=3Dc13f2000 task=3Dc141ff20 task.ti=3Dc13f2000)
Mar  6 15:55:49 laptop kernel: [11277.499515] Stack:
Mar  6 15:55:49 laptop kernel: [11277.499517]  f6fb63f8 12087760 c13f3f40 c=
1015274 9592e026 c13f3f48 fa19b9d2 c13f3f78
Mar  6 15:55:49 laptop kernel: [11277.499525]  fa19bc82 00000000 77359400 0=
000001f f6fb601c 00002ed1 f6fb6000 00000000
Mar  6 15:55:49 laptop kernel: [11277.499534]  f6fb601c 00000000 000000b0 c=
13f3f94 c11f1f17 00000000 f6fb60dc c144b42c
Mar  6 15:55:49 laptop kernel: [11277.499543] Call Trace:
Mar  6 15:55:49 laptop kernel: [11277.499548]  [<c1015274>] acpi_processor_=
ffh_cstate_enter+0x28/0x2b
Mar  6 15:55:49 laptop kernel: [11277.499557]  [<fa19b9d2>] acpi_idle_do_en=
try+0x10/0x54 [processor]
Mar  6 15:55:49 laptop kernel: [11277.499563]  [<fa19bc82>] acpi_idle_enter=
_bm+0x1cd/0x288 [processor]
Mar  6 15:55:49 laptop kernel: [11277.499568]  [<c11f1f17>] cpuidle_idle_ca=
ll+0xcd/0x14a
Mar  6 15:55:49 laptop kernel: [11277.499572]  [<c1002354>] cpu_idle+0x91/0=
xc1
Mar  6 15:55:49 laptop kernel: [11277.499577]  [<c1295527>] rest_init+0x7f/=
0x81
Mar  6 15:55:49 laptop kernel: [11277.499582]  [<c144f904>] start_kernel+0x=
335/0x33a
Mar  6 15:55:49 laptop kernel: [11277.499587]  [<c144f0d2>] i386_start_kern=
el+0xd2/0xd9
Mar  6 15:55:49 laptop kernel: [11277.499589] Code: ff 0f ae 78 08 89 e0 31=
 d2 25 00 e0 ff ff 89 d1 83 c0 08 0f 01 c8 0f ae f0 89 f6 e8 94 ff ff ff 85=
 c0 75 07 89 f0 89 d9 0f 01 c9 <5b> 5e 5d c3 55 ba 10 00 00 00 89 e5 56 89 =
c6 53 89 e0 25 00 e0=20
Mar  6 15:55:49 laptop kernel: [11277.499635] Call Trace:
Mar  6 15:55:49 laptop kernel: [11277.499639]  [<c1015274>] acpi_processor_=
ffh_cstate_enter+0x28/0x2b
Mar  6 15:55:49 laptop kernel: [11277.499647]  [<fa19b9d2>] acpi_idle_do_en=
try+0x10/0x54 [processor]
Mar  6 15:55:49 laptop kernel: [11277.499653]  [<fa19bc82>] acpi_idle_enter=
_bm+0x1cd/0x288 [processor]
Mar  6 15:55:49 laptop kernel: [11277.499658]  [<c11f1f17>] cpuidle_idle_ca=
ll+0xcd/0x14a
Mar  6 15:55:49 laptop kernel: [11277.499662]  [<c1002354>] cpu_idle+0x91/0=
xc1
Mar  6 15:55:49 laptop kernel: [11277.499665]  [<c1295527>] rest_init+0x7f/=
0x81
Mar  6 15:55:49 laptop kernel: [11277.499669]  [<c144f904>] start_kernel+0x=
335/0x33a
Mar  6 15:55:49 laptop kernel: [11277.499673]  [<c144f0d2>] i386_start_kern=
el+0xd2/0xd9
Mar  6 15:55:49 laptop kernel: [11277.499677] Pid: 0, comm: swapper Not tai=
nted 2.6.38-rc7 #1
Mar  6 15:55:49 laptop kernel: [11277.499679] Call Trace:
Mar  6 15:55:49 laptop kernel: [11277.499682]  [<c1008b0a>] ? show_regs+0x1=
7/0x1a
Mar  6 15:55:49 laptop kernel: [11277.499686]  [<c12a8514>] ? arch_trigger_=
all_cpu_backtrace_handler+0x52/0x72
Mar  6 15:55:49 laptop kernel: [11277.499691]  [<c12a96e0>] ? notifier_call=
_chain+0x26/0x48
Mar  6 15:55:49 laptop kernel: [11277.499695]  [<c12a972a>] ? __atomic_noti=
fier_call_chain+0x28/0x38
Mar  6 15:55:49 laptop kernel: [11277.499699]  [<c12a9746>] ? atomic_notifi=
er_call_chain+0xc/0xe
Mar  6 15:55:49 laptop kernel: [11277.499703]  [<c12a9775>] ? notify_die+0x=
2d/0x2f
Mar  6 15:55:49 laptop kernel: [11277.499707]  [<c12a7b0b>] ? do_nmi+0x56/0=
x24b
Mar  6 15:55:49 laptop kernel: [11277.499711]  [<c10545a6>] ? tick_notify+0=
x1d1/0x2fb
Mar  6 15:55:49 laptop kernel: [11277.499715]  [<c12a7740>] ? nmi_stack_cor=
rect+0x2f/0x34
Mar  6 15:55:49 laptop kernel: [11277.499719]  [<c105007b>] ? sysctl_check_=
table+0x46/0x2a0
Mar  6 15:55:49 laptop kernel: [11277.499723]  [<c100857f>] ? mwait_idle_wi=
th_hints+0x59/0x5d
Mar  6 15:55:49 laptop kernel: [11277.499727]  [<c1015274>] ? acpi_processo=
r_ffh_cstate_enter+0x28/0x2b
Mar  6 15:55:49 laptop kernel: [11277.499735]  [<fa19b9d2>] ? acpi_idle_do_=
entry+0x10/0x54 [processor]
Mar  6 15:55:49 laptop kernel: [11277.499741]  [<fa19bc82>] ? acpi_idle_ent=
er_bm+0x1cd/0x288 [processor]
Mar  6 15:55:49 laptop kernel: [11277.499745]  [<c11f1f17>] ? cpuidle_idle_=
call+0xcd/0x14a
Mar  6 15:55:49 laptop kernel: [11277.499749]  [<c1002354>] ? cpu_idle+0x91=
/0xc1
Mar  6 15:55:49 laptop kernel: [11277.499753]  [<c1295527>] ? rest_init+0x7=
f/0x81
Mar  6 15:55:49 laptop kernel: [11277.499757]  [<c144f904>] ? start_kernel+=
0x335/0x33a
Mar  6 15:55:49 laptop kernel: [11277.499761]  [<c144f0d2>] ? i386_start_ke=
rnel+0xd2/0xd9

--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="blocked.txt"

Mar  6 15:50:28 laptop kernel: [10956.391604] SysRq : Show Blocked State
Mar  6 15:50:28 laptop kernel: [10956.391613]   task                PC stack   pid father
Mar  6 15:50:28 laptop kernel: [10956.391622] khugepaged      D 000009f6     0    28      2 0x00000000
Mar  6 15:50:28 laptop kernel: [10956.391632]  f4fe7cec 00000046 f69d1853 000009f6 f4cc6400 f4cc6694 f4cc6690 c14b0500
Mar  6 15:50:28 laptop kernel: [10956.391650]  c14b0500 c14b0500 f4cc6690 c14b0500 c14b0500 00008a81 00000000 c893fc00
Mar  6 15:50:28 laptop kernel: [10956.391667]  000009f6 f4cc6400 c12a96b7 c14e83c0 f4fe7cb0 c12a694f f4fe7cb4 c102ae11
Mar  6 15:50:28 laptop kernel: [10956.391684] Call Trace:
Mar  6 15:50:28 laptop kernel: [10956.391700]  [<c12a96b7>] ? add_preempt_count+0x97/0x9a
Mar  6 15:50:28 laptop kernel: [10956.391711]  [<c12a694f>] ? _raw_spin_lock_irqsave+0x1f/0x39
Mar  6 15:50:28 laptop kernel: [10956.391721]  [<c102ae11>] ? get_parent_ip+0xb/0x31
Mar  6 15:50:28 laptop kernel: [10956.391728]  [<c12a9613>] ? sub_preempt_count+0x7c/0x89
Mar  6 15:50:28 laptop kernel: [10956.391736]  [<c12a6b0d>] ? _raw_spin_unlock_irqrestore+0x25/0x30
Mar  6 15:50:28 laptop kernel: [10956.391745]  [<c103e44d>] ? __mod_timer+0xfe/0x109
Mar  6 15:50:28 laptop kernel: [10956.391754]  [<c12a57e2>] schedule_timeout+0x7f/0xad
Mar  6 15:50:28 laptop kernel: [10956.391762]  [<c103e03a>] ? process_timeout+0x0/0xa
Mar  6 15:50:28 laptop kernel: [10956.391771]  [<c12a4e88>] io_schedule_timeout+0x63/0xa4
Mar  6 15:50:28 laptop kernel: [10956.391780]  [<c10a658a>] congestion_wait+0x5b/0xbe
Mar  6 15:50:28 laptop kernel: [10956.391788]  [<c1049775>] ? autoremove_wake_function+0x0/0x2f
Mar  6 15:50:28 laptop kernel: [10956.391798]  [<c10bb80e>] compact_zone+0xdc/0x589
Mar  6 15:50:28 laptop kernel: [10956.391807]  [<c10bbdbc>] compact_zone_order+0x8e/0x96
Mar  6 15:50:28 laptop kernel: [10956.391816]  [<c10bbe3c>] try_to_compact_pages+0x78/0xc0
Mar  6 15:50:28 laptop kernel: [10956.391826]  [<c1099d0b>] __alloc_pages_direct_compact+0x6e/0x132
Mar  6 15:50:28 laptop kernel: [10956.391834]  [<c109a29c>] __alloc_pages_nodemask+0x33f/0x5c4
Mar  6 15:50:28 laptop kernel: [10956.391844]  [<c12a9613>] ? sub_preempt_count+0x7c/0x89
Mar  6 15:50:28 laptop kernel: [10956.391852]  [<c10c2946>] khugepaged+0x77/0xc4b
Mar  6 15:50:28 laptop kernel: [10956.391862]  [<c1049775>] ? autoremove_wake_function+0x0/0x2f
Mar  6 15:50:28 laptop kernel: [10956.391870]  [<c10c28cf>] ? khugepaged+0x0/0xc4b
Mar  6 15:50:28 laptop kernel: [10956.391877]  [<c10493d4>] kthread+0x62/0x67
Mar  6 15:50:28 laptop kernel: [10956.391884]  [<c1049372>] ? kthread+0x0/0x67
Mar  6 15:50:28 laptop kernel: [10956.391892]  [<c100367e>] kernel_thread_helper+0x6/0x10
Mar  6 15:50:28 laptop kernel: [10956.391904] atop            D f7227e30     0  2349      1 0x00000000
Mar  6 15:50:28 laptop kernel: [10956.391913]  f7227eb0 00000086 fffba000 f7227e30 f728be80 f728c114 f728c110 c14b0500
Mar  6 15:50:28 laptop kernel: [10956.391930]  c14b0500 c14b0500 f728c110 c14b0500 c14b0500 1380a3b4 000009da 00000000
Mar  6 15:50:28 laptop kernel: [10956.391947]  000009da f728be80 00000046 c14b22e4 f7227eb4 f7227ec4 00000246 00000008
Mar  6 15:50:28 laptop kernel: [10956.391963] Call Trace:
Mar  6 15:50:28 laptop kernel: [10956.391974]  [<c102ae11>] ? get_parent_ip+0xb/0x31
Mar  6 15:50:28 laptop kernel: [10956.391983]  [<c12a6692>] rwsem_down_failed_common+0xa2/0xc6
Mar  6 15:50:28 laptop kernel: [10956.391993]  [<c12a66da>] rwsem_down_read_failed+0x10/0x12
Mar  6 15:50:28 laptop kernel: [10956.392001]  [<c12a6717>] call_rwsem_down_read_failed+0x7/0xc
Mar  6 15:50:28 laptop kernel: [10956.392009]  [<c103156d>] ? get_task_mm+0x34/0x3b
Mar  6 15:50:28 laptop kernel: [10956.392016]  [<c12a5f4a>] ? down_read+0xd/0xf
Mar  6 15:50:28 laptop kernel: [10956.392024]  [<c10ad3ca>] access_process_vm+0x2e/0x12e
Mar  6 15:50:28 laptop kernel: [10956.392032]  [<c12a6add>] ? _raw_spin_unlock+0x1b/0x26
Mar  6 15:50:28 laptop kernel: [10956.392041]  [<c10ffe03>] proc_pid_cmdline+0x52/0xc8
Mar  6 15:50:28 laptop kernel: [10956.392050]  [<c1101308>] proc_info_read+0x48/0x89
Mar  6 15:50:28 laptop kernel: [10956.392057]  [<c11012c0>] ? proc_info_read+0x0/0x89
Mar  6 15:50:28 laptop kernel: [10956.392065]  [<c10c7e64>] vfs_read+0x7d/0xdb
Mar  6 15:50:28 laptop kernel: [10956.392073]  [<c10c7f59>] sys_read+0x3b/0x60
Mar  6 15:50:28 laptop kernel: [10956.392081]  [<c10030df>] sysenter_do_call+0x12/0x28
Mar  6 15:50:28 laptop kernel: [10956.392111] eclipse         D 000009f6     0  7032   3468 0x00000000
Mar  6 15:50:28 laptop kernel: [10956.392121]  e1f89cb4 00000082 eab103e9 000009f6 c40ea580 c40ea814 c40ea810 c14b0500
Mar  6 15:50:28 laptop kernel: [10956.392138]  c14b0500 c14b0500 c40ea810 c14b0500 c14b0500 f69d55b6 000009f6 00000000
Mar  6 15:50:28 laptop kernel: [10956.392154]  000009f6 c40ea580 c12a96b7 c14e83c0 e1f89c78 c12a694f e1f89c7c c102ae11
Mar  6 15:50:28 laptop kernel: [10956.392171] Call Trace:
Mar  6 15:50:28 laptop kernel: [10956.392180]  [<c12a96b7>] ? add_preempt_count+0x97/0x9a
Mar  6 15:50:28 laptop kernel: [10956.392188]  [<c12a694f>] ? _raw_spin_lock_irqsave+0x1f/0x39
Mar  6 15:50:28 laptop kernel: [10956.392197]  [<c102ae11>] ? get_parent_ip+0xb/0x31
Mar  6 15:50:28 laptop kernel: [10956.392204]  [<c12a9613>] ? sub_preempt_count+0x7c/0x89
Mar  6 15:50:28 laptop kernel: [10956.392212]  [<c12a6b0d>] ? _raw_spin_unlock_irqrestore+0x25/0x30
Mar  6 15:50:28 laptop kernel: [10956.392220]  [<c103e44d>] ? __mod_timer+0xfe/0x109
Mar  6 15:50:28 laptop kernel: [10956.392229]  [<c12a57e2>] schedule_timeout+0x7f/0xad
Mar  6 15:50:28 laptop kernel: [10956.392236]  [<c103e03a>] ? process_timeout+0x0/0xa
Mar  6 15:50:28 laptop kernel: [10956.392245]  [<c12a4e88>] io_schedule_timeout+0x63/0xa4
Mar  6 15:50:28 laptop kernel: [10956.392253]  [<c10a658a>] congestion_wait+0x5b/0xbe
Mar  6 15:50:28 laptop kernel: [10956.392261]  [<c1049775>] ? autoremove_wake_function+0x0/0x2f
Mar  6 15:50:28 laptop kernel: [10956.392269]  [<c10bb80e>] compact_zone+0xdc/0x589
Mar  6 15:50:28 laptop kernel: [10956.392278]  [<c10bbdbc>] compact_zone_order+0x8e/0x96
Mar  6 15:50:28 laptop kernel: [10956.392287]  [<c10bbe3c>] try_to_compact_pages+0x78/0xc0
Mar  6 15:50:28 laptop kernel: [10956.392295]  [<c1099d0b>] __alloc_pages_direct_compact+0x6e/0x132
Mar  6 15:50:28 laptop kernel: [10956.392304]  [<c109a29c>] __alloc_pages_nodemask+0x33f/0x5c4
Mar  6 15:50:28 laptop kernel: [10956.392313]  [<c102ae00>] ? in_sched_functions+0x28/0x2e
Mar  6 15:50:28 laptop kernel: [10956.392322]  [<c10c422b>] do_huge_pmd_anonymous_page+0x7e/0x22c
Mar  6 15:50:28 laptop kernel: [10956.392330]  [<c10acf3c>] handle_mm_fault+0x10b/0x1bd
Mar  6 15:50:28 laptop kernel: [10956.392338]  [<c12a957b>] do_page_fault+0x2fe/0x31a
Mar  6 15:50:28 laptop kernel: [10956.392347]  [<c104c6f4>] ? hrtimer_interrupt+0x12b/0x1dd
Mar  6 15:50:28 laptop kernel: [10956.392355]  [<c102ae11>] ? get_parent_ip+0xb/0x31
Mar  6 15:50:28 laptop kernel: [10956.392363]  [<c12a9613>] ? sub_preempt_count+0x7c/0x89
Mar  6 15:50:28 laptop kernel: [10956.392370]  [<c1038299>] ? irq_exit+0x67/0x69
Mar  6 15:50:28 laptop kernel: [10956.392377]  [<c12a927d>] ? do_page_fault+0x0/0x31a
Mar  6 15:50:28 laptop kernel: [10956.392384]  [<c12a7683>] error_code+0x67/0x6c
Mar  6 15:50:28 laptop kernel: [10956.392395] eclipse         D 000009f6     0  7445   3468 0x00000004
Mar  6 15:50:28 laptop kernel: [10956.392404]  c2875cb4 00000086 f69d359c 000009f6 c79ca580 c79ca814 c79ca810 c14b0500
Mar  6 15:50:28 laptop kernel: [10956.392421]  c14b0500 c14b0500 c79ca810 c14b0500 c14b0500 00009f19 00000000 c893fa40
Mar  6 15:50:28 laptop kernel: [10956.392437]  000009f6 c79ca580 c12a96b7 c14e83c0 c2875c78 c12a694f c2875c7c c102ae11
Mar  6 15:50:28 laptop kernel: [10956.392454] Call Trace:
Mar  6 15:50:28 laptop kernel: [10956.392463]  [<c12a96b7>] ? add_preempt_count+0x97/0x9a
Mar  6 15:50:28 laptop kernel: [10956.392471]  [<c12a694f>] ? _raw_spin_lock_irqsave+0x1f/0x39
Mar  6 15:50:28 laptop kernel: [10956.392479]  [<c102ae11>] ? get_parent_ip+0xb/0x31
Mar  6 15:50:28 laptop kernel: [10956.392486]  [<c12a9613>] ? sub_preempt_count+0x7c/0x89
Mar  6 15:50:28 laptop kernel: [10956.392494]  [<c12a6b0d>] ? _raw_spin_unlock_irqrestore+0x25/0x30
Mar  6 15:50:28 laptop kernel: [10956.392502]  [<c103e44d>] ? __mod_timer+0xfe/0x109
Mar  6 15:50:28 laptop kernel: [10956.392510]  [<c12a57e2>] schedule_timeout+0x7f/0xad
Mar  6 15:50:28 laptop kernel: [10956.392518]  [<c103e03a>] ? process_timeout+0x0/0xa
Mar  6 15:50:28 laptop kernel: [10956.392527]  [<c12a4e88>] io_schedule_timeout+0x63/0xa4
Mar  6 15:50:28 laptop kernel: [10956.392535]  [<c10a658a>] congestion_wait+0x5b/0xbe
Mar  6 15:50:28 laptop kernel: [10956.392542]  [<c1049775>] ? autoremove_wake_function+0x0/0x2f
Mar  6 15:50:28 laptop kernel: [10956.392550]  [<c10bb80e>] compact_zone+0xdc/0x589
Mar  6 15:50:28 laptop kernel: [10956.392559]  [<c10bbdbc>] compact_zone_order+0x8e/0x96
Mar  6 15:50:28 laptop kernel: [10956.392568]  [<c10bbe3c>] try_to_compact_pages+0x78/0xc0
Mar  6 15:50:28 laptop kernel: [10956.392576]  [<c1099d0b>] __alloc_pages_direct_compact+0x6e/0x132
Mar  6 15:50:28 laptop kernel: [10956.392585]  [<c109a29c>] __alloc_pages_nodemask+0x33f/0x5c4
Mar  6 15:50:28 laptop kernel: [10956.392594]  [<c102ae00>] ? in_sched_functions+0x28/0x2e
Mar  6 15:50:28 laptop kernel: [10956.392603]  [<c10c422b>] do_huge_pmd_anonymous_page+0x7e/0x22c
Mar  6 15:50:28 laptop kernel: [10956.392611]  [<c10acf3c>] handle_mm_fault+0x10b/0x1bd
Mar  6 15:50:28 laptop kernel: [10956.392619]  [<c12a957b>] do_page_fault+0x2fe/0x31a
Mar  6 15:50:28 laptop kernel: [10956.392628]  [<c104c6f4>] ? hrtimer_interrupt+0x12b/0x1dd
Mar  6 15:50:28 laptop kernel: [10956.392636]  [<c102ae11>] ? get_parent_ip+0xb/0x31
Mar  6 15:50:28 laptop kernel: [10956.392643]  [<c12a9613>] ? sub_preempt_count+0x7c/0x89
Mar  6 15:50:28 laptop kernel: [10956.392650]  [<c1038299>] ? irq_exit+0x67/0x69
Mar  6 15:50:28 laptop kernel: [10956.392657]  [<c12a927d>] ? do_page_fault+0x0/0x31a
Mar  6 15:50:28 laptop kernel: [10956.392664]  [<c12a7683>] error_code+0x67/0x6c
Mar  6 15:50:28 laptop kernel: [10956.392670] eclipse         D 3e9f476b     0  7458   3468 0x00000000
Mar  6 15:50:28 laptop kernel: [10956.392679]  f2c43f3c 00000086 00000000 3e9f476b f6b58000 f6b58294 f6b58290 c14b0500
Mar  6 15:50:28 laptop kernel: [10956.392696]  c14b0500 c14b0500 f6b58290 c14b0500 c14b0500 3ea06106 0000099c 00000000
Mar  6 15:50:28 laptop kernel: [10956.392712]  0000099c f6b58000 00000328 00000001 00000001 09b27328 f2c43f64 c1058003
Mar  6 15:50:28 laptop kernel: [10956.392729] Call Trace:
Mar  6 15:50:28 laptop kernel: [10956.392739]  [<c1058003>] ? do_futex+0x80/0x65e
Mar  6 15:50:28 laptop kernel: [10956.392747]  [<c102ae11>] ? get_parent_ip+0xb/0x31
Mar  6 15:50:28 laptop kernel: [10956.392756]  [<c12a6692>] rwsem_down_failed_common+0xa2/0xc6
Mar  6 15:50:28 laptop kernel: [10956.392765]  [<c12a66c8>] rwsem_down_write_failed+0x12/0x14
Mar  6 15:50:28 laptop kernel: [10956.392773]  [<c12a6722>] call_rwsem_down_write_failed+0x6/0x8
Mar  6 15:50:28 laptop kernel: [10956.392781]  [<c12a5f61>] ? down_write+0x15/0x17
Mar  6 15:50:28 laptop kernel: [10956.392788]  [<c10b0c8e>] sys_mprotect+0xb2/0x1b4
Mar  6 15:50:28 laptop kernel: [10956.392796]  [<c10030df>] sysenter_do_call+0x12/0x28
Mar  6 15:50:28 laptop kernel: [10956.392804] eclipse         D 00000001     0  7470   3468 0x00000000
Mar  6 15:50:28 laptop kernel: [10956.392813]  c8ff3f4c 00000086 c102ae11 00000001 eb6af080 eb6af314 eb6af310 c14b0500
Mar  6 15:50:28 laptop kernel: [10956.392829]  c14b0500 c14b0500 eb6af310 c14b0500 c14b0500 2cf47bd9 0000099c 00000000
Mar  6 15:50:28 laptop kernel: [10956.392846]  0000099c eb6af080 c8ff3f64 c1058003 ffffffff 00000001 00000000 00000001
Mar  6 15:50:28 laptop kernel: [10956.392862] Call Trace:
Mar  6 15:50:28 laptop kernel: [10956.392870]  [<c102ae11>] ? get_parent_ip+0xb/0x31
Mar  6 15:50:28 laptop kernel: [10956.392879]  [<c1058003>] ? do_futex+0x80/0x65e
Mar  6 15:50:28 laptop kernel: [10956.392887]  [<c102ae11>] ? get_parent_ip+0xb/0x31
Mar  6 15:50:28 laptop kernel: [10956.392896]  [<c12a6692>] rwsem_down_failed_common+0xa2/0xc6
Mar  6 15:50:28 laptop kernel: [10956.392905]  [<c12a66c8>] rwsem_down_write_failed+0x12/0x14
Mar  6 15:50:28 laptop kernel: [10956.392913]  [<c12a6722>] call_rwsem_down_write_failed+0x6/0x8
Mar  6 15:50:28 laptop kernel: [10956.392921]  [<c12a5f61>] ? down_write+0x15/0x17
Mar  6 15:50:28 laptop kernel: [10956.392928]  [<c10b0640>] sys_mmap_pgoff+0xbf/0x111
Mar  6 15:50:28 laptop kernel: [10956.392936]  [<c10030df>] sysenter_do_call+0x12/0x28
Mar  6 15:50:28 laptop kernel: [10956.392942] ps              D 00000000     0  7476  26890 0x00000004
Mar  6 15:50:28 laptop kernel: [10956.392951]  f2fc7eb0 00200086 f2fc7e30 00000000 eb568000 eb568294 eb568290 c14b0500
Mar  6 15:50:28 laptop kernel: [10956.392968]  c14b0500 c14b0500 eb568290 c14b0500 c14b0500 317a8f0f 0000099d 00000000
Mar  6 15:50:28 laptop kernel: [10956.392984]  0000099d eb568000 00200046 c14b22e4 f2fc7eb4 f2fc7ec4 00200246 00000008
Mar  6 15:50:28 laptop kernel: [10956.393001] Call Trace:
Mar  6 15:50:28 laptop kernel: [10956.393012]  [<c10db78f>] ? mntput_no_expire+0x21/0xda
Mar  6 15:50:28 laptop kernel: [10956.393020]  [<c102ae11>] ? get_parent_ip+0xb/0x31
Mar  6 15:50:28 laptop kernel: [10956.393029]  [<c12a6692>] rwsem_down_failed_common+0xa2/0xc6
Mar  6 15:50:28 laptop kernel: [10956.393038]  [<c12a66da>] rwsem_down_read_failed+0x10/0x12
Mar  6 15:50:28 laptop kernel: [10956.393046]  [<c12a6717>] call_rwsem_down_read_failed+0x7/0xc
Mar  6 15:50:28 laptop kernel: [10956.393053]  [<c103156d>] ? get_task_mm+0x34/0x3b
Mar  6 15:50:28 laptop kernel: [10956.393060]  [<c12a5f4a>] ? down_read+0xd/0xf
Mar  6 15:50:28 laptop kernel: [10956.393067]  [<c10ad3ca>] access_process_vm+0x2e/0x12e
Mar  6 15:50:28 laptop kernel: [10956.393075]  [<c12a6add>] ? _raw_spin_unlock+0x1b/0x26
Mar  6 15:50:28 laptop kernel: [10956.393083]  [<c10ffe03>] proc_pid_cmdline+0x52/0xc8
Mar  6 15:50:28 laptop kernel: [10956.393091]  [<c1101308>] proc_info_read+0x48/0x89
Mar  6 15:50:28 laptop kernel: [10956.393098]  [<c11012c0>] ? proc_info_read+0x0/0x89
Mar  6 15:50:28 laptop kernel: [10956.393106]  [<c10c7e64>] vfs_read+0x7d/0xdb
Mar  6 15:50:28 laptop kernel: [10956.393113]  [<c10c7f59>] sys_read+0x3b/0x60
Mar  6 15:50:28 laptop kernel: [10956.393120]  [<c10030df>] sysenter_do_call+0x12/0x28
Mar  6 15:50:28 laptop kernel: [10956.393126] ps              D 00000000     0  7479   5104 0x00000004
Mar  6 15:50:28 laptop kernel: [10956.393135]  f2c09eb0 00200082 f2c09e30 00000000 f39be400 f39be694 f39be690 c14b0500
Mar  6 15:50:28 laptop kernel: [10956.393152]  c14b0500 c14b0500 f39be690 c14b0500 c14b0500 d73e4c07 000009a0 00000000
Mar  6 15:50:28 laptop kernel: [10956.393168]  000009a0 f39be400 00200046 c14b22e4 f2c09eb4 f2c09ec4 00200246 00000008
Mar  6 15:50:28 laptop kernel: [10956.393185] Call Trace:
Mar  6 15:50:28 laptop kernel: [10956.393195]  [<c10db78f>] ? mntput_no_expire+0x21/0xda
Mar  6 15:50:28 laptop kernel: [10956.393203]  [<c102ae11>] ? get_parent_ip+0xb/0x31
Mar  6 15:50:28 laptop kernel: [10956.393212]  [<c12a6692>] rwsem_down_failed_common+0xa2/0xc6
Mar  6 15:50:28 laptop kernel: [10956.393221]  [<c12a66da>] rwsem_down_read_failed+0x10/0x12
Mar  6 15:50:28 laptop kernel: [10956.393229]  [<c12a6717>] call_rwsem_down_read_failed+0x7/0xc
Mar  6 15:50:28 laptop kernel: [10956.393236]  [<c103156d>] ? get_task_mm+0x34/0x3b
Mar  6 15:50:28 laptop kernel: [10956.393243]  [<c12a5f4a>] ? down_read+0xd/0xf
Mar  6 15:50:28 laptop kernel: [10956.393250]  [<c10ad3ca>] access_process_vm+0x2e/0x12e
Mar  6 15:50:28 laptop kernel: [10956.393258]  [<c12a6add>] ? _raw_spin_unlock+0x1b/0x26
Mar  6 15:50:28 laptop kernel: [10956.393266]  [<c10ffe03>] proc_pid_cmdline+0x52/0xc8
Mar  6 15:50:28 laptop kernel: [10956.393274]  [<c1101308>] proc_info_read+0x48/0x89
Mar  6 15:50:28 laptop kernel: [10956.393282]  [<c11012c0>] ? proc_info_read+0x0/0x89
Mar  6 15:50:28 laptop kernel: [10956.393289]  [<c10c7e64>] vfs_read+0x7d/0xdb
Mar  6 15:50:28 laptop kernel: [10956.393296]  [<c10c7f59>] sys_read+0x3b/0x60
Mar  6 15:50:28 laptop kernel: [10956.393304]  [<c10030df>] sysenter_do_call+0x12/0x28
Mar  6 15:50:28 laptop kernel: [10956.393310] htop            D 00000000     0  7482   4804 0x00000004
Mar  6 15:50:28 laptop kernel: [10956.393319]  c81bbeb0 00200082 c81bbe28 00000000 f6e7d780 f6e7da14 f6e7da10 c14b0500
Mar  6 15:50:28 laptop kernel: [10956.393335]  c14b0500 c14b0500 f6e7da10 c14b0500 c14b0500 4ae2ccaa 000009ab 00000000
Mar  6 15:50:28 laptop kernel: [10956.393352]  000009ab f6e7d780 00200046 c14b22e4 c81bbeb4 c81bbec4 00200246 00000008
Mar  6 15:50:28 laptop kernel: [10956.393368] Call Trace:
Mar  6 15:50:28 laptop kernel: [10956.393378]  [<c10db78f>] ? mntput_no_expire+0x21/0xda
Mar  6 15:50:28 laptop kernel: [10956.393387]  [<c102ae11>] ? get_parent_ip+0xb/0x31
Mar  6 15:50:28 laptop kernel: [10956.393395]  [<c12a6692>] rwsem_down_failed_common+0xa2/0xc6
Mar  6 15:50:28 laptop kernel: [10956.393404]  [<c12a66da>] rwsem_down_read_failed+0x10/0x12
Mar  6 15:50:28 laptop kernel: [10956.393412]  [<c12a6717>] call_rwsem_down_read_failed+0x7/0xc
Mar  6 15:50:28 laptop kernel: [10956.393420]  [<c103156d>] ? get_task_mm+0x34/0x3b
Mar  6 15:50:28 laptop kernel: [10956.393427]  [<c12a5f4a>] ? down_read+0xd/0xf
Mar  6 15:50:28 laptop kernel: [10956.393433]  [<c10ad3ca>] access_process_vm+0x2e/0x12e
Mar  6 15:50:28 laptop kernel: [10956.393442]  [<c12a6add>] ? _raw_spin_unlock+0x1b/0x26
Mar  6 15:50:28 laptop kernel: [10956.393449]  [<c10ffe03>] proc_pid_cmdline+0x52/0xc8
Mar  6 15:50:28 laptop kernel: [10956.393457]  [<c1101308>] proc_info_read+0x48/0x89
Mar  6 15:50:28 laptop kernel: [10956.393465]  [<c11012c0>] ? proc_info_read+0x0/0x89
Mar  6 15:50:28 laptop kernel: [10956.393472]  [<c10c7e64>] vfs_read+0x7d/0xdb
Mar  6 15:50:28 laptop kernel: [10956.393479]  [<c10c7f59>] sys_read+0x3b/0x60
Mar  6 15:50:28 laptop kernel: [10956.393487]  [<c10030df>] sysenter_do_call+0x12/0x28
Mar  6 15:50:28 laptop kernel: [10956.393495] pidof           D 00000000     0  7573   7483 0x00000000
Mar  6 15:50:28 laptop kernel: [10956.393504]  c2393eb0 00200086 c2393e30 00000000 c79ccb00 c79ccd94 c79ccd90 c14b0500
Mar  6 15:50:28 laptop kernel: [10956.393520]  c14b0500 c14b0500 c79ccd90 c14b0500 c14b0500 9c044d01 000009de 00000000
Mar  6 15:50:28 laptop kernel: [10956.393537]  000009de c79ccb00 00200046 c14b22e4 c2393eb4 c2393ec4 00200246 00000008
Mar  6 15:50:28 laptop kernel: [10956.393553] Call Trace:
Mar  6 15:50:28 laptop kernel: [10956.393563]  [<c10db78f>] ? mntput_no_expire+0x21/0xda
Mar  6 15:50:28 laptop kernel: [10956.393572]  [<c102ae11>] ? get_parent_ip+0xb/0x31
Mar  6 15:50:28 laptop kernel: [10956.393580]  [<c12a6692>] rwsem_down_failed_common+0xa2/0xc6
Mar  6 15:50:28 laptop kernel: [10956.393589]  [<c12a66da>] rwsem_down_read_failed+0x10/0x12
Mar  6 15:50:28 laptop kernel: [10956.393597]  [<c12a6717>] call_rwsem_down_read_failed+0x7/0xc
Mar  6 15:50:28 laptop kernel: [10956.393604]  [<c103156d>] ? get_task_mm+0x34/0x3b
Mar  6 15:50:28 laptop kernel: [10956.393612]  [<c12a5f4a>] ? down_read+0xd/0xf
Mar  6 15:50:28 laptop kernel: [10956.393618]  [<c10ad3ca>] access_process_vm+0x2e/0x12e
Mar  6 15:50:28 laptop kernel: [10956.393627]  [<c12a6add>] ? _raw_spin_unlock+0x1b/0x26
Mar  6 15:50:28 laptop kernel: [10956.393634]  [<c10ffe03>] proc_pid_cmdline+0x52/0xc8
Mar  6 15:50:28 laptop kernel: [10956.393642]  [<c1101308>] proc_info_read+0x48/0x89
Mar  6 15:50:28 laptop kernel: [10956.393650]  [<c11012c0>] ? proc_info_read+0x0/0x89
Mar  6 15:50:28 laptop kernel: [10956.393657]  [<c10c7e64>] vfs_read+0x7d/0xdb
Mar  6 15:50:28 laptop kernel: [10956.393664]  [<c10c7f59>] sys_read+0x3b/0x60
Mar  6 15:50:28 laptop kernel: [10956.393672]  [<c10030df>] sysenter_do_call+0x12/0x28
Mar  6 15:50:28 laptop kernel: [10956.393677] pidof           D 00000000     0  7574   7505 0x00000000
Mar  6 15:50:28 laptop kernel: [10956.393686]  f2a65eb0 00200082 f2a65e30 00000000 c79c9900 c79c9b94 c79c9b90 c14b0500
Mar  6 15:50:28 laptop kernel: [10956.393703]  c14b0500 c14b0500 c79c9b90 c14b0500 c14b0500 63073d5b 000009e0 00000000
Mar  6 15:50:28 laptop kernel: [10956.393719]  000009e0 c79c9900 00200046 c14b22e4 f2a65eb4 f2a65ec4 00200246 00000008
Mar  6 15:50:28 laptop kernel: [10956.393736] Call Trace:
Mar  6 15:50:28 laptop kernel: [10956.393746]  [<c10db78f>] ? mntput_no_expire+0x21/0xda
Mar  6 15:50:28 laptop kernel: [10956.393754]  [<c102ae11>] ? get_parent_ip+0xb/0x31
Mar  6 15:50:28 laptop kernel: [10956.393763]  [<c12a6692>] rwsem_down_failed_common+0xa2/0xc6
Mar  6 15:50:28 laptop kernel: [10956.393772]  [<c12a66da>] rwsem_down_read_failed+0x10/0x12
Mar  6 15:50:28 laptop kernel: [10956.393780]  [<c12a6717>] call_rwsem_down_read_failed+0x7/0xc
Mar  6 15:50:28 laptop kernel: [10956.393787]  [<c103156d>] ? get_task_mm+0x34/0x3b
Mar  6 15:50:28 laptop kernel: [10956.393794]  [<c12a5f4a>] ? down_read+0xd/0xf
Mar  6 15:50:28 laptop kernel: [10956.393801]  [<c10ad3ca>] access_process_vm+0x2e/0x12e
Mar  6 15:50:28 laptop kernel: [10956.393809]  [<c12a6add>] ? _raw_spin_unlock+0x1b/0x26
Mar  6 15:50:28 laptop kernel: [10956.393817]  [<c10ffe03>] proc_pid_cmdline+0x52/0xc8
Mar  6 15:50:28 laptop kernel: [10956.393825]  [<c1101308>] proc_info_read+0x48/0x89
Mar  6 15:50:28 laptop kernel: [10956.393832]  [<c11012c0>] ? proc_info_read+0x0/0x89
Mar  6 15:50:28 laptop kernel: [10956.393839]  [<c10c7e64>] vfs_read+0x7d/0xdb
Mar  6 15:50:28 laptop kernel: [10956.393847]  [<c10c7f59>] sys_read+0x3b/0x60
Mar  6 15:50:28 laptop kernel: [10956.393854]  [<c10030df>] sysenter_do_call+0x12/0x28
Mar  6 15:50:28 laptop kernel: [10956.393861] start-stop-daem D f3acfe64     0  7636   7631 0x00000000
Mar  6 15:50:28 laptop kernel: [10956.393871]  f3acfee8 00000086 f3acfe60 f3acfe64 c782e400 c782e694 c782e690 c14b0500
Mar  6 15:50:28 laptop kernel: [10956.393887]  c14b0500 c14b0500 c782e690 c14b0500 c14b0500 ec1d2438 000009e9 00000000
Mar  6 15:50:28 laptop kernel: [10956.393904]  000009e9 c782e400 00000001 f3acfea4 c12a9613 f5003b30 f3acfeb0 c10db028
Mar  6 15:50:28 laptop kernel: [10956.393920] Call Trace:
Mar  6 15:50:28 laptop kernel: [10956.393929]  [<c12a9613>] ? sub_preempt_count+0x7c/0x89
Mar  6 15:50:28 laptop kernel: [10956.393938]  [<c10db028>] ? vfsmount_lock_local_unlock+0x2d/0x39
Mar  6 15:50:28 laptop kernel: [10956.393946]  [<c10db78f>] ? mntput_no_expire+0x21/0xda
Mar  6 15:50:28 laptop kernel: [10956.393954]  [<c102ae11>] ? get_parent_ip+0xb/0x31
Mar  6 15:50:28 laptop kernel: [10956.393962]  [<c12a6692>] rwsem_down_failed_common+0xa2/0xc6
Mar  6 15:50:28 laptop kernel: [10956.393971]  [<c12a66da>] rwsem_down_read_failed+0x10/0x12
Mar  6 15:50:28 laptop kernel: [10956.393979]  [<c12a6717>] call_rwsem_down_read_failed+0x7/0xc
Mar  6 15:50:28 laptop kernel: [10956.393987]  [<c1031500>] ? unshare_files+0x36/0x6f
Mar  6 15:50:28 laptop kernel: [10956.393994]  [<c12a5f4a>] ? down_read+0xd/0xf
Mar  6 15:50:28 laptop kernel: [10956.394001]  [<c1102530>] get_mm_exe_file+0x11/0x2c
Mar  6 15:50:28 laptop kernel: [10956.394009]  [<c1102577>] proc_exe_link+0x2c/0x61
Mar  6 15:50:28 laptop kernel: [10956.394016]  [<c1100e49>] proc_pid_readlink+0x2c/0xa0
Mar  6 15:50:28 laptop kernel: [10956.394024]  [<c10d7c46>] ? touch_atime+0x6f/0x103
Mar  6 15:50:28 laptop kernel: [10956.394032]  [<c10ca89e>] sys_readlinkat+0x65/0x79
Mar  6 15:50:28 laptop kernel: [10956.394040]  [<c10ca8c5>] sys_readlink+0x13/0x15
Mar  6 15:50:28 laptop kernel: [10956.394048]  [<c10030df>] sysenter_do_call+0x12/0x28
Mar  6 15:50:28 laptop kernel: [10956.394057] Sched Debug Version: v0.10, 2.6.38-rc7 #1
Mar  6 15:50:28 laptop kernel: [10956.394063] ktime                                   : 10956394.056426
Mar  6 15:50:28 laptop kernel: [10956.394069] sched_clk                               : 6375159.279079
Mar  6 15:50:28 laptop kernel: [10956.394074] cpu_clk                                 : 10956394.055049
Mar  6 15:50:28 laptop kernel: [10956.394079] jiffies                                 : 2664098
Mar  6 15:50:28 laptop kernel: [10956.394083] sched_clock_stable                      : 0
Mar  6 15:50:28 laptop kernel: [10956.394087] 
Mar  6 15:50:28 laptop kernel: [10956.394090] sysctl_sched
Mar  6 15:50:28 laptop kernel: [10956.394094]   .sysctl_sched_latency                    : 12.000000
Mar  6 15:50:28 laptop kernel: [10956.394099]   .sysctl_sched_min_granularity            : 1.500000
Mar  6 15:50:28 laptop kernel: [10956.394104]   .sysctl_sched_wakeup_granularity         : 2.000000
Mar  6 15:50:28 laptop kernel: [10956.394109]   .sysctl_sched_child_runs_first           : 0
Mar  6 15:50:28 laptop kernel: [10956.394113]   .sysctl_sched_features                   : 7279
Mar  6 15:50:28 laptop kernel: [10956.394118]   .sysctl_sched_tunable_scaling            : 1 (logaritmic)
Mar  6 15:50:28 laptop kernel: [10956.394125] 
Mar  6 15:50:28 laptop kernel: [10956.394126] cpu#0, 1994.806 MHz
Mar  6 15:50:28 laptop kernel: [10956.394130]   .nr_running                    : 0
Mar  6 15:50:28 laptop kernel: [10956.394135]   .load                          : 0
Mar  6 15:50:28 laptop kernel: [10956.394139]   .nr_switches                   : 6893099
Mar  6 15:50:28 laptop kernel: [10956.394143]   .nr_load_updates               : 1422045
Mar  6 15:50:28 laptop kernel: [10956.394148]   .nr_uninterruptible            : 7
Mar  6 15:50:28 laptop kernel: [10956.394152]   .next_balance                  : 2.664084
Mar  6 15:50:28 laptop kernel: [10956.394157]   .curr->pid                     : 0
Mar  6 15:50:28 laptop kernel: [10956.394162]   .clock                         : 10956390.098402
Mar  6 15:50:28 laptop kernel: [10956.394167]   .cpu_load[0]                   : 0
Mar  6 15:50:28 laptop kernel: [10956.394171]   .cpu_load[1]                   : 0
Mar  6 15:50:28 laptop kernel: [10956.394174]   .cpu_load[2]                   : 0
Mar  6 15:50:28 laptop kernel: [10956.394178]   .cpu_load[3]                   : 0
Mar  6 15:50:28 laptop kernel: [10956.394182]   .cpu_load[4]                   : 0
Mar  6 15:50:28 laptop kernel: [10956.394186]   .yld_count                     : 1248615
Mar  6 15:50:28 laptop kernel: [10956.394190]   .sched_switch                  : 0
Mar  6 15:50:28 laptop kernel: [10956.394194]   .sched_count                   : 8187190
Mar  6 15:50:28 laptop kernel: [10956.394199]   .sched_goidle                  : 1258160
Mar  6 15:50:28 laptop kernel: [10956.394203]   .avg_idle                      : 1000000
Mar  6 15:50:28 laptop kernel: [10956.394208]   .ttwu_count                    : 3725712
Mar  6 15:50:28 laptop kernel: [10956.394212]   .ttwu_local                    : 2973822
Mar  6 15:50:28 laptop kernel: [10956.394216]   .bkl_count                     : 0
Mar  6 15:50:28 laptop kernel: [10956.394222] 
Mar  6 15:50:28 laptop kernel: [10956.394223] cfs_rq[0]:/autogroup-47
Mar  6 15:50:28 laptop kernel: [10956.394228]   .exec_clock                    : 1374970.233240
Mar  6 15:50:28 laptop kernel: [10956.394233]   .MIN_vruntime                  : 0.000001
Mar  6 15:50:28 laptop kernel: [10956.394238]   .min_vruntime                  : 1139216.917091
Mar  6 15:50:28 laptop kernel: [10956.394243]   .max_vruntime                  : 0.000001
Mar  6 15:50:28 laptop kernel: [10956.394247]   .spread                        : 0.000000
Mar  6 15:50:28 laptop kernel: [10956.394252]   .spread0                       : -7591516.050936
Mar  6 15:50:28 laptop kernel: [10956.394257]   .nr_spread_over                : 990
Mar  6 15:50:28 laptop kernel: [10956.394261]   .nr_running                    : 0
Mar  6 15:50:28 laptop kernel: [10956.394265]   .load                          : 0
Mar  6 15:50:28 laptop kernel: [10956.394270]   .load_avg                      : 222.564359
Mar  6 15:50:28 laptop kernel: [10956.394275]   .load_period                   : 5.342942
Mar  6 15:50:28 laptop kernel: [10956.394280]   .load_contrib                  : 41
Mar  6 15:50:28 laptop kernel: [10956.394284]   .load_tg                       : 94
Mar  6 15:50:28 laptop kernel: [10956.394289]   .se->exec_start                : 10956390.096250
Mar  6 15:50:28 laptop kernel: [10956.394295]   .se->vruntime                  : 8730732.968027
Mar  6 15:50:28 laptop kernel: [10956.394300]   .se->sum_exec_runtime          : 1374970.745430
Mar  6 15:50:28 laptop kernel: [10956.394305]   .se->statistics.wait_start     : 0.000000
Mar  6 15:50:28 laptop kernel: [10956.394309]   .se->statistics.sleep_start    : 0.000000
Mar  6 15:50:28 laptop kernel: [10956.394314]   .se->statistics.block_start    : 0.000000
Mar  6 15:50:28 laptop kernel: [10956.394318]   .se->statistics.sleep_max      : 0.000000
Mar  6 15:50:28 laptop kernel: [10956.394323]   .se->statistics.block_max      : 0.000000
Mar  6 15:50:28 laptop kernel: [10956.394327]   .se->statistics.exec_max       : 5.853030
Mar  6 15:50:28 laptop kernel: [10956.394332]   .se->statistics.slice_max      : 11.974884
Mar  6 15:50:28 laptop kernel: [10956.394337]   .se->statistics.wait_max       : 36.007693
Mar  6 15:50:28 laptop kernel: [10956.394342]   .se->statistics.wait_sum       : 132452.444509
Mar  6 15:50:28 laptop kernel: [10956.394347]   .se->statistics.wait_count     : 3297633
Mar  6 15:50:28 laptop kernel: [10956.394351]   .se->load.weight               : 2
Mar  6 15:50:28 laptop kernel: [10956.394356] 
Mar  6 15:50:28 laptop kernel: [10956.394357] cfs_rq[0]:/autogroup-0
Mar  6 15:50:28 laptop kernel: [10956.394363]   .exec_clock                    : 5209451.265958
Mar  6 15:50:28 laptop kernel: [10956.394368]   .MIN_vruntime                  : 0.000001
Mar  6 15:50:28 laptop kernel: [10956.394373]   .min_vruntime                  : 8730732.968027
Mar  6 15:50:28 laptop kernel: [10956.394377]   .max_vruntime                  : 0.000001
Mar  6 15:50:28 laptop kernel: [10956.394382]   .spread                        : 0.000000
Mar  6 15:50:28 laptop kernel: [10956.394386]   .spread0                       : 0.000000
Mar  6 15:50:28 laptop kernel: [10956.394391]   .nr_spread_over                : 413
Mar  6 15:50:28 laptop kernel: [10956.394395]   .nr_running                    : 0
Mar  6 15:50:28 laptop kernel: [10956.394399]   .load                          : 0
Mar  6 15:50:28 laptop kernel: [10956.394403]   .load_avg                      : 0.000000
Mar  6 15:50:28 laptop kernel: [10956.394408]   .load_period                   : 0.000000
Mar  6 15:50:28 laptop kernel: [10956.394413]   .load_contrib                  : 0
Mar  6 15:50:28 laptop kernel: [10956.394417]   .load_tg                       : 0
Mar  6 15:50:28 laptop kernel: [10956.394421] 
Mar  6 15:50:28 laptop kernel: [10956.394422] rt_rq[0]:
Mar  6 15:50:28 laptop kernel: [10956.394426]   .rt_nr_running                 : 0
Mar  6 15:50:28 laptop kernel: [10956.394430]   .rt_throttled                  : 0
Mar  6 15:50:28 laptop kernel: [10956.394434]   .rt_time                       : 0.000000
Mar  6 15:50:28 laptop kernel: [10956.394439]   .rt_runtime                    : 950.000000
Mar  6 15:50:28 laptop kernel: [10956.394444] 
Mar  6 15:50:28 laptop kernel: [10956.394446] runnable tasks:
Mar  6 15:50:28 laptop kernel: [10956.394448]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
Mar  6 15:50:28 laptop kernel: [10956.394451] ----------------------------------------------------------------------------------------------------------
Mar  6 15:50:28 laptop kernel: [10956.394475] 
Mar  6 15:50:28 laptop kernel: [10956.394476] cpu#1, 1994.806 MHz
Mar  6 15:50:28 laptop kernel: [10956.394481]   .nr_running                    : 0
Mar  6 15:50:28 laptop kernel: [10956.394485]   .load                          : 0
Mar  6 15:50:28 laptop kernel: [10956.394489]   .nr_switches                   : 6974993
Mar  6 15:50:28 laptop kernel: [10956.394493]   .nr_load_updates               : 1453716
Mar  6 15:50:28 laptop kernel: [10956.394497]   .nr_uninterruptible            : 5
Mar  6 15:50:28 laptop kernel: [10956.394502]   .next_balance                  : 2.664116
Mar  6 15:50:28 laptop kernel: [10956.394506]   .curr->pid                     : 0
Mar  6 15:50:28 laptop kernel: [10956.394511]   .clock                         : 10956389.960525
Mar  6 15:50:28 laptop kernel: [10956.394516]   .cpu_load[0]                   : 0
Mar  6 15:50:28 laptop kernel: [10956.394519]   .cpu_load[1]                   : 0
Mar  6 15:50:28 laptop kernel: [10956.394523]   .cpu_load[2]                   : 0
Mar  6 15:50:28 laptop kernel: [10956.394527]   .cpu_load[3]                   : 0
Mar  6 15:50:28 laptop kernel: [10956.394532]   .cpu_load[4]                   : 1
Mar  6 15:50:28 laptop kernel: [10956.394536]   .yld_count                     : 1257046
Mar  6 15:50:28 laptop kernel: [10956.394540]   .sched_switch                  : 0
Mar  6 15:50:28 laptop kernel: [10956.394544]   .sched_count                   : 8275263
Mar  6 15:50:28 laptop kernel: [10956.394548]   .sched_goidle                  : 1264391
Mar  6 15:50:28 laptop kernel: [10956.394553]   .avg_idle                      : 1000000
Mar  6 15:50:28 laptop kernel: [10956.394557]   .ttwu_count                    : 3760247
Mar  6 15:50:28 laptop kernel: [10956.394561]   .ttwu_local                    : 2993543
Mar  6 15:50:28 laptop kernel: [10956.394566]   .bkl_count                     : 0
Mar  6 15:50:28 laptop kernel: [10956.394571] 
Mar  6 15:50:28 laptop kernel: [10956.394572] cfs_rq[1]:/autogroup-47
Mar  6 15:50:28 laptop kernel: [10956.394577]   .exec_clock                    : 1387058.865756
Mar  6 15:50:28 laptop kernel: [10956.394582]   .MIN_vruntime                  : 0.000001
Mar  6 15:50:28 laptop kernel: [10956.394588]   .min_vruntime                  : 1157644.753041
Mar  6 15:50:28 laptop kernel: [10956.394592]   .max_vruntime                  : 0.000001
Mar  6 15:50:28 laptop kernel: [10956.394597]   .spread                        : 0.000000
Mar  6 15:50:28 laptop kernel: [10956.394602]   .spread0                       : -7573088.214986
Mar  6 15:50:28 laptop kernel: [10956.394607]   .nr_spread_over                : 1246
Mar  6 15:50:28 laptop kernel: [10956.394611]   .nr_running                    : 0
Mar  6 15:50:28 laptop kernel: [10956.394615]   .load                          : 0
Mar  6 15:50:28 laptop kernel: [10956.394620]   .load_avg                      : 469.379987
Mar  6 15:50:28 laptop kernel: [10956.394625]   .load_period                   : 8.854590
Mar  6 15:50:28 laptop kernel: [10956.394630]   .load_contrib                  : 53
Mar  6 15:50:28 laptop kernel: [10956.394634]   .load_tg                       : 94
Mar  6 15:50:28 laptop kernel: [10956.394639]   .se->exec_start                : 10956389.959034
Mar  6 15:50:28 laptop kernel: [10956.394645]   .se->vruntime                  : 8760214.994804
Mar  6 15:50:28 laptop kernel: [10956.394650]   .se->sum_exec_runtime          : 1387059.362698
Mar  6 15:50:28 laptop kernel: [10956.394655]   .se->statistics.wait_start     : 0.000000
Mar  6 15:50:28 laptop kernel: [10956.394659]   .se->statistics.sleep_start    : 0.000000
Mar  6 15:50:28 laptop kernel: [10956.394664]   .se->statistics.block_start    : 0.000000
Mar  6 15:50:28 laptop kernel: [10956.394668]   .se->statistics.sleep_max      : 0.000000
Mar  6 15:50:28 laptop kernel: [10956.394673]   .se->statistics.block_max      : 0.000000
Mar  6 15:50:28 laptop kernel: [10956.394677]   .se->statistics.exec_max       : 6.211025
Mar  6 15:50:28 laptop kernel: [10956.394682]   .se->statistics.slice_max      : 12.011269
Mar  6 15:50:28 laptop kernel: [10956.394687]   .se->statistics.wait_max       : 738.815752
Mar  6 15:50:28 laptop kernel: [10956.394692]   .se->statistics.wait_sum       : 137779.115818
Mar  6 15:50:28 laptop kernel: [10956.394697]   .se->statistics.wait_count     : 3303008
Mar  6 15:50:28 laptop kernel: [10956.394701]   .se->load.weight               : 2
Mar  6 15:50:28 laptop kernel: [10956.394706] 
Mar  6 15:50:28 laptop kernel: [10956.394708] cfs_rq[1]:/autogroup-0
Mar  6 15:50:28 laptop kernel: [10956.394713]   .exec_clock                    : 5224186.449201
Mar  6 15:50:28 laptop kernel: [10956.394718]   .MIN_vruntime                  : 0.000001
Mar  6 15:50:28 laptop kernel: [10956.394723]   .min_vruntime                  : 8760214.994804
Mar  6 15:50:28 laptop kernel: [10956.394727]   .max_vruntime                  : 0.000001
Mar  6 15:50:28 laptop kernel: [10956.394732]   .spread                        : 0.000000
Mar  6 15:50:28 laptop kernel: [10956.394737]   .spread0                       : 29482.026777
Mar  6 15:50:28 laptop kernel: [10956.394742]   .nr_spread_over                : 459
Mar  6 15:50:28 laptop kernel: [10956.394746]   .nr_running                    : 0
Mar  6 15:50:28 laptop kernel: [10956.394750]   .load                          : 0
Mar  6 15:50:28 laptop kernel: [10956.394754]   .load_avg                      : 0.000000
Mar  6 15:50:28 laptop kernel: [10956.394759]   .load_period                   : 0.000000
Mar  6 15:50:28 laptop kernel: [10956.394763]   .load_contrib                  : 0
Mar  6 15:50:28 laptop kernel: [10956.394767]   .load_tg                       : 0
Mar  6 15:50:28 laptop kernel: [10956.394772] 
Mar  6 15:50:28 laptop kernel: [10956.394773] rt_rq[1]:
Mar  6 15:50:28 laptop kernel: [10956.394777]   .rt_nr_running                 : 0
Mar  6 15:50:28 laptop kernel: [10956.394781]   .rt_throttled                  : 0
Mar  6 15:50:28 laptop kernel: [10956.394785]   .rt_time                       : 0.000000
Mar  6 15:50:28 laptop kernel: [10956.394790]   .rt_runtime                    : 950.000000
Mar  6 15:50:28 laptop kernel: [10956.394795] 
Mar  6 15:50:28 laptop kernel: [10956.394797] runnable tasks:
Mar  6 15:50:28 laptop kernel: [10956.394799]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
Mar  6 15:50:28 laptop kernel: [10956.394803] ----------------------------------------------------------------------------------------------------------
Mar  6 15:50:28 laptop kernel: [10956.394822] 

--xHFwDpU9dbj6ez1V--
