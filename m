Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756233Ab1IAJLG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 05:11:06 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:65471 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727Ab1IAJLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 05:11:01 -0400
MIME-Version: 1.0
In-Reply-To: <20110829204846.GA14699@sucs.org>
References: <20110829204846.GA14699@sucs.org>
Date: Thu, 1 Sep 2011 17:02:51 +0800
Message-ID: <CABqxG0cUx4W5JH-gX-rUe=mZ8SY0uxkrCyofPsfUDBojwWKTvQ@mail.gmail.com>
Subject: Re: BUG: unable to handle kernel paging request at 6b6b6bcb (v4l2_device_disconnect+0x11/0x30)
From: Dave Young <hidave.darkstar@gmail.com>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: multipart/mixed; boundary=20cf300fabc96f681b04abdd8229
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--20cf300fabc96f681b04abdd8229
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 30, 2011 at 4:48 AM, Sitsofe Wheeler <sitsofe@yahoo.com> wrote:
> Hi,
>
> I managed to produce an oops in 3.1.0-rc3-00270-g7a54f5e by unplugging a
> USB webcam. See below:

Could you try the attached patch?

>
> eeepc kernel: [ 1263.874756] cheese[3402]: segfault at 58 ip 080630b6 sp =
afc2c840 error 4 in cheese[8048000+24000]
> eeepc kernel: [ 1393.419370] uvcvideo: Non-zero status (-84) in status co=
mpletion handler.
> eeepc kernel: [ 1393.500719] usb 3-2: USB disconnect, device number 4
> eeepc kernel: [ 1393.504351] uvcvideo: Failed to resubmit video URB (-19)=
.
> eeepc kernel: [ 1495.428853] BUG: unable to handle kernel paging request =
at 6b6b6bcb
> eeepc kernel: [ 1495.429017] IP: [<b0358d37>] dev_get_drvdata+0x17/0x20
> eeepc kernel: [ 1495.429017] *pde =3D 00000000
> eeepc kernel: [ 1495.429017] Oops: 0000 [#1] DEBUG_PAGEALLOC
> eeepc kernel: [ 1495.429017]
> eeepc kernel: [ 1495.429017] Pid: 3476, comm: cheese Not tainted 3.1.0-rc=
3-00270-g7a54f5e-dirty #485 ASUSTeK Computer INC. 900/900
> eeepc kernel: [ 1495.429017] EIP: 0060:[<b0358d37>] EFLAGS: 00010202 CPU:=
 0
> eeepc kernel: [ 1495.429017] EIP is at dev_get_drvdata+0x17/0x20
> eeepc kernel: [ 1495.429017] EAX: 6b6b6b6b EBX: eb08d870 ECX: 00000000 ED=
X: eb08d930
> eeepc kernel: [ 1495.429017] ESI: eb08d870 EDI: eb08d870 EBP: d3249cac ES=
P: d3249cac
> eeepc kernel: [ 1495.429017] =C2=A0DS: 007b ES: 007b FS: 0000 GS: 00e0 SS=
: 0068
> eeepc kernel: [ 1495.429017] Process cheese (pid: 3476, ti=3Dd3248000 tas=
k=3Ddf46d870 task.ti=3Dd3248000)
> eeepc kernel: [ 1495.429017] Stack:
> eeepc kernel: [ 1495.429017] =C2=A0d3249cb8 b03e77a1 d307b840 d3249ccc b0=
3e77d1 d307b840 eb08d870 eb08d830
> eeepc kernel: [ 1495.429017] =C2=A0d3249ce4 b03ed3b7 00000246 d307b840 eb=
08d870 d3021b80 d3249cec b03ed565
> eeepc kernel: [ 1495.429017] =C2=A0d3249cfc b03e044d e8323d10 b06e013c d3=
249d18 b0355fb9 fffffffe d3249d1c
> eeepc kernel: [ 1495.429017] Call Trace:
> eeepc kernel: [ 1495.429017] =C2=A0[<b03e77a1>] v4l2_device_disconnect+0x=
11/0x30
> eeepc kernel: [ 1495.429017] =C2=A0[<b03e77d1>] v4l2_device_unregister+0x=
11/0x50
> eeepc kernel: [ 1495.429017] =C2=A0[<b03ed3b7>] uvc_delete+0x37/0x110
> eeepc kernel: [ 1495.429017] =C2=A0[<b03ed565>] uvc_release+0x25/0x30
> eeepc kernel: [ 1495.429017] =C2=A0[<b03e044d>] v4l2_device_release+0x9d/=
0xc0
> eeepc kernel: [ 1495.429017] =C2=A0[<b0355fb9>] device_release+0x19/0x90
> eeepc kernel: [ 1495.429017] =C2=A0[<b03adfdc>] ? usb_hcd_unlink_urb+0x7c=
/0x90
> eeepc kernel: [ 1495.429017] =C2=A0[<b026b99c>] kobject_release+0x3c/0x90
> eeepc kernel: [ 1495.429017] =C2=A0[<b026b960>] ? kobject_del+0x30/0x30
> eeepc kernel: [ 1495.429017] =C2=A0[<b026ca4c>] kref_put+0x2c/0x60
> eeepc kernel: [ 1495.429017] =C2=A0[<b026b88d>] kobject_put+0x1d/0x50
> eeepc kernel: [ 1495.429017] =C2=A0[<b03b2385>] ? usb_autopm_put_interfac=
e+0x25/0x30
> eeepc kernel: [ 1495.429017] =C2=A0[<b03f0e5d>] ? uvc_v4l2_release+0x5d/0=
xd0
> eeepc kernel: [ 1495.429017] =C2=A0[<b0355d2f>] put_device+0xf/0x20
> eeepc kernel: [ 1495.429017] =C2=A0[<b03dfa96>] v4l2_release+0x56/0x60
> eeepc kernel: [ 1495.429017] =C2=A0[<b019c8dc>] fput+0xcc/0x220
> eeepc kernel: [ 1495.429017] =C2=A0[<b01990f4>] filp_close+0x44/0x70
> eeepc kernel: [ 1495.429017] =C2=A0[<b012b238>] put_files_struct+0x158/0x=
180
> eeepc kernel: [ 1495.429017] =C2=A0[<b012b100>] ? put_files_struct+0x20/0=
x180
> eeepc kernel: [ 1495.429017] =C2=A0[<b012b2a0>] exit_files+0x40/0x50
> eeepc kernel: [ 1495.429017] =C2=A0[<b012b9e7>] do_exit+0x5a7/0x660
> eeepc kernel: [ 1495.429017] =C2=A0[<b0135f72>] ? __dequeue_signal+0x12/0=
x120
> eeepc kernel: [ 1495.429017] =C2=A0[<b055edf2>] ? _raw_spin_unlock_irq+0x=
22/0x30
> eeepc kernel: [ 1495.429017] =C2=A0[<b012badc>] do_group_exit+0x3c/0xb0
> eeepc kernel: [ 1495.429017] =C2=A0[<b015792b>] ? trace_hardirqs_on+0xb/0=
x10
> eeepc kernel: [ 1495.429017] =C2=A0[<b013755f>] get_signal_to_deliver+0x1=
8f/0x570
> eeepc kernel: [ 1495.429017] =C2=A0[<b01020f7>] do_signal+0x47/0x9e0
> eeepc kernel: [ 1495.429017] =C2=A0[<b055edf2>] ? _raw_spin_unlock_irq+0x=
22/0x30
> eeepc kernel: [ 1495.429017] =C2=A0[<b015792b>] ? trace_hardirqs_on+0xb/0=
x10
> eeepc kernel: [ 1495.429017] =C2=A0[<b0123300>] ? T.1034+0x30/0xc0
> eeepc kernel: [ 1495.429017] =C2=A0[<b055c45f>] ? schedule+0x29f/0x640
> eeepc kernel: [ 1495.429017] =C2=A0[<b0102ac8>] do_notify_resume+0x38/0x4=
0
> eeepc kernel: [ 1495.429017] =C2=A0[<b055f154>] work_notifysig+0x9/0x11
> eeepc kernel: [ 1495.429017] Code: e5 5d 83 f8 01 19 c0 f7 d0 83 e0 f0 c3=
 8d b4 26 00 00 00 00 55 85 c0 89 e5 75 09 31 c0 5d c3 90 8d 74 26 00 8b 40=
 04 85 c0 74 f0 <8b> 40 60 5d c3 8d 74 26 00 55 89 e5 53 89 c3 83 ec 04 8b =
40 04
> eeepc kernel: [ 1495.429017] EIP: [<b0358d37>] dev_get_drvdata+0x17/0x20 =
SS:ESP 0068:d3249cac
> eeepc kernel: [ 1495.429017] CR2: 000000006b6b6bcb
> eeepc kernel: [ 1495.466975] uvcvideo: Failed to resubmit video URB (-27)=
.
> eeepc kernel: [ 1495.467860] uvcvideo: Failed to resubmit video URB (-27)=
.
> eeepc kernel: last message repeated 3 times
> eeepc kernel: [ 1495.512610] ---[ end trace 73ec16848794e5a5 ]---
> eeepc kernel: [ 1495.512620] Fixing recursive fault but reboot is needed!
>
> --
> Sitsofe | http://sucs.org/~sits/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" i=
n
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at =C2=A0http://www.tux.org/lkml/
>



--=20
Regards
Yang RuiRui

--20cf300fabc96f681b04abdd8229
Content-Type: text/x-pascal; charset=US-ASCII; name="uvc-fix.patch"
Content-Disposition: attachment; filename="uvc-fix.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gs1iu6o40

UmVwb3J0ZWQtYnk6IFNpdHNvZmUgV2hlZWxlciA8c2l0c29mZUB5YWhvby5jb20+ClNpZ25lZC1v
ZmYtYnk6IERhdmUgWW91bmcgPGhpZGF2ZS5kYXJrc3RhckBnbWFpbC5jb20+CgpVbnBsdWdnaW5n
IHV2YyB2aWRlbyBjYW1lcmEgdHJpZ2dlciBmb2xsb3dpbmcgb29wczoKCmVlZXBjIGtlcm5lbDog
WyAxMzkzLjUwMDcxOV0gdXNiIDMtMjogVVNCIGRpc2Nvbm5lY3QsIGRldmljZSBudW1iZXIgNApl
ZWVwYyBrZXJuZWw6IFsgMTM5My41MDQzNTFdIHV2Y3ZpZGVvOiBGYWlsZWQgdG8gcmVzdWJtaXQg
dmlkZW8gVVJCICgtMTkpLgplZWVwYyBrZXJuZWw6IFsgMTQ5NS40Mjg4NTNdIEJVRzogdW5hYmxl
IHRvIGhhbmRsZSBrZXJuZWwgcGFnaW5nIHJlcXVlc3QgYXQgNmI2YjZiY2IKZWVlcGMga2VybmVs
OiBbIDE0OTUuNDI5MDE3XSBJUDogWzxiMDM1OGQzNz5dIGRldl9nZXRfZHJ2ZGF0YSsweDE3LzB4
MjAKZWVlcGMga2VybmVsOiBbIDE0OTUuNDI5MDE3XSAqcGRlID0gMDAwMDAwMDAgCmVlZXBjIGtl
cm5lbDogWyAxNDk1LjQyOTAxN10gT29wczogMDAwMCBbIzFdIERFQlVHX1BBR0VBTExPQwplZWVw
YyBrZXJuZWw6IFsgMTQ5NS40MjkwMTddIAplZWVwYyBrZXJuZWw6IFsgMTQ5NS40MjkwMTddIFBp
ZDogMzQ3NiwgY29tbTogY2hlZXNlIE5vdCB0YWludGVkIDMuMS4wLXJjMy0wMDI3MC1nN2E1NGY1
ZS1kaXJ0eSAjNDg1IEFTVVNUZUsgQ29tcHV0ZXIgSU5DLiA5MDAvOTAwCmVlZXBjIGtlcm5lbDog
WyAxNDk1LjQyOTAxN10gRUlQOiAwMDYwOls8YjAzNThkMzc+XSBFRkxBR1M6IDAwMDEwMjAyIENQ
VTogMAplZWVwYyBrZXJuZWw6IFsgMTQ5NS40MjkwMTddIEVJUCBpcyBhdCBkZXZfZ2V0X2RydmRh
dGErMHgxNy8weDIwCmVlZXBjIGtlcm5lbDogWyAxNDk1LjQyOTAxN10gRUFYOiA2YjZiNmI2YiBF
Qlg6IGViMDhkODcwIEVDWDogMDAwMDAwMDAgRURYOiBlYjA4ZDkzMAplZWVwYyBrZXJuZWw6IFsg
MTQ5NS40MjkwMTddIEVTSTogZWIwOGQ4NzAgRURJOiBlYjA4ZDg3MCBFQlA6IGQzMjQ5Y2FjIEVT
UDogZDMyNDljYWMKZWVlcGMga2VybmVsOiBbIDE0OTUuNDI5MDE3XSAgRFM6IDAwN2IgRVM6IDAw
N2IgRlM6IDAwMDAgR1M6IDAwZTAgU1M6IDAwNjgKZWVlcGMga2VybmVsOiBbIDE0OTUuNDI5MDE3
XSBQcm9jZXNzIGNoZWVzZSAocGlkOiAzNDc2LCB0aT1kMzI0ODAwMCB0YXNrPWRmNDZkODcwIHRh
c2sudGk9ZDMyNDgwMDApCmVlZXBjIGtlcm5lbDogWyAxNDk1LjQyOTAxN10gU3RhY2s6CmVlZXBj
IGtlcm5lbDogWyAxNDk1LjQyOTAxN10gIGQzMjQ5Y2I4IGIwM2U3N2ExIGQzMDdiODQwIGQzMjQ5
Y2NjIGIwM2U3N2QxIGQzMDdiODQwIGViMDhkODcwIGViMDhkODMwCmVlZXBjIGtlcm5lbDogWyAx
NDk1LjQyOTAxN10gIGQzMjQ5Y2U0IGIwM2VkM2I3IDAwMDAwMjQ2IGQzMDdiODQwIGViMDhkODcw
IGQzMDIxYjgwIGQzMjQ5Y2VjIGIwM2VkNTY1CmVlZXBjIGtlcm5lbDogWyAxNDk1LjQyOTAxN10g
IGQzMjQ5Y2ZjIGIwM2UwNDRkIGU4MzIzZDEwIGIwNmUwMTNjIGQzMjQ5ZDE4IGIwMzU1ZmI5IGZm
ZmZmZmZlIGQzMjQ5ZDFjCmVlZXBjIGtlcm5lbDogWyAxNDk1LjQyOTAxN10gQ2FsbCBUcmFjZToK
ZWVlcGMga2VybmVsOiBbIDE0OTUuNDI5MDE3XSAgWzxiMDNlNzdhMT5dIHY0bDJfZGV2aWNlX2Rp
c2Nvbm5lY3QrMHgxMS8weDMwCmVlZXBjIGtlcm5lbDogWyAxNDk1LjQyOTAxN10gIFs8YjAzZTc3
ZDE+XSB2NGwyX2RldmljZV91bnJlZ2lzdGVyKzB4MTEvMHg1MAplZWVwYyBrZXJuZWw6IFsgMTQ5
NS40MjkwMTddICBbPGIwM2VkM2I3Pl0gdXZjX2RlbGV0ZSsweDM3LzB4MTEwCmVlZXBjIGtlcm5l
bDogWyAxNDk1LjQyOTAxN10gIFs8YjAzZWQ1NjU+XSB1dmNfcmVsZWFzZSsweDI1LzB4MzAKZWVl
cGMga2VybmVsOiBbIDE0OTUuNDI5MDE3XSAgWzxiMDNlMDQ0ZD5dIHY0bDJfZGV2aWNlX3JlbGVh
c2UrMHg5ZC8weGMwCmVlZXBjIGtlcm5lbDogWyAxNDk1LjQyOTAxN10gIFs8YjAzNTVmYjk+XSBk
ZXZpY2VfcmVsZWFzZSsweDE5LzB4OTAKZWVlcGMga2VybmVsOiBbIDE0OTUuNDI5MDE3XSAgWzxi
MDNhZGZkYz5dID8gdXNiX2hjZF91bmxpbmtfdXJiKzB4N2MvMHg5MAplZWVwYyBrZXJuZWw6IFsg
MTQ5NS40MjkwMTddICBbPGIwMjZiOTljPl0ga29iamVjdF9yZWxlYXNlKzB4M2MvMHg5MAplZWVw
YyBrZXJuZWw6IFsgMTQ5NS40MjkwMTddICBbPGIwMjZiOTYwPl0gPyBrb2JqZWN0X2RlbCsweDMw
LzB4MzAKZWVlcGMga2VybmVsOiBbIDE0OTUuNDI5MDE3XSAgWzxiMDI2Y2E0Yz5dIGtyZWZfcHV0
KzB4MmMvMHg2MAplZWVwYyBrZXJuZWw6IFsgMTQ5NS40MjkwMTddICBbPGIwMjZiODhkPl0ga29i
amVjdF9wdXQrMHgxZC8weDUwCmVlZXBjIGtlcm5lbDogWyAxNDk1LjQyOTAxN10gIFs8YjAzYjIz
ODU+XSA/IHVzYl9hdXRvcG1fcHV0X2ludGVyZmFjZSsweDI1LzB4MzAKZWVlcGMga2VybmVsOiBb
IDE0OTUuNDI5MDE3XSAgWzxiMDNmMGU1ZD5dID8gdXZjX3Y0bDJfcmVsZWFzZSsweDVkLzB4ZDAK
ZWVlcGMga2VybmVsOiBbIDE0OTUuNDI5MDE3XSAgWzxiMDM1NWQyZj5dIHB1dF9kZXZpY2UrMHhm
LzB4MjAKZWVlcGMga2VybmVsOiBbIDE0OTUuNDI5MDE3XSAgWzxiMDNkZmE5Nj5dIHY0bDJfcmVs
ZWFzZSsweDU2LzB4NjAKZWVlcGMga2VybmVsOiBbIDE0OTUuNDI5MDE3XSAgWzxiMDE5YzhkYz5d
IGZwdXQrMHhjYy8weDIyMAplZWVwYyBrZXJuZWw6IFsgMTQ5NS40MjkwMTddICBbPGIwMTk5MGY0
Pl0gZmlscF9jbG9zZSsweDQ0LzB4NzAKZWVlcGMga2VybmVsOiBbIDE0OTUuNDI5MDE3XSAgWzxi
MDEyYjIzOD5dIHB1dF9maWxlc19zdHJ1Y3QrMHgxNTgvMHgxODAKZWVlcGMga2VybmVsOiBbIDE0
OTUuNDI5MDE3XSAgWzxiMDEyYjEwMD5dID8gcHV0X2ZpbGVzX3N0cnVjdCsweDIwLzB4MTgwCmVl
ZXBjIGtlcm5lbDogWyAxNDk1LjQyOTAxN10gIFs8YjAxMmIyYTA+XSBleGl0X2ZpbGVzKzB4NDAv
MHg1MAplZWVwYyBrZXJuZWw6IFsgMTQ5NS40MjkwMTddICBbPGIwMTJiOWU3Pl0gZG9fZXhpdCsw
eDVhNy8weDY2MAplZWVwYyBrZXJuZWw6IFsgMTQ5NS40MjkwMTddICBbPGIwMTM1ZjcyPl0gPyBf
X2RlcXVldWVfc2lnbmFsKzB4MTIvMHgxMjAKZWVlcGMga2VybmVsOiBbIDE0OTUuNDI5MDE3XSAg
WzxiMDU1ZWRmMj5dID8gX3Jhd19zcGluX3VubG9ja19pcnErMHgyMi8weDMwCmVlZXBjIGtlcm5l
bDogWyAxNDk1LjQyOTAxN10gIFs8YjAxMmJhZGM+XSBkb19ncm91cF9leGl0KzB4M2MvMHhiMApl
ZWVwYyBrZXJuZWw6IFsgMTQ5NS40MjkwMTddICBbPGIwMTU3OTJiPl0gPyB0cmFjZV9oYXJkaXJx
c19vbisweGIvMHgxMAplZWVwYyBrZXJuZWw6IFsgMTQ5NS40MjkwMTddICBbPGIwMTM3NTVmPl0g
Z2V0X3NpZ25hbF90b19kZWxpdmVyKzB4MThmLzB4NTcwCmVlZXBjIGtlcm5lbDogWyAxNDk1LjQy
OTAxN10gIFs8YjAxMDIwZjc+XSBkb19zaWduYWwrMHg0Ny8weDllMAplZWVwYyBrZXJuZWw6IFsg
MTQ5NS40MjkwMTddICBbPGIwNTVlZGYyPl0gPyBfcmF3X3NwaW5fdW5sb2NrX2lycSsweDIyLzB4
MzAKZWVlcGMga2VybmVsOiBbIDE0OTUuNDI5MDE3XSAgWzxiMDE1NzkyYj5dID8gdHJhY2VfaGFy
ZGlycXNfb24rMHhiLzB4MTAKZWVlcGMga2VybmVsOiBbIDE0OTUuNDI5MDE3XSAgWzxiMDEyMzMw
MD5dID8gVC4xMDM0KzB4MzAvMHhjMAplZWVwYyBrZXJuZWw6IFsgMTQ5NS40MjkwMTddICBbPGIw
NTVjNDVmPl0gPyBzY2hlZHVsZSsweDI5Zi8weDY0MAplZWVwYyBrZXJuZWw6IFsgMTQ5NS40Mjkw
MTddICBbPGIwMTAyYWM4Pl0gZG9fbm90aWZ5X3Jlc3VtZSsweDM4LzB4NDAKZWVlcGMga2VybmVs
OiBbIDE0OTUuNDI5MDE3XSAgWzxiMDU1ZjE1ND5dIHdvcmtfbm90aWZ5c2lnKzB4OS8weDExCmVl
ZXBjIGtlcm5lbDogWyAxNDk1LjQyOTAxN10gQ29kZTogZTUgNWQgODMgZjggMDEgMTkgYzAgZjcg
ZDAgODMgZTAgZjAgYzMgOGQgYjQgMjYgMDAgMDAgMDAgMDAgNTUgODUgYzAgODkgZTUgNzUgMDkg
MzEgYzAgNWQgYzMgOTAgOGQgNzQgMjYgMDAgOGIgNDAgMDQgODUgYzAgNzQgZjAgPDhiPiA0MCA2
MCA1ZCBjMyA4ZCA3NCAyNiAwMCA1NSA4OSBlNSA1MyA4OSBjMyA4MyBlYyAwNCA4YiA0MCAwNCAK
ZWVlcGMga2VybmVsOiBbIDE0OTUuNDI5MDE3XSBFSVA6IFs8YjAzNThkMzc+XSBkZXZfZ2V0X2Ry
dmRhdGErMHgxNy8weDIwIFNTOkVTUCAwMDY4OmQzMjQ5Y2FjCmVlZXBjIGtlcm5lbDogWyAxNDk1
LjQyOTAxN10gQ1IyOiAwMDAwMDAwMDZiNmI2YmNiCmVlZXBjIGtlcm5lbDogWyAxNDk1LjQ2Njk3
NV0gdXZjdmlkZW86IEZhaWxlZCB0byByZXN1Ym1pdCB2aWRlbyBVUkIgKC0yNykuCmVlZXBjIGtl
cm5lbDogWyAxNDk1LjQ2Nzg2MF0gdXZjdmlkZW86IEZhaWxlZCB0byByZXN1Ym1pdCB2aWRlbyBV
UkIgKC0yNykuCmVlZXBjIGtlcm5lbDogbGFzdCBtZXNzYWdlIHJlcGVhdGVkIDMgdGltZXMKZWVl
cGMga2VybmVsOiBbIDE0OTUuNTEyNjEwXSAtLS1bIGVuZCB0cmFjZSA3M2VjMTY4NDg3OTRlNWE1
IF0tLS0KCkZvciB1dmMgZGV2aWNlLCBkZXYtPnZkZXYuZGV2IGlzIHRoZSAmaW50Zi0+ZGV2LAp1
dmNfZGVsZXRlIGNvZGUgaXMgYXMgYmVsb3c6Cgl1c2JfcHV0X2ludGYoZGV2LT5pbnRmKTsKCXVz
Yl9wdXRfZGV2KGRldi0+dWRldik7CgoJdXZjX3N0YXR1c19jbGVhbnVwKGRldik7Cgl1dmNfY3Ry
bF9jbGVhbnVwX2RldmljZShkZXYpOwoKIyMgdGhlIGludGYgZGV2IGlzIHJlbGVhc2VkIGFib3Zl
LCBzbyBiZWxvdyBjb2RlIHdpbGwgb29wcy4KCglpZiAoZGV2LT52ZGV2LmRldikKCQl2NGwyX2Rl
dmljZV91bnJlZ2lzdGVyKCZkZXYtPnZkZXYpOwoKRml4IGl0IGJ5IGdldF9kZXZpY2UgaW4gdjRs
Ml9kZXZpY2VfcmVnaXN0ZXIgYW5kIHB1dF9kZXZpY2UgaW4gdjRsMl9kZXZpY2VfZGlzY29ubmVj
dAotLS0KIGRyaXZlcnMvbWVkaWEvdmlkZW8vdjRsMi1kZXZpY2UuYyB8ICAgIDIgKysKIDEgZmls
ZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKykKCmRpZmYgLS1naXQgYS9kcml2ZXJzL21lZGlhL3Zp
ZGVvL3Y0bDItZGV2aWNlLmMgYi9kcml2ZXJzL21lZGlhL3ZpZGVvL3Y0bDItZGV2aWNlLmMKaW5k
ZXggYzcyODU2Yy4uZTZhMmMzYiAxMDA2NDQKLS0tIGEvZHJpdmVycy9tZWRpYS92aWRlby92NGwy
LWRldmljZS5jCisrKyBiL2RyaXZlcnMvbWVkaWEvdmlkZW8vdjRsMi1kZXZpY2UuYwpAQCAtMzgs
NiArMzgsNyBAQCBpbnQgdjRsMl9kZXZpY2VfcmVnaXN0ZXIoc3RydWN0IGRldmljZSAqZGV2LCBz
dHJ1Y3QgdjRsMl9kZXZpY2UgKnY0bDJfZGV2KQogCW11dGV4X2luaXQoJnY0bDJfZGV2LT5pb2N0
bF9sb2NrKTsKIAl2NGwyX3ByaW9faW5pdCgmdjRsMl9kZXYtPnByaW8pOwogCWtyZWZfaW5pdCgm
djRsMl9kZXYtPnJlZik7CisJZ2V0X2RldmljZShkZXYpOwogCXY0bDJfZGV2LT5kZXYgPSBkZXY7
CiAJaWYgKGRldiA9PSBOVUxMKSB7CiAJCS8qIElmIGRldiA9PSBOVUxMLCB0aGVuIG5hbWUgbXVz
dCBiZSBmaWxsZWQgaW4gYnkgdGhlIGNhbGxlciAqLwpAQCAtOTMsNiArOTQsNyBAQCB2b2lkIHY0
bDJfZGV2aWNlX2Rpc2Nvbm5lY3Qoc3RydWN0IHY0bDJfZGV2aWNlICp2NGwyX2RldikKIAogCWlm
IChkZXZfZ2V0X2RydmRhdGEodjRsMl9kZXYtPmRldikgPT0gdjRsMl9kZXYpCiAJCWRldl9zZXRf
ZHJ2ZGF0YSh2NGwyX2Rldi0+ZGV2LCBOVUxMKTsKKwlwdXRfZGV2aWNlKHY0bDJfZGV2LT5kZXYp
OwogCXY0bDJfZGV2LT5kZXYgPSBOVUxMOwogfQogRVhQT1JUX1NZTUJPTF9HUEwodjRsMl9kZXZp
Y2VfZGlzY29ubmVjdCk7Cg==
--20cf300fabc96f681b04abdd8229--
