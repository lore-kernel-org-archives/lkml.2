Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587Ab0EORer (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 13:34:47 -0400
Received: from gateway01.websitewelcome.com ([74.52.222.242]:54711 "HELO
	gateway01.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751604Ab0EORep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 13:34:45 -0400
X-Greylist: delayed 396 seconds by postgrey-1.27 at vger.kernel.org; Sat, 15 May 2010 13:34:45 EDT
MIME-Version: 1.0
Date: Sat, 15 May 2010 20:28:02 +0300
Message-ID: <AANLkTin1YQV7RAh6ZSoqEcmUHuGqfGYnjME7nUtnYY3l@mail.gmail.com>
Subject: PROBLEM: with resume (?) and networking
From: Sasha Sirotkin <demiurg@femtolinux.com>
To: linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=00163642759d5225230486a550e5
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator1121.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - femtolinux.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00163642759d5225230486a550e5
Content-Type: text/plain; charset=ISO-8859-1

I'm having some problem which seems to be related to suspend/resume.

>From time to time, usually after resume, I start getting some weird
networking problems. I'm sorry, there is no better way to explain
this. Problem disappears after reboot. Here is what I have in dmesg


May 15 11:39:34 borjch kernel: [26150.566227] ------------[ cut here
]------------
May 15 11:39:34 borjch kernel: [26150.566234] WARNING: at
/build/buildd/linux-2.6.31/kernel/power/suspend_test.c:53
suspend_test_finish+0x84/0x90()
May 15 11:39:34 borjch kernel: [26150.566236] Hardware name: System Product Name
May 15 11:39:34 borjch kernel: [26150.566238] Component: resume
devices, time: 10500
May 15 11:39:34 borjch kernel: [26150.566239] Modules linked in:
nls_iso8859_1 nls_cp437 vfat fat binfmt_misc ppdev lp parport
vboxnetadp vboxnetflt vboxdrv nfsd exportfs nfs lockd nfs_acl
auth_rpcgss sunrpc dm_crypt xt_tcpudp xt_mac snd_hda_codec_realtek
nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack snd_hda_intel
snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss iptable_filter
snd_pcm ip_tables x_tables snd_seq_dummy snd_seq_oss snd_seq_midi
snd_rawmidi joydev ftdi_sio usbserial snd_seq_midi_event snd_seq
psmouse serio_raw sc92031 snd_timer snd_seq_device k8temp i2c_piix4
snd soundcore snd_page_alloc shpchp asus_atk0110 dm_raid45 xor
usb_storage usbhid r8169 mii ati_agp radeon ttm drm agpgart
i2c_algo_bit ramzswap xvmalloc lzo_decompress lzo_compress
May 15 11:39:34 borjch kernel: [26150.566278] Pid: 16727, comm:
pm-suspend Not tainted 2.6.31-16-generic #53-Ubuntu
May 15 11:39:34 borjch kernel: [26150.566280] Call Trace:
May 15 11:39:34 borjch kernel: [26150.566286]  [<c014518d>]
warn_slowpath_common+0x6d/0xa0
May 15 11:39:34 borjch kernel: [26150.566289]  [<c0174e74>] ?
suspend_test_finish+0x84/0x90
May 15 11:39:34 borjch kernel: [26150.566292]  [<c0174e74>] ?
suspend_test_finish+0x84/0x90
May 15 11:39:34 borjch kernel: [26150.566295]  [<c0145206>]
warn_slowpath_fmt+0x26/0x30
May 15 11:39:34 borjch kernel: [26150.566298]  [<c0174e74>]
suspend_test_finish+0x84/0x90
May 15 11:39:34 borjch kernel: [26150.566301]  [<c0174c5f>]
suspend_devices_and_enter+0x9f/0xd0
May 15 11:39:34 borjch kernel: [26150.566305]  [<c056ea7c>] ? printk+0x18/0x1c
May 15 11:39:34 borjch kernel: [26150.566307]  [<c0174d49>]
enter_state+0xb9/0xf0
May 15 11:39:34 borjch kernel: [26150.566310]  [<c017443d>]
state_store+0x6d/0xb0
May 15 11:39:34 borjch kernel: [26150.566313]  [<c01743d0>] ?
state_store+0x0/0xb0
May 15 11:39:34 borjch kernel: [26150.566317]  [<c0311f80>]
kobj_attr_store+0x20/0x30
May 15 11:39:34 borjch kernel: [26150.566321]  [<c0239780>]
sysfs_write_file+0x90/0x100
May 15 11:39:34 borjch kernel: [26150.566325]  [<c01e791a>] vfs_write+0x9a/0x190
May 15 11:39:34 borjch kernel: [26150.566328]  [<c02396f0>] ?
sysfs_write_file+0x0/0x100
May 15 11:39:34 borjch kernel: [26150.566331]  [<c05733ab>] ?
do_page_fault+0x19b/0x380
May 15 11:39:34 borjch kernel: [26150.566334]  [<c01e83dd>] sys_write+0x3d/0x70
May 15 11:39:34 borjch kernel: [26150.566337]  [<c010336c>] syscall_call+0x7/0xb
May 15 11:39:34 borjch kernel: [26150.566339] ---[ end trace
abb3daa247765c8c ]---

--00163642759d5225230486a550e5
Content-Type: text/plain; charset=US-ASCII; name="ver_linux.txt"
Content-Disposition: attachment; filename="ver_linux.txt"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g98plkcm0

SWYgc29tZSBmaWVsZHMgYXJlIGVtcHR5IG9yIGxvb2sgdW51c3VhbCB5b3UgbWF5IGhhdmUgYW4g
b2xkIHZlcnNpb24uCkNvbXBhcmUgdG8gdGhlIGN1cnJlbnQgbWluaW1hbCByZXF1aXJlbWVudHMg
aW4gRG9jdW1lbnRhdGlvbi9DaGFuZ2VzLgogCkxpbnV4IGJvcmpjaC5ybmsgMi42LjMxLTE2LWdl
bmVyaWMgIzUzLVVidW50dSBTTVAgVHVlIERlYyA4IDA0OjAxOjI5IFVUQyAyMDA5IGk2ODYgR05V
L0xpbnV4CiAKR251IEMgICAgICAgICAgICAgICAgICA0LjQuMQpHbnUgbWFrZSAgICAgICAgICAg
ICAgIDMuODEKYmludXRpbHMgICAgICAgICAgICAgICAyLjIwCnV0aWwtbGludXggICAgICAgICAg
ICAgMi4xNgptb3VudCAgICAgICAgICAgICAgICAgIHN1cHBvcnQKbW9kdWxlLWluaXQtdG9vbHMg
ICAgICAzLjEwCmUyZnNwcm9ncyAgICAgICAgICAgICAgMS40MS45CnJlaXNlcmZzcHJvZ3MgICAg
ICAgICAgMy42LjIxCnhmc3Byb2dzICAgICAgICAgICAgICAgMy4wLjIKcGNtY2lhdXRpbHMgICAg
ICAgICAgICAwMTQKTGludXggQyBMaWJyYXJ5ICAgICAgICAyLjEwLjEKRHluYW1pYyBsaW5rZXIg
KGxkZCkgICAyLjEwLjEKUHJvY3BzICAgICAgICAgICAgICAgICAzLjIuOApOZXQtdG9vbHMgICAg
ICAgICAgICAgIDEuNjAKS2JkICAgICAgICAgICAgICAgICAgICAxLjE1ClNoLXV0aWxzICAgICAg
ICAgICAgICAgNy40CndpcmVsZXNzLXRvb2xzICAgICAgICAgMjkKTW9kdWxlcyBMb2FkZWQgICAg
ICAgICBubHNfaXNvODg1OV8xIG5sc19jcDQzNyB2ZmF0IGZhdCBiaW5mbXRfbWlzYyBwcGRldiBs
cCBwYXJwb3J0IHZib3huZXRhZHAgdmJveG5ldGZsdCB2Ym94ZHJ2IG5mc2QgZXhwb3J0ZnMgbmZz
IGxvY2tkIG5mc19hY2wgYXV0aF9ycGNnc3Mgc3VucnBjIGRtX2NyeXB0IHNuZF9oZGFfY29kZWNf
cmVhbHRlayB4dF90Y3B1ZHAgeHRfbWFjIG5mX2Nvbm50cmFja19pcHY0IG5mX2RlZnJhZ19pcHY0
IHh0X3N0YXRlIG5mX2Nvbm50cmFjayBzbmRfaGRhX2ludGVsIHNuZF9oZGFfY29kZWMgc25kX2h3
ZGVwIHNuZF9wY21fb3NzIHNuZF9taXhlcl9vc3Mgc25kX3BjbSBpcHRhYmxlX2ZpbHRlciBpcF90
YWJsZXMgeF90YWJsZXMgc25kX3NlcV9kdW1teSBqb3lkZXYgc25kX3NlcV9vc3Mgc25kX3NlcV9t
aWRpIHNuZF9yYXdtaWRpIGZ0ZGlfc2lvIHVzYnNlcmlhbCBzbmRfc2VxX21pZGlfZXZlbnQgc25k
X3NlcSBzbmRfdGltZXIgc25kX3NlcV9kZXZpY2UgcHNtb3VzZSBzZXJpb19yYXcgazh0ZW1wIHNj
OTIwMzEgYXN1c19hdGswMTEwIHNocGNocCBzbmQgaTJjX3BpaXg0IHNvdW5kY29yZSBzbmRfcGFn
ZV9hbGxvYyBkbV9yYWlkNDUgeG9yIHVzYl9zdG9yYWdlIHVzYmhpZCByYWRlb24gdHRtIGRybSBp
MmNfYWxnb19iaXQgcjgxNjkgbWlpIGF0aV9hZ3AgYWdwZ2FydCByYW16c3dhcCB4dm1hbGxvYyBs
em9fZGVjb21wcmVzcyBsem9fY29tcHJlc3MK
--00163642759d5225230486a550e5
Content-Type: text/plain; charset=US-ASCII; name="info.txt"
Content-Disposition: attachment; filename="info.txt"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g98pn3691

bmxzX2lzbzg4NTlfMSAzNzQwIDEgLSBMaXZlIDB4Zjg2YTgwMDAKbmxzX2NwNDM3IDUzNzIgMSAt
IExpdmUgMHhmODZhMDAwMAp2ZmF0IDEwNzE2IDEgLSBMaXZlIDB4Zjg1NzgwMDAKZmF0IDUxNDUy
IDEgdmZhdCwgTGl2ZSAweGY4Njg2MDAwCmJpbmZtdF9taXNjIDgzNTYgMSAtIExpdmUgMHhmODU1
YzAwMApwcGRldiA2Njg4IDAgLSBMaXZlIDB4Zjg1NTIwMDAKbHAgODk2NCAwIC0gTGl2ZSAweGY4
NTA1MDAwCnBhcnBvcnQgMzUzNDAgMiBwcGRldixscCwgTGl2ZSAweGY4NTQyMDAwCnZib3huZXRh
ZHAgNzI5NiAwIC0gTGl2ZSAweGY4MzMzMDAwCnZib3huZXRmbHQgMTQzNDQgMCAtIExpdmUgMHhm
ODM4MTAwMAp2Ym94ZHJ2IDE3NzMyMCAyIHZib3huZXRhZHAsdmJveG5ldGZsdCwgTGl2ZSAweGY4
NmVmMDAwCm5mc2QgMjQxMTA0IDkgLSBMaXZlIDB4Zjg3MzIwMDAKZXhwb3J0ZnMgNDQxMiAxIG5m
c2QsIExpdmUgMHhmODM1ZTAwMApuZnMgMjcxOTEyIDEgLSBMaXZlIDB4Zjg2YWEwMDAKbG9ja2Qg
Njc3MjQgMiBuZnNkLG5mcywgTGl2ZSAweGY4NjNlMDAwCm5mc19hY2wgMjg0NCAyIG5mc2QsbmZz
LCBMaXZlIDB4ZjgyOTgwMDAKYXV0aF9ycGNnc3MgMzY1NzYgMiBuZnNkLG5mcywgTGl2ZSAweGY4
NTdkMDAwCnN1bnJwYyAxOTE3MTIgMTQgbmZzZCxuZnMsbG9ja2QsbmZzX2FjbCxhdXRoX3JwY2dz
cywgTGl2ZSAweGY4NWY1MDAwCmRtX2NyeXB0IDEyOTI4IDAgLSBMaXZlIDB4ZjgyN2MwMDAKc25k
X2hkYV9jb2RlY19yZWFsdGVrIDIwMjMzNiAxIC0gTGl2ZSAweGY4NWFmMDAwCnh0X3RjcHVkcCAy
NzgwIDcgLSBMaXZlIDB4ZjgyNmEwMDAKeHRfbWFjIDEzNzIgMyAtIExpdmUgMHhmODUzZjAwMApu
Zl9jb25udHJhY2tfaXB2NCAxMzM1MiA4IC0gTGl2ZSAweGY4MzhmMDAwCm5mX2RlZnJhZ19pcHY0
IDE3NTYgMSBuZl9jb25udHJhY2tfaXB2NCwgTGl2ZSAweGY4Mzc2MDAwCnh0X3N0YXRlIDE4MjAg
OCAtIExpdmUgMHhmODMzNjAwMApuZl9jb25udHJhY2sgNjc2MDggMiBuZl9jb25udHJhY2tfaXB2
NCx4dF9zdGF0ZSwgTGl2ZSAweGY4NTBiMDAwCnNuZF9oZGFfaW50ZWwgMjY1NjAgMCAtIExpdmUg
MHhmODM4NjAwMApzbmRfaGRhX2NvZGVjIDc4MzAwIDIgc25kX2hkYV9jb2RlY19yZWFsdGVrLHNu
ZF9oZGFfaW50ZWwsIExpdmUgMHhmODRkZDAwMApzbmRfaHdkZXAgNzM5MiAxIHNuZF9oZGFfY29k
ZWMsIExpdmUgMHhmODAxZjAwMApzbmRfcGNtX29zcyAzNzMxMiAwIC0gTGl2ZSAweGY4MzI3MDAw
CnNuZF9taXhlcl9vc3MgMTYxODggMSBzbmRfcGNtX29zcywgTGl2ZSAweGY4Mjc2MDAwCnNuZF9w
Y20gNzQ5NzYgMyBzbmRfaGRhX2ludGVsLHNuZF9oZGFfY29kZWMsc25kX3BjbV9vc3MsIExpdmUg
MHhmODM0OTAwMAppcHRhYmxlX2ZpbHRlciAzMTAwIDEgLSBMaXZlIDB4ZjgyNGEwMDAKaXBfdGFi
bGVzIDExNjkyIDEgaXB0YWJsZV9maWx0ZXIsIExpdmUgMHhmODI1ZDAwMAp4X3RhYmxlcyAxNjU0
NCA0IHh0X3RjcHVkcCx4dF9tYWMseHRfc3RhdGUsaXBfdGFibGVzLCBMaXZlIDB4ZjgyNmYwMDAK
c25kX3NlcV9kdW1teSAyNzUyIDAgLSBMaXZlIDB4ZjgyNTcwMDAKam95ZGV2IDEwMjcyIDAgLSBM
aXZlIDB4ZjgwMmIwMDAKc25kX3NlcV9vc3MgMjkyODAgMCAtIExpdmUgMHhmODAzMzAwMApzbmRf
c2VxX21pZGkgNjYyNCAwIC0gTGl2ZSAweGY4NGQ5MDAwCnNuZF9yYXdtaWRpIDIyMjA4IDEgc25k
X3NlcV9taWRpLCBMaXZlIDB4Zjg0Y2IwMDAKZnRkaV9zaW8gNTI1ODAgMSAtIExpdmUgMHhmODRh
ZjAwMAp1c2JzZXJpYWwgMzYyMzIgMyBmdGRpX3NpbywgTGl2ZSAweGY4MzYxMDAwCnNuZF9zZXFf
bWlkaV9ldmVudCA2OTQwIDIgc25kX3NlcV9vc3Msc25kX3NlcV9taWRpLCBMaXZlIDB4ZjgyZjMw
MDAKc25kX3NlcSA1MTA4OCA2IHNuZF9zZXFfZHVtbXksc25kX3NlcV9vc3Msc25kX3NlcV9taWRp
LHNuZF9zZXFfbWlkaV9ldmVudCwgTGl2ZSAweGY4MzNhMDAwCnNuZF90aW1lciAyMTU0MCAyIHNu
ZF9wY20sc25kX3NlcSwgTGl2ZSAweGY4MzFmMDAwCnNuZF9zZXFfZGV2aWNlIDcyMDggNSBzbmRf
c2VxX2R1bW15LHNuZF9zZXFfb3NzLHNuZF9zZXFfbWlkaSxzbmRfcmF3bWlkaSxzbmRfc2VxLCBM
aXZlIDB4ZjgyYzMwMDAKcHNtb3VzZSA1NjUwMCAwIC0gTGl2ZSAweGY4MmUwMDAwCnNlcmlvX3Jh
dyA1MjgwIDAgLSBMaXZlIDB4ZjgyNDIwMDAKazh0ZW1wIDQxODggMCAtIExpdmUgMHhmODA5ZTAw
MApzYzkyMDMxIDE0MTQ0IDAgLSBMaXZlIDB4ZjgyMzQwMDAKYXN1c19hdGswMTEwIDgyNTIgMCAt
IExpdmUgMHhmODJkMTAwMApzaHBjaHAgMzIyNzIgMCAtIExpdmUgMHhmODMxNTAwMApzbmQgNjA5
MDAgMTQgc25kX2hkYV9jb2RlY19yZWFsdGVrLHNuZF9oZGFfaW50ZWwsc25kX2hkYV9jb2RlYyxz
bmRfaHdkZXAsc25kX3BjbV9vc3Msc25kX21peGVyX29zcyxzbmRfcGNtLHNuZF9zZXFfZHVtbXks
c25kX3NlcV9vc3Msc25kX3NlcV9taWRpLHNuZF9yYXdtaWRpLHNuZF9zZXEsc25kX3RpbWVyLHNu
ZF9zZXFfZGV2aWNlLCBMaXZlIDB4ZjgyZjYwMDAKaTJjX3BpaXg0IDk5MzIgMCAtIExpdmUgMHhm
ODJjOTAwMApzb3VuZGNvcmUgNzI2NCAxIHNuZCwgTGl2ZSAweGY4MjJkMDAwCnNuZF9wYWdlX2Fs
bG9jIDkwNjAgMiBzbmRfaGRhX2ludGVsLHNuZF9wY20sIExpdmUgMHhmODI0NTAwMApkbV9yYWlk
NDUgODQyMjggMCAtIExpdmUgMHhmODI4MTAwMAp4b3IgMTU2MjAgMSBkbV9yYWlkNDUsIExpdmUg
MHhmODIyNzAwMAp1c2Jfc3RvcmFnZSA1MjU3NiAxIC0gTGl2ZSAweGY4MjBlMDAwCnVzYmhpZCAz
ODIwOCAwIC0gTGl2ZSAweGY4NGJmMDAwCnJhZGVvbiA2MzYwMDAgMiAtIExpdmUgMHhmODM5NzAw
MAp0dG0gMzYyMTIgMSByYWRlb24sIExpdmUgMHhmODJkNTAwMApkcm0gMTU5NTg0IDQgcmFkZW9u
LHR0bSwgTGl2ZSAweGY4MjlhMDAwCmkyY19hbGdvX2JpdCA1NzYwIDEgcmFkZW9uLCBMaXZlIDB4
ZjgyNjIwMDAKcjgxNjkgMzIwNjQgMCAtIExpdmUgMHhmODI0ZDAwMAptaWkgNTIxMiAxIHI4MTY5
LCBMaXZlIDB4ZjgyM2IwMDAKYXRpX2FncCA2NzYwIDAgLSBMaXZlIDB4ZjgyMzAwMDAKYWdwZ2Fy
dCAzNDk4OCAzIHR0bSxkcm0sYXRpX2FncCwgTGl2ZSAweGY4MjFjMDAwCnJhbXpzd2FwIDg4ODAg
MSAtIExpdmUgMHhmODA5OTAwMAp4dm1hbGxvYyA1MTgwIDEgcmFtenN3YXAsIExpdmUgMHhmODAy
ZjAwMApsem9fZGVjb21wcmVzcyAyNjIwIDEgcmFtenN3YXAsIExpdmUgMHhmODAyODAwMApsem9f
Y29tcHJlc3MgMjMwMCAxIHJhbXpzd2FwLCBMaXZlIDB4ZjgwMjIwMDAK
--00163642759d5225230486a550e5--
