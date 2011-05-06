Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599Ab1EFImF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 04:42:05 -0400
Received: from eriks.xs4all.nl ([83.160.41.216]:50651 "EHLO eriks.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754065Ab1EFIl7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 04:41:59 -0400
X-Greylist: delayed 877 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 May 2011 04:41:58 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws; d=slagter.name; h=message-id
	:date:from:mime-version:to:subject:content-type; q=dns; s=
	2007072601; b=geHeEfBsAqJ+Q44+Ld56OQbnfjkU6L9udEgoCn11orJLaxQtu8
	7tVWY1kwwXap/6AGrXQUNGuPGF+AJfYZ2/kohWqvlib41R+WzS5ZHErZR+iryC+s
	k4G7DiwZra/dErgnml8U6eR/giLzN8lx2TIJB7wo4u0VwL9P69OiL3IEQ=
Message-ID: <4DC3B0E3.7010008@slagter.name>
Date: Fri, 06 May 2011 10:27:15 +0200
From: Erik Slagter <erik@slagter.name>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Mnenhy/0.8.3 Thunderbird/3.1.10 ThunderBrowse/3.3.5
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: OOPS after connection Droids MuIn USB display
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms010309000207060500040407"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms010309000207060500040407
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

(following Richard Goochs template bug report)

(please CC me because I am not subscribed)

(thanks in advance for looking into this!)

1. OOPS after connection Droids MuIn USB display

2. I recently bought this display:=20
http://www.droids.it/cmsvb4/content.php?233-990.014-MuIn-LCD_overview It =

presents itself as a "communication" class USB device. After plugin, the =

kernel gives an oops. The kernel keeps running, other USB devices=20
continue to work, but at least any lsusb started keeps hanging in "D"=20
state. There is no additional kernel logging about the lsusb hanging.

3. OOPS insert usb acm device

4. Linux version 2.6.38.2 (erik@skylla) (gcc version 4.5.1 20100924 (Red =

Hat 4.5.1-4) (GCC) ) #3 SMP Fri Apr 22 17:31:06 CEST 2011

This is a vanilla kernel on x86-64. The fedora kernel gives the oops as=20
well, though.

5. --------------- >-8 ---------------------

usb 2-1.3: new full speed USB device using ehci_hcd and address 111
usb 2-1.3: New USB device found, idVendor=3D04d8, idProduct=3D000b
usb 2-1.3: New USB device strings: Mfr=3D1, Product=3D2, SerialNumber=3D0=

usb 2-1.3: Product: VCOM
usb 2-1.3: Manufacturer: DROIDS
cdc_acm 2-1.3:1.0: This device cannot do calls on its own. It is not a=20
modem.
BUG: unable to handle kernel NULL pointer dereference at 0000000000000008=

IP: [<ffffffff815f64e7>] acm_probe+0x157/0xcb0
PGD 0
Oops: 0000 [#1] SMP
last sysfs file: /sys/devices/pci0000:00/0000:00:1d.7/usb2/idVendor
CPU 0
Modules linked in: [last unloaded: scsi_wait_scan]

Pid: 19, comm: khubd Tainted: G        W   2.6.38.2 #3 Dell Inc. XPS=20
M1330
RIP: 0010:[<ffffffff815f64e7>]  [<ffffffff815f64e7>] acm_probe+0x157/0xcb=
0
RSP: 0018:ffff88011fdf59c0  EFLAGS: 00010286
RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffff8800cd803000
RDX: 0000000000000001 RSI: 0000000000000001 RDI: ffff88011bb8d800
RBP: ffff8800cd803400 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000001 R12: ffff8800cd803400
R13: 0000000000000000 R14: ffff88011bb8d888 R15: ffff8800cd803430
FS:  0000000000000000(0000) GS:ffff8800df400000(0000) knlGS:0000000000000=
000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000008 CR3: 0000000001cb1000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process khubd (pid: 19, threadinfo ffff88011fdf4000, task ffff88011fca964=
0)
Stack:
ffff8800cd86b200 ffffffff81120a09 ffff88011fdf5a30 ffff88011bb8d888
0000000000000000 0000000000000001 0000000000000000 ffff88011bb8d800
0000000000000206 0000000000000000 ffffffff00000010 0000000000000246
Call Trace:
[<ffffffff81120a09>] ? sysfs_addrm_finish+0x29/0xe0
[<ffffffff815cff9e>] ? usb_probe_interface+0x10e/0x210
[<ffffffff81431ef6>] ? driver_probe_device+0x96/0x1b0
[<ffffffff814320b0>] ? __device_attach+0x0/0x60
[<ffffffff81430c1c>] ? bus_for_each_drv+0x5c/0x90
[<ffffffff81431d9f>] ? device_attach+0x8f/0xb0
[<ffffffff814315cd>] ? bus_probe_device+0x2d/0x50
[<ffffffff8142f4ca>] ? device_add+0x5ba/0x690
[<ffffffff815ce574>] ? usb_set_configuration+0x5b4/0x690
[<ffffffff81121722>] ? sysfs_do_create_link+0xe2/0x220
[<ffffffff815d733b>] ? generic_probe+0x3b/0xa0
[<ffffffff81431ef6>] ? driver_probe_device+0x96/0x1b0
[<ffffffff814320b0>] ? __device_attach+0x0/0x60
[<ffffffff81430c1c>] ? bus_for_each_drv+0x5c/0x90
[<ffffffff81431d9f>] ? device_attach+0x8f/0xb0
[<ffffffff814315cd>] ? bus_probe_device+0x2d/0x50
[<ffffffff8142f4ca>] ? device_add+0x5ba/0x690
[<ffffffff815c72f9>] ? usb_new_device+0xe9/0x130
[<ffffffff815c85a0>] ? hub_thread+0xba0/0x10d0
[<ffffffff810337a0>] ? enqueue_task_fair+0x160/0x1a0
[<ffffffff81058580>] ? autoremove_wake_function+0x0/0x30
[<ffffffff815c7a00>] ? hub_thread+0x0/0x10d0
[<ffffffff815c7a00>] ? hub_thread+0x0/0x10d0
[<ffffffff810580f6>] ? kthread+0x96/0xa0
[<ffffffff81003b14>] ? kernel_thread_helper+0x4/0x10
[<ffffffff81058060>] ? kthread+0x0/0xa0
[<ffffffff81003b10>] ? kernel_thread_helper+0x0/0x10
Code: 44 8b 5c 24 28 45 85 db 0f 8e 65 01 00 00 8b 74 24 28 48 8b 7c 24=20
38 4c 89 e5 e8 25 d3
RIP  [<ffffffff815f64e7>] acm_probe+0x157/0xcb0
RSP <ffff88011fdf59c0>
CR2: 0000000000000008
---[ end trace facc809d566fe573 ]---

------------------------- >-8 --------------------

6. N/A

7.
- (software) N/A

- (cpu)
processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 23
model name	: Intel(R) Core(TM)2 Duo CPU     T9300  @ 2.50GHz
stepping	: 6
cpu MHz		: 800.000
cache size	: 6144 KB
physical id	: 0
siblings	: 2
core id		: 0
cpu cores	: 2
apicid		: 0
initial apicid	: 0
fpu		: yes
fpu_exception	: yes
cpuid level	: 10
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov=20
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm=20
constant_tsc arch_perfmon pebs bts rep_good nopl aperfmperf pni dtes64=20
monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm sse4_1 lahf_lm ida dts=20
tpr_shadow vnmi flexpriority
bogomips	: 4987.54
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:
processor	: 1
vendor_id	: GenuineIntel
cpu family	: 6
model		: 23
model name	: Intel(R) Core(TM)2 Duo CPU     T9300  @ 2.50GHz
stepping	: 6
cpu MHz		: 800.000
cache size	: 6144 KB
physical id	: 0
siblings	: 2
core id		: 1
cpu cores	: 2
apicid		: 1
initial apicid	: 1
fpu		: yes
fpu_exception	: yes
cpuid level	: 10
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov=20
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm=20
constant_tsc arch_perfmon pebs bts rep_good nopl aperfmperf pni dtes64=20
monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm sse4_1 lahf_lm ida dts=20
tpr_shadow vnmi flexpriority
bogomips	: 4987.43
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

- (modules) none
- (driver/hardware details) (skip for the moment)
- (pci)

00:00.0 Host bridge: Intel Corporation Mobile PM965/GM965/GL960 Memory=20
Controller Hub (rev 0c)
00:02.0 VGA compatible controller: Intel Corporation Mobile GM965/GL960=20
Integrated Graphics Controller (rev 0c)
00:02.1 Display controller: Intel Corporation Mobile GM965/GL960=20
Integrated Graphics Controller (rev 0c)
00:1a.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI=20
Controller #4 (rev 02)
00:1a.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI=20
Controller #5 (rev 02)
00:1a.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI =

Controller #2 (rev 02)
00:1b.0 Audio device: Intel Corporation 82801H (ICH8 Family) HD Audio=20
Controller (rev 02)
00:1c.0 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express=20
Port 1 (rev 02)
00:1c.1 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express=20
Port 2 (rev 02)
00:1c.3 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express=20
Port 4 (rev 02)
00:1c.5 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express=20
Port 6 (rev 02)
00:1d.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI=20
Controller #1 (rev 02)
00:1d.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI=20
Controller #2 (rev 02)
00:1d.2 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI=20
Controller #3 (rev 02)
00:1d.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI =

Controller #1 (rev 02)
00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev f2)
00:1f.0 ISA bridge: Intel Corporation 82801HEM (ICH8M) LPC Interface=20
Controller (rev 02)
00:1f.1 IDE interface: Intel Corporation 82801HBM/HEM (ICH8M/ICH8M-E)=20
IDE Controller (rev 02)
00:1f.2 SATA controller: Intel Corporation 82801HBM/HEM (ICH8M/ICH8M-E)=20
SATA AHCI Controller (rev 02)
00:1f.3 SMBus: Intel Corporation 82801H (ICH8 Family) SMBus Controller=20
(rev 02)
03:01.0 FireWire (IEEE 1394): Ricoh Co Ltd R5C832 IEEE 1394 Controller=20
(rev 05)
03:01.1 SD Host controller: Ricoh Co Ltd R5C822 SD/SDIO/MMC/MS/MSPro=20
Host Adapter (rev 22)
03:01.2 System peripheral: Ricoh Co Ltd R5C592 Memory Stick Bus Host=20
Adapter (rev 12)
03:01.3 System peripheral: Ricoh Co Ltd xD-Picture Card Controller (rev 1=
2)
09:00.0 Ethernet controller: Broadcom Corporation NetLink BCM5906M Fast=20
Ethernet PCI Express (rev 02)
0c:00.0 Network controller: Intel Corporation PRO/Wireless 4965 AG or=20
AGN [Kedron] Network Connection (rev 61)
0d:00.0 Ethernet controller: Marvell Technology Group Ltd. 88E8053 PCI-E =

Gigabit Ethernet Controller (rev 20)

- (scsi) N/A
- (other) none, System.map doesn't seem to give any extra information

Other notes: this is exactly reproduceable, so I don't think it's a=20
hardware issue. The device itself (the display) seems to be working OK.


--------------ms010309000207060500040407
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIPWDCC
BIowggNyoAMCAQICECf06hH0eobEbp27bqkXBwcwDQYJKoZIhvcNAQEFBQAwbzELMAkGA1UE
BhMCU0UxFDASBgNVBAoTC0FkZFRydXN0IEFCMSYwJAYDVQQLEx1BZGRUcnVzdCBFeHRlcm5h
bCBUVFAgTmV0d29yazEiMCAGA1UEAxMZQWRkVHJ1c3QgRXh0ZXJuYWwgQ0EgUm9vdDAeFw0w
NTA2MDcwODA5MTBaFw0yMDA1MzAxMDQ4MzhaMIGuMQswCQYDVQQGEwJVUzELMAkGA1UECBMC
VVQxFzAVBgNVBAcTDlNhbHQgTGFrZSBDaXR5MR4wHAYDVQQKExVUaGUgVVNFUlRSVVNUIE5l
dHdvcmsxITAfBgNVBAsTGGh0dHA6Ly93d3cudXNlcnRydXN0LmNvbTE2MDQGA1UEAxMtVVRO
LVVTRVJGaXJzdC1DbGllbnQgQXV0aGVudGljYXRpb24gYW5kIEVtYWlsMIIBIjANBgkqhkiG
9w0BAQEFAAOCAQ8AMIIBCgKCAQEAsjmFpPJ9q0E7YkY3rs3BYHW8OWX5ShpHornMSMxqmNVN
NRm5pELlzkniii8efNIxB8dOtINknS4p1aJkxIW9hVE1eaROaJB7HHqkkqgX8pgV8pPMyaQy
lbsMTzC9mKALi+VuG6JG+ni8om+rWV6lL8/K2m2qL+usobNqqrcuZzWLeeEeaYji5kbNoKXq
vgvOdjp6Dpvq/NonWz1zHyLmSGHGTPNpsaguG7bUMSAsvIKKjqQOpdeJQ/wWWq8dcdcRWdq6
hw2v+vPhwvCkxWeM1tZUOt4KpLoDd7NlyP0e03RiqhjKaJMeoYV+9Udly/hNVyh00jT/MLbu
9mIwFIws6wIDAQABo4HhMIHeMB8GA1UdIwQYMBaAFK29mHo0tCb3+sQmVO8DveAky1QaMB0G
A1UdDgQWBBSJgmd9xJ0mcABLtFBIfN49rgRufTAOBgNVHQ8BAf8EBAMCAQYwDwYDVR0TAQH/
BAUwAwEB/zB7BgNVHR8EdDByMDigNqA0hjJodHRwOi8vY3JsLmNvbW9kb2NhLmNvbS9BZGRU
cnVzdEV4dGVybmFsQ0FSb290LmNybDA2oDSgMoYwaHR0cDovL2NybC5jb21vZG8ubmV0L0Fk
ZFRydXN0RXh0ZXJuYWxDQVJvb3QuY3JsMA0GCSqGSIb3DQEBBQUAA4IBAQAZ2IkRbyispgCi
54fBm5AD236hEv0e8+LwAamUVEJrmgnEoG3XkJIEA2Z5Q3H8+G+v23ZF4jcaPd3kWQR4rBz0
g0bzes9bhHIt5UbBuhgRKfPLSXmHPLptBZ2kbWhPrXIUNqi5sf2/z3/wpGqUNVCPz4FtVbHd
WTBK322gnGQfSXzvNrv042n0+DmPWq1LhTq3Du3Tzw1EovsEv+QvcI4l+1pUBrPQxLxtjftz
Mizpm4QkLdZ/kXpoAlAfDj9N6cz1u2fo3BwuO/xOzf4CjuOoEwqlJkRl6RDyTVKnrtw+ymsy
XEFs/vVdoOr/0fqbhlhtPZZH5f4ulQTCAMyOofK7MIIFYTCCBEmgAwIBAgIRAIg14yiGxBLB
Nd3nEhie2VcwDQYJKoZIhvcNAQEFBQAwga4xCzAJBgNVBAYTAlVTMQswCQYDVQQIEwJVVDEX
MBUGA1UEBxMOU2FsdCBMYWtlIENpdHkxHjAcBgNVBAoTFVRoZSBVU0VSVFJVU1QgTmV0d29y
azEhMB8GA1UECxMYaHR0cDovL3d3dy51c2VydHJ1c3QuY29tMTYwNAYDVQQDEy1VVE4tVVNF
UkZpcnN0LUNsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgRW1haWwwHhcNMTAxMDE5MDAwMDAw
WhcNMTExMDE5MjM1OTU5WjBGMQswCQYDVQQGEwJOTDEVMBMGA1UEAxMMRXJpayBTbGFndGVy
MSAwHgYJKoZIhvcNAQkBFhFlcmlrQHNsYWd0ZXIubmFtZTCCASIwDQYJKoZIhvcNAQEBBQAD
ggEPADCCAQoCggEBANbriwH0w2kwn4b2BwVAtiZ0OkHIiwcscx1XIOzD/bp+Sv4tVdjc2bBF
tXTyEpDzP5cLs5V3g1hTxI5V40lgmsiKrDMp8XR6fDwqv0cdoS3ABS/gvlxhwvbJaeR7tjkM
Ni4ofKgEfSWi7hzFyijuwM/SrwJVlpTO7Xah+FKDLVh8FWUHRVxtnFuLaHcZR+4y0c0Zi2AE
gp3CLZQzXCsu/Nsi+0fclP4lbhg+XgAgTKDI2WIm7JuQgMSgoevQ6HFggreTj03tUoKjD4l4
JIoDb5tc/IutLhwXZTZsrdmW2SE29xhRWauNGs9DnJAcmpUJkXHGGL8cgmqWb1Mlh9JBaN8C
AwEAAaOCAd8wggHbMB8GA1UdIwQYMBaAFImCZ33EnSZwAEu0UEh83j2uBG59MB0GA1UdDgQW
BBTK4wFgfa4mmdF0XOGvj3dgyG8ePzAOBgNVHQ8BAf8EBAMCBaAwDAYDVR0TAQH/BAIwADAd
BgNVHSUEFjAUBggrBgEFBQcDBAYIKwYBBQUHAwIwRgYDVR0gBD8wPTA7BgwrBgEEAbIxAQIB
AwUwKzApBggrBgEFBQcCARYdaHR0cHM6Ly9zZWN1cmUuY29tb2RvLm5ldC9DUFMwgaUGA1Ud
HwSBnTCBmjBMoEqgSIZGaHR0cDovL2NybC5jb21vZG9jYS5jb20vVVROLVVTRVJGaXJzdC1D
bGllbnRBdXRoZW50aWNhdGlvbmFuZEVtYWlsLmNybDBKoEigRoZEaHR0cDovL2NybC5jb21v
ZG8ubmV0L1VUTi1VU0VSRmlyc3QtQ2xpZW50QXV0aGVudGljYXRpb25hbmRFbWFpbC5jcmww
bAYIKwYBBQUHAQEEYDBeMDYGCCsGAQUFBzAChipodHRwOi8vY3J0LmNvbW9kb2NhLmNvbS9V
VE5BQUFDbGllbnRDQS5jcnQwJAYIKwYBBQUHMAGGGGh0dHA6Ly9vY3NwLmNvbW9kb2NhLmNv
bTANBgkqhkiG9w0BAQUFAAOCAQEAALQg8UqA2KoLGSmq8SsJTddYzpglJrW3mcd55qDBKLBM
J5klHPPWoqdV2dA9X0yV4WlaS/eQHfgmQCjvJ42HDNJW6YBw1MrPFPxXFJsbpY0OlIeLY5oh
VZjuQeI3YfwOB1ZceU4QTkdF636Ljyz3D++PmSw6ww6mm8R8LX18JIYe6vhWZs93sSMQct3R
2s9kGB94lCKbapyq9lBhT/swM51wWTmnrIxrmFzm0+fFnNu9QwoazTn7hwg7G0Tiv2Zqz+Ba
x318aG+gZm1OnQQRPn1hiK5C6GiKrWu9/jTV3UaGePBGslkpopMdLrwQ43P/eHmJJGyXHBLx
87J7yN8HMzCCBWEwggRJoAMCAQICEQCINeMohsQSwTXd5xIYntlXMA0GCSqGSIb3DQEBBQUA
MIGuMQswCQYDVQQGEwJVUzELMAkGA1UECBMCVVQxFzAVBgNVBAcTDlNhbHQgTGFrZSBDaXR5
MR4wHAYDVQQKExVUaGUgVVNFUlRSVVNUIE5ldHdvcmsxITAfBgNVBAsTGGh0dHA6Ly93d3cu
dXNlcnRydXN0LmNvbTE2MDQGA1UEAxMtVVROLVVTRVJGaXJzdC1DbGllbnQgQXV0aGVudGlj
YXRpb24gYW5kIEVtYWlsMB4XDTEwMTAxOTAwMDAwMFoXDTExMTAxOTIzNTk1OVowRjELMAkG
A1UEBhMCTkwxFTATBgNVBAMTDEVyaWsgU2xhZ3RlcjEgMB4GCSqGSIb3DQEJARYRZXJpa0Bz
bGFndGVyLm5hbWUwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDW64sB9MNpMJ+G
9gcFQLYmdDpByIsHLHMdVyDsw/26fkr+LVXY3NmwRbV08hKQ8z+XC7OVd4NYU8SOVeNJYJrI
iqwzKfF0enw8Kr9HHaEtwAUv4L5cYcL2yWnke7Y5DDYuKHyoBH0lou4cxcoo7sDP0q8CVZaU
zu12ofhSgy1YfBVlB0VcbZxbi2h3GUfuMtHNGYtgBIKdwi2UM1wrLvzbIvtH3JT+JW4YPl4A
IEygyNliJuybkIDEoKHr0OhxYIK3k49N7VKCow+JeCSKA2+bXPyLrS4cF2U2bK3ZltkhNvcY
UVmrjRrPQ5yQHJqVCZFxxhi/HIJqlm9TJYfSQWjfAgMBAAGjggHfMIIB2zAfBgNVHSMEGDAW
gBSJgmd9xJ0mcABLtFBIfN49rgRufTAdBgNVHQ4EFgQUyuMBYH2uJpnRdFzhr493YMhvHj8w
DgYDVR0PAQH/BAQDAgWgMAwGA1UdEwEB/wQCMAAwHQYDVR0lBBYwFAYIKwYBBQUHAwQGCCsG
AQUFBwMCMEYGA1UdIAQ/MD0wOwYMKwYBBAGyMQECAQMFMCswKQYIKwYBBQUHAgEWHWh0dHBz
Oi8vc2VjdXJlLmNvbW9kby5uZXQvQ1BTMIGlBgNVHR8EgZ0wgZowTKBKoEiGRmh0dHA6Ly9j
cmwuY29tb2RvY2EuY29tL1VUTi1VU0VSRmlyc3QtQ2xpZW50QXV0aGVudGljYXRpb25hbmRF
bWFpbC5jcmwwSqBIoEaGRGh0dHA6Ly9jcmwuY29tb2RvLm5ldC9VVE4tVVNFUkZpcnN0LUNs
aWVudEF1dGhlbnRpY2F0aW9uYW5kRW1haWwuY3JsMGwGCCsGAQUFBwEBBGAwXjA2BggrBgEF
BQcwAoYqaHR0cDovL2NydC5jb21vZG9jYS5jb20vVVROQUFBQ2xpZW50Q0EuY3J0MCQGCCsG
AQUFBzABhhhodHRwOi8vb2NzcC5jb21vZG9jYS5jb20wDQYJKoZIhvcNAQEFBQADggEBAAC0
IPFKgNiqCxkpqvErCU3XWM6YJSa1t5nHeeagwSiwTCeZJRzz1qKnVdnQPV9MleFpWkv3kB34
JkAo7yeNhwzSVumAcNTKzxT8VxSbG6WNDpSHi2OaIVWY7kHiN2H8DgdWXHlOEE5HRet+i48s
9w/vj5ksOsMOppvEfC19fCSGHur4VmbPd7EjEHLd0drPZBgfeJQim2qcqvZQYU/7MDOdcFk5
p6yMa5hc5tPnxZzbvUMKGs05+4cIOxtE4r9mas/gWsd9fGhvoGZtTp0EET59YYiuQuhoiq1r
vf401d1GhnjwRrJZKaKTHS68EONz/3h5iSRslxwS8fOye8jfBzMxggRgMIIEXAIBATCBxDCB
rjELMAkGA1UEBhMCVVMxCzAJBgNVBAgTAlVUMRcwFQYDVQQHEw5TYWx0IExha2UgQ2l0eTEe
MBwGA1UEChMVVGhlIFVTRVJUUlVTVCBOZXR3b3JrMSEwHwYDVQQLExhodHRwOi8vd3d3LnVz
ZXJ0cnVzdC5jb20xNjA0BgNVBAMTLVVUTi1VU0VSRmlyc3QtQ2xpZW50IEF1dGhlbnRpY2F0
aW9uIGFuZCBFbWFpbAIRAIg14yiGxBLBNd3nEhie2VcwCQYFKw4DAhoFAKCCAnAwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTEwNTA2MDgyNzE1WjAjBgkq
hkiG9w0BCQQxFgQUvAE9XcvOQ5dSxv0a9QfTdvfTK7IwXwYJKoZIhvcNAQkPMVIwUDALBglg
hkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFAMAcG
BSsOAwIHMA0GCCqGSIb3DQMCAgEoMIHVBgkrBgEEAYI3EAQxgccwgcQwga4xCzAJBgNVBAYT
AlVTMQswCQYDVQQIEwJVVDEXMBUGA1UEBxMOU2FsdCBMYWtlIENpdHkxHjAcBgNVBAoTFVRo
ZSBVU0VSVFJVU1QgTmV0d29yazEhMB8GA1UECxMYaHR0cDovL3d3dy51c2VydHJ1c3QuY29t
MTYwNAYDVQQDEy1VVE4tVVNFUkZpcnN0LUNsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgRW1h
aWwCEQCINeMohsQSwTXd5xIYntlXMIHXBgsqhkiG9w0BCRACCzGBx6CBxDCBrjELMAkGA1UE
BhMCVVMxCzAJBgNVBAgTAlVUMRcwFQYDVQQHEw5TYWx0IExha2UgQ2l0eTEeMBwGA1UEChMV
VGhlIFVTRVJUUlVTVCBOZXR3b3JrMSEwHwYDVQQLExhodHRwOi8vd3d3LnVzZXJ0cnVzdC5j
b20xNjA0BgNVBAMTLVVUTi1VU0VSRmlyc3QtQ2xpZW50IEF1dGhlbnRpY2F0aW9uIGFuZCBF
bWFpbAIRAIg14yiGxBLBNd3nEhie2VcwDQYJKoZIhvcNAQEBBQAEggEAhU5SlDsri6nkFyol
pPnbNtZ52tJFbWSLsrL7+vGJuGbrnR0jAE+dm3NCZODnfdQh0dmDp7vdvtDHbpMsGt2tB7W4
iTHRw+xITTAjqPW2/5TywKKypHC5P4qkkuRhI5Cvow+hFastLC6If2St5hSazhbDjkq3mS3a
hlq3bPxFJg2Jo21ywDpyqdoJEq027tTsv6tF4eEqvpNSFhM4uF9Em444mxIz6HrVvrHXMNa0
M0fj0FMgiYxmyTCHyatWpRZvOr9b8IQ8klwQvysRX58iPCN2fMQkSsmCExsvBmkyDokyXN9X
AGFf740H6NUX3ZTSxOKIQAm9DiC4ISgNBIClUQAAAAAAAA==
--------------ms010309000207060500040407--
