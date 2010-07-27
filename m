Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756259Ab0G0L27 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 07:28:59 -0400
Received: from fold.natur.cuni.cz ([195.113.57.32]:37023 "HELO
	fold.natur.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756049Ab0G0L25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 07:28:57 -0400
Message-ID: <4C4EC2F4.9040906@ribosome.natur.cuni.cz>
Date: Tue, 27 Jul 2010 13:28:52 +0200
From: Martin Mokrejs <mmokrejs@ribosome.natur.cuni.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100516 Gentoo/2.0.4-r1 SeaMonkey/2.0.4
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Dave Airlie <airlied@linux.ie>
Subject: Re: 2.6.34 and 2.6.35-rc6-git2: kernel crash downstream of generic_file_aio_write
 and i830_swap_bufs
References: <4C4EBC8E.40703@ribosome.natur.cuni.cz>
In-Reply-To: <4C4EBC8E.40703@ribosome.natur.cuni.cz>
X-Enigmail-Version: 1.0.1
Content-Type: multipart/mixed;
 boundary="------------000200030500060209080401"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000200030500060209080401
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

For completeness I am attaching the output from X server.
M.

Martin Mokrejs wrote:
> Hi,
>   I have a kernel crash with _intel_ drm driver on Acer LCi291 laptop with builtin Intel 855GM card
> when I start /usr/bin/X (it does work when "vesa" instead of "intel" drm driver is called from
> xorg.conf, though).
 
[cut]

> Here is a crash with 2.6.35-rc6-git2 as well:
> [cut]
> [    5.074544] agpgart-intel 0000:00:00.0: Intel 855GM Chipset
> [    5.075090] agpgart-intel 0000:00:00.0: detected 16252K stolen memory
> [    5.077817] agpgart-intel 0000:00:00.0: AGP aperture is 128M @ 0xb0000000
> [cut]
> [   57.952849] BUG: unable to handle kernel NULL pointer dereference at (null)
> [   57.952863] IP: [<efae80bc>] i830_swap_bufs+0x2a/0x2ab [i830]
> [   57.952885] *pde = 00000000 
> [   57.952893] Oops: 0000 [#1] 
> [   57.952901] last sysfs file: /sys/devices/pci0000:00/0000:00:02.1/resource
> [   57.952910] Modules linked in: i830 firewire_ohci snd_intel8x0m ipw2100 snd_intel8x0 irda parport_pc parport intel_agp firewire_core snd_ac97_codec libipw i2c_i801 rtc_cmos ac97_bus
> [   57.952948] 
> [   57.952959] Pid: 5345, comm: X Not tainted 2.6.35-rc6-git2 #1 855GM      /TravelMate 290           
> [   57.952970] EIP: 0060:[<efae80bc>] EFLAGS: 00213246 CPU: 0
> [   57.952982] EIP is at i830_swap_bufs+0x2a/0x2ab [i830]
> [   57.952991] EAX: 00000000 EBX: ed038a20 ECX: ed038a20 EDX: ed038a80
> [   57.953001] ESI: ed24ec00 EDI: 00000046 EBP: ee233e70 ESP: ee233e34
> [   57.953010]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
> [   57.953021] Process X (pid: 5345, ti=ee232000 task=ee03dd40 task.ti=ee232000)
> [   57.953028] Stack:
> [   57.953033]  00000001 efae9e65 efae9b50 efaea1d5 00000000 ee233f20 ee233f18 ed24ec00
> [   57.953050] <0> c11106d7 ee233e70 c111070a ee233e8c ed038a20 ed24ec00 00000046 ee233f18
> [   57.953068] <0> c11765f5 bfc15960 efae8092 efaea774 c0086446 ee233e8c 00000005 bfc1596c
> [   57.953087] Call Trace:
> [   57.953104]  [<c11106d7>] ? might_fault+0x8/0xa
> [   57.953116]  [<c111070a>] ? _copy_from_user+0x31/0x115
> [   57.953131]  [<c11765f5>] ? drm_ioctl+0x211/0x2a1
> [   57.953145]  [<efae8092>] ? i830_swap_bufs+0x0/0x2ab [i830]
> [   57.953160]  [<c104d7f0>] ? generic_file_aio_write+0x87/0x9e
> [   57.953175]  [<c1069e09>] ? do_sync_write+0x89/0xc4
> [   57.953187]  [<c11763e4>] ? drm_ioctl+0x0/0x2a1
> [   57.953200]  [<c1073241>] ? vfs_ioctl+0x15/0x49
> [   57.953212]  [<c1073724>] ? do_vfs_ioctl+0x40b/0x43f
> [   57.953225]  [<c1069bd0>] ? fsnotify_modify+0x4f/0x5a
> [   57.953237]  [<c1069d80>] ? do_sync_write+0x0/0xc4
> [   57.953248]  [<c106a5c9>] ? vfs_write+0x98/0xac
> [   57.953260]  [<c1073786>] ? sys_ioctl+0x2e/0x48
> [   57.953273]  [<c1002510>] ? sysenter_do_call+0x12/0x26
> [   57.953280] Code: c3 55 89 e5 57 56 53 83 ec 20 89 45 e0 89 cb 68 d5 a1 ae ef 68 50 9b ae ef 68 65 9e ae ef 6a 01 e8 c8 19 69 d1 8b 53 40 8b 42 3c <8b> 08 83 c4 10 85 c9 79 05 39 5a 40 74 2d 8b 00 53 ff 72 40 25 
> [   57.953370] EIP: [<efae80bc>] i830_swap_bufs+0x2a/0x2ab [i830] SS:ESP 0068:ee233e34
> [   57.953387] CR2: 0000000000000000
> [   57.953396] ---[ end trace 9e76fe13d3edd6f6 ]---
> [   57.957541] [drm:drm_release] *ERROR* Device busy: 1

--------------000200030500060209080401
Content-Type: text/plain;
 name="Xorg.log"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="Xorg.log"

KElJKSBjb25maWcvaGFsOiBpbml0aWFsaXplZApYLk9yZyBYIFNlcnZlciAxLjcuNgpSZWxl
YXNlIERhdGU6IDIwMTAtMDMtMTcKWCBQcm90b2NvbCBWZXJzaW9uIDExLCBSZXZpc2lvbiAw
CkJ1aWxkIE9wZXJhdGluZyBTeXN0ZW06IExpbnV4IDIuNi4zNS1yYzYtZ2l0MiBpNjg2IApD
dXJyZW50IE9wZXJhdGluZyBTeXN0ZW06IExpbnV4IGFjZXIgMi42LjM1LXJjNi1naXQyICMy
IFR1ZSBKdWwgMjcgMTM6MTk6NTAgTUVTVCAyMDEwIGk2ODYKS2VybmVsIGNvbW1hbmQgbGlu
ZTogcm9vdD0vZGV2L3NkYTMgdWRldgpCdWlsZCBEYXRlOiAyNyBKdWx5IDIwMTAgIDAxOjEw
OjI5UE0KIApDdXJyZW50IHZlcnNpb24gb2YgcGl4bWFuOiAwLjE4LjIKCUJlZm9yZSByZXBv
cnRpbmcgcHJvYmxlbXMsIGNoZWNrIGh0dHA6Ly93aWtpLngub3JnCgl0byBtYWtlIHN1cmUg
dGhhdCB5b3UgaGF2ZSB0aGUgbGF0ZXN0IHZlcnNpb24uCk1hcmtlcnM6ICgtLSkgcHJvYmVk
LCAoKiopIGZyb20gY29uZmlnIGZpbGUsICg9PSkgZGVmYXVsdCBzZXR0aW5nLAoJKCsrKSBm
cm9tIGNvbW1hbmQgbGluZSwgKCEhKSBub3RpY2UsIChJSSkgaW5mb3JtYXRpb25hbCwKCShX
Vykgd2FybmluZywgKEVFKSBlcnJvciwgKE5JKSBub3QgaW1wbGVtZW50ZWQsICg/PykgdW5r
bm93bi4KKD09KSBMb2cgZmlsZTogIi92YXIvbG9nL1hvcmcuMC5sb2ciLCBUaW1lOiBUdWUg
SnVsIDI3IDEzOjI1OjM1IDIwMTAKKD09KSBVc2luZyBjb25maWcgZmlsZTogIi9ldGMvWDEx
L3hvcmcuY29uZiIKKD09KSBTZXJ2ZXJMYXlvdXQgIlNpbXBsZSBMYXlvdXQiCigqKikgfC0t
PlNjcmVlbiAiU2NyZWVuQmVsaW5lYUxDRCIgKDApCigqKikgfCAgIHwtLT5Nb25pdG9yICJC
ZWxpbmVhTENEIgooKiopIHwgICB8LS0+RGV2aWNlICJyYWRlb243NTAwTSIKKCoqKSBPcHRp
b24gIk5vVHJhcFNpZ25hbHMiCigqKikgT3B0aW9uICJBbGxvd0VtcHR5SW5wdXQiICJ5ZXMi
Cig9PSkgQXV0b21hdGljYWxseSBhZGRpbmcgZGV2aWNlcwooPT0pIEF1dG9tYXRpY2FsbHkg
ZW5hYmxpbmcgZGV2aWNlcwooV1cpIFRoZSBkaXJlY3RvcnkgIi91c3Ivc2hhcmUvZm9udHMv
VFRGLyIgZG9lcyBub3QgZXhpc3QuCglFbnRyeSBkZWxldGVkIGZyb20gZm9udCBwYXRoLgoo
V1cpIFRoZSBkaXJlY3RvcnkgIi91c3Ivc2hhcmUvZm9udHMvVHlwZTEvIiBkb2VzIG5vdCBl
eGlzdC4KCUVudHJ5IGRlbGV0ZWQgZnJvbSBmb250IHBhdGguCihXVykgYGZvbnRzLmRpcicg
bm90IGZvdW5kIChvciBub3QgdmFsaWQpIGluICIvdXNyL3NoYXJlL2ZvbnRzLzc1ZHBpLyIu
CglFbnRyeSBkZWxldGVkIGZyb20gZm9udCBwYXRoLgoJKFJ1biAnbWtmb250ZGlyJyBvbiAi
L3Vzci9zaGFyZS9mb250cy83NWRwaS8iKS4KKFdXKSBUaGUgZGlyZWN0b3J5ICIvdXNyL3No
YXJlL2ZvbnRzL1RURi8iIGRvZXMgbm90IGV4aXN0LgoJRW50cnkgZGVsZXRlZCBmcm9tIGZv
bnQgcGF0aC4KKFdXKSBUaGUgZGlyZWN0b3J5ICIvdXNyL3NoYXJlL2ZvbnRzL09URiIgZG9l
cyBub3QgZXhpc3QuCglFbnRyeSBkZWxldGVkIGZyb20gZm9udCBwYXRoLgooV1cpIFRoZSBk
aXJlY3RvcnkgIi91c3Ivc2hhcmUvZm9udHMvVHlwZTEvIiBkb2VzIG5vdCBleGlzdC4KCUVu
dHJ5IGRlbGV0ZWQgZnJvbSBmb250IHBhdGguCihXVykgYGZvbnRzLmRpcicgbm90IGZvdW5k
IChvciBub3QgdmFsaWQpIGluICIvdXNyL3NoYXJlL2ZvbnRzLzc1ZHBpLyIuCglFbnRyeSBk
ZWxldGVkIGZyb20gZm9udCBwYXRoLgoJKFJ1biAnbWtmb250ZGlyJyBvbiAiL3Vzci9zaGFy
ZS9mb250cy83NWRwaS8iKS4KKCoqKSBGb250UGF0aCBzZXQgdG86CgkvdXNyL3NoYXJlL2Zv
bnRzL21pc2MvLAoJL3Vzci9zaGFyZS9mb250cy8xMDBkcGkvLAoJL3Vzci9zaGFyZS9mb250
cy9taXNjLywKCS91c3Ivc2hhcmUvZm9udHMvMTAwZHBpLwooPT0pIE1vZHVsZVBhdGggc2V0
IHRvICIvdXNyL2xpYi94b3JnL21vZHVsZXMiCihJSSkgQ2Fubm90IGxvY2F0ZSBhIGNvcmUg
cG9pbnRlciBkZXZpY2UuCihJSSkgQ2Fubm90IGxvY2F0ZSBhIGNvcmUga2V5Ym9hcmQgZGV2
aWNlLgooSUkpIFRoZSBzZXJ2ZXIgcmVsaWVzIG9uIEhBTCB0byBwcm92aWRlIHRoZSBsaXN0
IG9mIGlucHV0IGRldmljZXMuCglJZiBubyBkZXZpY2VzIGJlY29tZSBhdmFpbGFibGUsIHJl
Y29uZmlndXJlIEhBTCBvciBkaXNhYmxlIEF1dG9BZGREZXZpY2VzLgooSUkpIExvYWRlciBt
YWdpYzogMHg4MWQ2OTIwCihJSSkgTW9kdWxlIEFCSSB2ZXJzaW9uczoKCVguT3JnIEFOU0kg
QyBFbXVsYXRpb246IDAuNAoJWC5PcmcgVmlkZW8gRHJpdmVyOiA2LjAKCVguT3JnIFhJbnB1
dCBkcml2ZXIgOiA3LjAKCVguT3JnIFNlcnZlciBFeHRlbnNpb24gOiAyLjAKKC0tKSB1c2lu
ZyBWVCBudW1iZXIgOQoKKC0tKSBQQ0k6KigwOjA6MjowKSA4MDg2OjM1ODI6MTAyNTowMDNk
IEludGVsIENvcnBvcmF0aW9uIDgyODUyLzg1NUdNIEludGVncmF0ZWQgR3JhcGhpY3MgRGV2
aWNlIHJldiAyLCBNZW0gQCAweGIwMDAwMDAwLzEzNDIxNzcyOCwgMHhmMDAwMDAwMC81MjQy
ODgsIEkvTyBAIDB4MDAwMGUwMDAvOAooLS0pIFBDSTogKDA6MDoyOjEpIDgwODY6MzU4Mjox
MDI1OjAwM2QgSW50ZWwgQ29ycG9yYXRpb24gODI4NTIvODU1R00gSW50ZWdyYXRlZCBHcmFw
aGljcyBEZXZpY2UgcmV2IDIsIE1lbSBAIDB4MzAwMDAwMDAvMTM0MjE3NzI4LCAweDM4MDAw
MDAwLzUyNDI4OAooSUkpIE9wZW4gQUNQSSBzdWNjZXNzZnVsICgvdmFyL3J1bi9hY3BpZC5z
b2NrZXQpCihJSSkgImV4dG1vZCIgd2lsbCBiZSBsb2FkZWQgYnkgZGVmYXVsdC4KKElJKSAi
ZGJlIiB3aWxsIGJlIGxvYWRlZCBieSBkZWZhdWx0LgooSUkpICJnbHgiIHdpbGwgYmUgbG9h
ZGVkLiBUaGlzIHdhcyBlbmFibGVkIGJ5IGRlZmF1bHQgYW5kIGFsc28gc3BlY2lmaWVkIGlu
IHRoZSBjb25maWcgZmlsZS4KKElJKSAicmVjb3JkIiB3aWxsIGJlIGxvYWRlZCBieSBkZWZh
dWx0LgooSUkpICJkcmkiIHdpbGwgYmUgbG9hZGVkLiBUaGlzIHdhcyBlbmFibGVkIGJ5IGRl
ZmF1bHQgYW5kIGFsc28gc3BlY2lmaWVkIGluIHRoZSBjb25maWcgZmlsZS4KKElJKSAiZHJp
MiIgd2lsbCBiZSBsb2FkZWQgYnkgZGVmYXVsdC4KKElJKSBMb2FkTW9kdWxlOiAiZ2x4Igoo
SUkpIExvYWRpbmcgL3Vzci9saWIveG9yZy9tb2R1bGVzL2V4dGVuc2lvbnMvbGliZ2x4LnNv
CihJSSkgTW9kdWxlIGdseDogdmVuZG9yPSJYLk9yZyBGb3VuZGF0aW9uIgoJY29tcGlsZWQg
Zm9yIDEuNy42LCBtb2R1bGUgdmVyc2lvbiA9IDEuMC4wCglBQkkgY2xhc3M6IFguT3JnIFNl
cnZlciBFeHRlbnNpb24sIHZlcnNpb24gMi4wCig9PSkgQUlHTFggZW5hYmxlZAooSUkpIExv
YWRpbmcgZXh0ZW5zaW9uIEdMWAooSUkpIExvYWRNb2R1bGU6ICJkcmkiCihJSSkgTG9hZGlu
ZyAvdXNyL2xpYi94b3JnL21vZHVsZXMvZXh0ZW5zaW9ucy9saWJkcmkuc28KKElJKSBNb2R1
bGUgZHJpOiB2ZW5kb3I9IlguT3JnIEZvdW5kYXRpb24iCgljb21waWxlZCBmb3IgMS43LjYs
IG1vZHVsZSB2ZXJzaW9uID0gMS4wLjAKCUFCSSBjbGFzczogWC5PcmcgU2VydmVyIEV4dGVu
c2lvbiwgdmVyc2lvbiAyLjAKKElJKSBMb2FkaW5nIGV4dGVuc2lvbiBYRnJlZTg2LURSSQoo
SUkpIExvYWRNb2R1bGU6ICJleHRtb2QiCihJSSkgTG9hZGluZyAvdXNyL2xpYi94b3JnL21v
ZHVsZXMvZXh0ZW5zaW9ucy9saWJleHRtb2Quc28KKElJKSBNb2R1bGUgZXh0bW9kOiB2ZW5k
b3I9IlguT3JnIEZvdW5kYXRpb24iCgljb21waWxlZCBmb3IgMS43LjYsIG1vZHVsZSB2ZXJz
aW9uID0gMS4wLjAKCU1vZHVsZSBjbGFzczogWC5PcmcgU2VydmVyIEV4dGVuc2lvbgoJQUJJ
IGNsYXNzOiBYLk9yZyBTZXJ2ZXIgRXh0ZW5zaW9uLCB2ZXJzaW9uIDIuMAooSUkpIExvYWRp
bmcgZXh0ZW5zaW9uIE1JVC1TQ1JFRU4tU0FWRVIKKElJKSBMb2FkaW5nIGV4dGVuc2lvbiBY
RnJlZTg2LVZpZE1vZGVFeHRlbnNpb24KKElJKSBMb2FkaW5nIGV4dGVuc2lvbiBYRnJlZTg2
LURHQQooSUkpIExvYWRpbmcgZXh0ZW5zaW9uIERQTVMKKElJKSBMb2FkaW5nIGV4dGVuc2lv
biBYVmlkZW8KKElJKSBMb2FkaW5nIGV4dGVuc2lvbiBYVmlkZW8tTW90aW9uQ29tcGVuc2F0
aW9uCihJSSkgTG9hZGluZyBleHRlbnNpb24gWC1SZXNvdXJjZQooSUkpIExvYWRNb2R1bGU6
ICJkYmUiCihJSSkgTG9hZGluZyAvdXNyL2xpYi94b3JnL21vZHVsZXMvZXh0ZW5zaW9ucy9s
aWJkYmUuc28KKElJKSBNb2R1bGUgZGJlOiB2ZW5kb3I9IlguT3JnIEZvdW5kYXRpb24iCglj
b21waWxlZCBmb3IgMS43LjYsIG1vZHVsZSB2ZXJzaW9uID0gMS4wLjAKCU1vZHVsZSBjbGFz
czogWC5PcmcgU2VydmVyIEV4dGVuc2lvbgoJQUJJIGNsYXNzOiBYLk9yZyBTZXJ2ZXIgRXh0
ZW5zaW9uLCB2ZXJzaW9uIDIuMAooSUkpIExvYWRpbmcgZXh0ZW5zaW9uIERPVUJMRS1CVUZG
RVIKKElJKSBMb2FkTW9kdWxlOiAicmVjb3JkIgooSUkpIExvYWRpbmcgL3Vzci9saWIveG9y
Zy9tb2R1bGVzL2V4dGVuc2lvbnMvbGlicmVjb3JkLnNvCihJSSkgTW9kdWxlIHJlY29yZDog
dmVuZG9yPSJYLk9yZyBGb3VuZGF0aW9uIgoJY29tcGlsZWQgZm9yIDEuNy42LCBtb2R1bGUg
dmVyc2lvbiA9IDEuMTMuMAoJTW9kdWxlIGNsYXNzOiBYLk9yZyBTZXJ2ZXIgRXh0ZW5zaW9u
CglBQkkgY2xhc3M6IFguT3JnIFNlcnZlciBFeHRlbnNpb24sIHZlcnNpb24gMi4wCihJSSkg
TG9hZGluZyBleHRlbnNpb24gUkVDT1JECihJSSkgTG9hZE1vZHVsZTogImRyaTIiCihJSSkg
TG9hZGluZyAvdXNyL2xpYi94b3JnL21vZHVsZXMvZXh0ZW5zaW9ucy9saWJkcmkyLnNvCihJ
SSkgTW9kdWxlIGRyaTI6IHZlbmRvcj0iWC5PcmcgRm91bmRhdGlvbiIKCWNvbXBpbGVkIGZv
ciAxLjcuNiwgbW9kdWxlIHZlcnNpb24gPSAxLjEuMAoJQUJJIGNsYXNzOiBYLk9yZyBTZXJ2
ZXIgRXh0ZW5zaW9uLCB2ZXJzaW9uIDIuMAooSUkpIExvYWRpbmcgZXh0ZW5zaW9uIERSSTIK
KElJKSBMb2FkTW9kdWxlOiAiaW50ZWwiCihJSSkgTG9hZGluZyAvdXNyL2xpYi94b3JnL21v
ZHVsZXMvZHJpdmVycy9pbnRlbF9kcnYuc28KKElJKSBNb2R1bGUgaW50ZWw6IHZlbmRvcj0i
WC5PcmcgRm91bmRhdGlvbiIKCWNvbXBpbGVkIGZvciAxLjcuNiwgbW9kdWxlIHZlcnNpb24g
PSAyLjkuMQoJTW9kdWxlIGNsYXNzOiBYLk9yZyBWaWRlbyBEcml2ZXIKCUFCSSBjbGFzczog
WC5PcmcgVmlkZW8gRHJpdmVyLCB2ZXJzaW9uIDYuMAooSUkpIGludGVsOiBEcml2ZXIgZm9y
IEludGVsIEludGVncmF0ZWQgR3JhcGhpY3MgQ2hpcHNldHM6IGk4MTAsCglpODEwLWRjMTAw
LCBpODEwZSwgaTgxNSwgaTgzME0sIDg0NUcsIDg1MkdNLzg1NUdNLCA4NjVHLCA5MTVHLAoJ
RTcyMjEgKGk5MTUpLCA5MTVHTSwgOTQ1RywgOTQ1R00sIDk0NUdNRSwgUGluZXZpZXcgR00s
IFBpbmV2aWV3IEcsCgk5NjVHLCBHMzUsIDk2NVEsIDk0NkdaLCA5NjVHTSwgOTY1R01FL0dM
RSwgRzMzLCBRMzUsIFEzMywgR000NSwKCTQgU2VyaWVzLCBHNDUvRzQzLCBRNDUvUTQzLCBH
NDEsIEI0MywgQ2xhcmtkYWxlLCBBcnJhbmRhbGUKKElJKSBQcmltYXJ5IERldmljZSBpczog
UENJIDAwQDAwOjAyOjAKKElJKSBMb2FkaW5nIHN1YiBtb2R1bGUgInZnYWh3IgooSUkpIExv
YWRNb2R1bGU6ICJ2Z2FodyIKKElJKSBMb2FkaW5nIC91c3IvbGliL3hvcmcvbW9kdWxlcy9s
aWJ2Z2Fody5zbwooSUkpIE1vZHVsZSB2Z2FodzogdmVuZG9yPSJYLk9yZyBGb3VuZGF0aW9u
IgoJY29tcGlsZWQgZm9yIDEuNy42LCBtb2R1bGUgdmVyc2lvbiA9IDAuMS4wCglBQkkgY2xh
c3M6IFguT3JnIFZpZGVvIERyaXZlciwgdmVyc2lvbiA2LjAKKElJKSBMb2FkaW5nIHN1YiBt
b2R1bGUgInJhbWRhYyIKKElJKSBMb2FkTW9kdWxlOiAicmFtZGFjIgooSUkpIE1vZHVsZSAi
cmFtZGFjIiBhbHJlYWR5IGJ1aWx0LWluCmRybU9wZW5EZXZpY2U6IG5vZGUgbmFtZSBpcyAv
ZGV2L2RyaS9jYXJkMApkcm1PcGVuRGV2aWNlOiBvcGVuIHJlc3VsdCBpcyAxMCwgKE9LKQpk
cm1PcGVuQnlCdXNpZDogU2VhcmNoaW5nIGZvciBCdXNJRCBwY2k6MDAwMDowMDowMi4wCmRy
bU9wZW5EZXZpY2U6IG5vZGUgbmFtZSBpcyAvZGV2L2RyaS9jYXJkMApkcm1PcGVuRGV2aWNl
OiBvcGVuIHJlc3VsdCBpcyAxMCwgKE9LKQpkcm1PcGVuQnlCdXNpZDogZHJtT3Blbk1pbm9y
IHJldHVybnMgMTAKZHJtT3BlbkJ5QnVzaWQ6IGRybUdldEJ1c2lkIHJlcG9ydHMgcGNpOjAw
MDA6MDA6MDIuMApLaWxsZWQK
--------------000200030500060209080401--
