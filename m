Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752556Ab1HANSg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 09:18:36 -0400
Received: from powered.by.root24.eu ([91.121.20.142]:55956 "EHLO Root24.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751700Ab1HANS2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 09:18:28 -0400
Message-ID: <4E36A7A1.2010701@ionic.de>
Date: Mon, 01 Aug 2011 15:18:25 +0200
From: Mihai Moldovan <ionic@ionic.de>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Dave Kleikamp <shaggy@kernel.org>
Subject: [BUG JFS] fs/jfs/jfs_txnmgr.c:940 assert(mp->nohomeok > 0) and fs/jfs/jfs_metapage.c:752
 assert(mp->count)
X-Enigmail-Version: 1.2
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms070908020000040008040903"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms070908020000040008040903
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi,

yesterday while compiling LibreOffice on my amd64 box running Linux
3.0.0, those bugs happened:

[692827.021788] BUG at fs/jfs/jfs_txnmgr.c:940 assert(mp->nohomeok > 0)
[692827.021804] ------------[ cut here ]------------
[692827.021821] kernel BUG at fs/jfs/jfs_txnmgr.c:940!
[692827.021832] invalid opcode: 0000 [#1] SMP
[692827.021846] CPU 0
[692827.021851] Modules linked in: xt_state xt_dscp xt_hashlimit
xt_conntrack xt_DSCP ath9k i915 mac80211 ath9k_common ath9k_hw
drm_kms_helper ath cfg80211 cfbcopyarea e1000e video rfkill backlight
cfbimgblt cfbfillrect
[692827.021934]
[692827.021940] Pid: 697, comm: jfsCommit Not tainted 3.0.0-OSS4.2
#1                  /DQ45CB
[692827.021967] RIP: 0010:[<ffffffff81252835>]  [<ffffffff81252835>]
txUnlock+0xc2/0x21a
[692827.021991] RSP: 0018:ffff880231901e20  EFLAGS: 00010286
[692827.022003] RAX: 000000000000004e RBX: ffffc900080aef00 RCX:
000000000000ef51
[692827.022021] RDX: 0000000000000000 RSI: 0000000000000046 RDI:
ffffffff81ef0e60
[692827.022038] RBP: ffff880231901e60 R08: 0000000000000046 R09:
00000000fffffffe
[692827.022054] R10: ffff8802b1901d3f R11: 0000000000000000 R12:
ffff8801a8fca380
[692827.022070] R13: ffff88022e05b600 R14: ffffc900081db3e0 R15:
000000005063059c
[692827.022087] FS:  0000000000000000(0000) GS:ffff88023bc00000(0000)
knlGS:0000000000000000
[692827.022105] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[692827.022118] CR2: 00007f98337ce000 CR3: 0000000003f36000 CR4:
00000000000406f0
[692827.022135] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[692827.022152] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[692827.022168] Process jfsCommit (pid: 697, threadinfo
ffff880231900000, task ffff880232746140)
[692827.022185] Stack:
[692827.022191]  2e84880231901e60 ffff88022e05b718 ffffffff816a41f3
ffff880232746140
[692827.022214]  ffff880231901e80 ffff88023332b300 cccccccccccccccd
ffffc900080aef00
[692827.022238]  ffff880231901ee0 ffffffff81254de7 0000000000010bc0
ffff88022e05b600
[692827.022261] Call Trace:
[692827.022274]  [<ffffffff816a41f3>] ? _raw_spin_lock_irqsave+0xd/0x2a
[692827.022290]  [<ffffffff81254de7>] jfs_lazycommit+0x13d/0x24e
[692827.022305]  [<ffffffff8103c53e>] ? try_to_wake_up+0x1c5/0x1c5
[692827.022318]  [<ffffffff81254caa>] ? txCommit+0x33b/0x33b
[692827.022332]  [<ffffffff810595da>] kthread+0x7d/0x85
[692827.022346]  [<ffffffff816aa614>] kernel_thread_helper+0x4/0x10
[692827.022361]  [<ffffffff8105955d>] ? kthread_worker_fn+0x137/0x137
[692827.022376]  [<ffffffff816aa610>] ? gs_change+0xb/0xb
[692827.022387] Code: ff 41 8b 44 24 68 85 c0 7f 23 48 c7 c1 df 5a b1 81
ba ac 03 00 00 48 c7 c6 cb 5a b1 81 48 c7 c7 3a 4c b1 81 31 c0 e8 69 fd
44 00 <0f> 0b ff c8 41 89 44 24 68 85 c0 75 0a 49 8b 7c 24 58 e8 9b 68
[692827.022519] RIP  [<ffffffff81252835>] txUnlock+0xc2/0x21a
[692827.022533]  RSP <ffff880231901e20>
[692827.073901] ---[ end trace b4cb55fb5d49efbd ]---
[693433.340865] ERROR: (device md1): XT_GETPAGE: xtree page corrupt
[693433.366922] ERROR: (device md1): XT_GETPAGE: xtree page corrupt
[693433.366925] ERROR: (device md1): XT_GETPAGE: xtree page corrupt
[693433.366931] ERROR: (device md1): XT_GETPAGE: xtree page corrupt
[693433.366933] ERROR: (device md1): XT_GETPAGE: xtree page corrupt
[693433.366935] ERROR: (device md1): XT_GETPAGE: xtree page corrupt
[693433.366937] ERROR: (device md1): XT_GETPAGE: xtree page corrupt
[693433.366939] ERROR: (device md1): XT_GETPAGE: xtree page corrupt
[693433.366941] ERROR: (device md1): XT_GETPAGE: xtree page corrupt
[693433.366943] ERROR: (device md1): XT_GETPAGE: xtree page corrupt
[693433.366945] BUG at fs/jfs/jfs_metapage.c:752 assert(mp->count)
[693433.366955] ------------[ cut here ]------------
[693433.366970] kernel BUG at fs/jfs/jfs_metapage.c:752!
[693433.366981] invalid opcode: 0000 [#2] SMP
[693433.366993] CPU 2
[693433.366998] Modules linked in: xt_state xt_dscp xt_hashlimit
xt_conntrack xt_DSCP ath9k i915 mac80211 ath9k_common ath9k_hw
drm_kms_helper ath cfg80211 cfbcopyarea e1000e video rfkill backlight
cfbimgblt cfbfillrect
[693433.367069]
[693433.367075] Pid: 10230, comm: shutdown Tainted: G      D   =20
3.0.0-OSS4.2 #1                  /DQ45CB
[693433.367098] RIP: 0010:[<ffffffff8124ffb6>]  [<ffffffff8124ffb6>]
release_metapage+0x5f/0xf7
[693433.367122] RSP: 0018:ffff8801a7a41ae8  EFLAGS: 00010296
[693433.367134] RAX: 0000000000000049 RBX: ffff8801a8fca380 RCX:
0000000000000aa3
[693433.367149] RDX: 0000000000000000 RSI: 0000000000000046 RDI:
ffffffff81ef0e60
[693433.367165] RBP: ffff8801a7a41af8 R08: 0000000000000046 R09:
00000000fffffffe
[693433.367180] R10: ffff880227a41a07 R11: 0000000000000000 R12:
ffffea0007051da8
[693433.367196] R13: ffff88022e901000 R14: 0000000000000001 R15:
000000000000034b
[693433.367212] FS:  00007fcbd4f3f700(0000) GS:ffff88023bd00000(0000)
knlGS:0000000000000000
[693433.367229] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[693433.367242] CR2: 00007fcbd4abb980 CR3: 00000001fbe6d000 CR4:
00000000000406e0
[693433.367258] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[693433.367273] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[693433.367289] Process shutdown (pid: 10230, threadinfo
ffff8801a7a40000, task ffff88023328e140)
[693433.367307] Stack:
[693433.367312]  ffff8801a8fca380 0000000000000000 ffff8801a7a41b98
ffffffff8124dcb2
[693433.367334]  ffff8801a7a41b78 ffffffff81253dbc ffff880232cdbdc0
0000000200000002
[693433.367356]  ffff880231483400 00000001812b07bf ffff8801a7a41cc0
0000402000000000
[693433.367378] Call Trace:
[693433.367386]  [<ffffffff8124dcb2>] dtInsert+0x18c/0x19e
[693433.367399]  [<ffffffff81253dbc>] ? txLock+0x1bd/0x5ab
[693433.367411]  [<ffffffff8123e835>] jfs_create+0x153/0x27f
[693433.367425]  [<ffffffff810e120f>] ? do_lookup+0x46/0x28f
[693433.367439]  [<ffffffff816a41e4>] ? _raw_spin_lock+0x9/0xb
[693433.367452]  [<ffffffff810e9119>] ? __d_lookup+0x91/0xcb
[693433.367465]  [<ffffffff810e18e9>] vfs_create+0x6b/0x8d
[693433.367478]  [<ffffffff810e1b2e>] do_last+0x223/0x46b
[693433.367491]  [<ffffffff810e2ef7>] path_openat+0xc2/0x334
[693433.367503]  [<ffffffff810e31a1>] do_filp_open+0x38/0x84
[693433.367517]  [<ffffffff81306fbd>] ? strncpy_from_user+0x34/0x37
[693433.367532]  [<ffffffff810ec9c0>] ? alloc_fd+0x6f/0x11a
[693433.367545]  [<ffffffff810d6f3f>] do_sys_open+0x6f/0x101
[693433.367557]  [<ffffffff810d6fec>] sys_open+0x1b/0x1d
[693433.367570]  [<ffffffff816a953b>] system_call_fastpath+0x16/0x1b
[693433.367583] Code: 56 de ff 48 8b 43 28 48 85 c0 75 21 48 c7 c1 d6 59
b1 81 ba f0 02 00 00 48 c7 c6 33 59 b1 81 48 c7 c7 3a 4c b1 81 e8 e8 25
45 00 <0f> 0b 48 ff c8 48 89 43 28 48 85 c0 75 75 83 7b 68 00 75 6f 48
[693433.367707] RIP  [<ffffffff8124ffb6>] release_metapage+0x5f/0xf7
[693433.367723]  RSP <ffff8801a7a41ae8>
[693433.373041] ---[ end trace b4cb55fb5d49efbe ]---

The system was in an unusable state afterwards - new network connections
couldn't be established while already running ones continued to work
fine. Also, neither reboot (segfaulted the first time, won't return the
second time) or init 6 did work and I was forced to do a hard
shutdown/reboot.

I'm pretty sure that the system would have locked up completely after
some time if I hadn't rebooted after the incident, as happened several
times, but I've never been able to get a trace of what happened so far.

As this bug happened at pretty high disk load (whilst compiling), I
guess JFS has a few really nasty bugs.

This is actually not the first bug I encounter with JFS. I've noticed, th=
at:
  - performance degrades a lot with files > 50GB for some reason. This
is especially annoying if copying full disk images. It starts up fine
with maximum speed and drops to a few MB/s as the file gets bigger and
bigger.
  - on older Kernels I've seen the jfsCommit threads causing a *lot* CPU
load when working with big files. It got worse and worse the bigger the
file became until the system hung completely (even AFTER the file was
transferred successfully and a sync called.) It started with as low as
6% CPU load and increased steadily, even on multiple jfsCommit threads.
I haven't tested this on 3.0.0 yet though, but every older version I ran
had this kind of problem.

All those problems may or may not be linked together. Something seems to
be really wrong.

Best regards,


Mihai


--------------ms070908020000040008040903
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIINBjCC
BjQwggQcoAMCAQICASAwDQYJKoZIhvcNAQEFBQAwfTELMAkGA1UEBhMCSUwxFjAUBgNVBAoT
DVN0YXJ0Q29tIEx0ZC4xKzApBgNVBAsTIlNlY3VyZSBEaWdpdGFsIENlcnRpZmljYXRlIFNp
Z25pbmcxKTAnBgNVBAMTIFN0YXJ0Q29tIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MB4XDTA3
MTAyNDIxMDI1NVoXDTE3MTAyNDIxMDI1NVowgYwxCzAJBgNVBAYTAklMMRYwFAYDVQQKEw1T
dGFydENvbSBMdGQuMSswKQYDVQQLEyJTZWN1cmUgRGlnaXRhbCBDZXJ0aWZpY2F0ZSBTaWdu
aW5nMTgwNgYDVQQDEy9TdGFydENvbSBDbGFzcyAyIFByaW1hcnkgSW50ZXJtZWRpYXRlIENs
aWVudCBDQTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMsohUWcASz7GfKrpTOM
KqANy9BV7V0igWdGxA8IU77L3aTxErQ+fcxtDYZ36Z6GH0YFn7fq5RADteP0AYzrCA+EQTfi
8q1+kA3m0nwtwXG94M5sIqsvs7lRP1aycBke/s5g9hJHryZ2acScnzczjBCAo7X1v5G3yw8M
DP2m2RCye0KfgZ4nODerZJVzhAlOD9YejvAXZqHksw56HzElVIoYSZ3q4+RJuPXXfIoyby+Y
2m1E+YzX5iCZXBx05gk6MKAW1vaw4/v2OOLy6FZH3XHHtOkzUreG//CsFnB9+uaYSlR65cdG
zTsmoIK8WH1ygoXhRBm98SD7Hf/r3FELNvUCAwEAAaOCAa0wggGpMA8GA1UdEwEB/wQFMAMB
Af8wDgYDVR0PAQH/BAQDAgEGMB0GA1UdDgQWBBSuVYNv7DHKufcd+q9rMfPIHeOsuzAfBgNV
HSMEGDAWgBROC+8apEBbpRdphzDKNGhD0EGu8jBmBggrBgEFBQcBAQRaMFgwJwYIKwYBBQUH
MAGGG2h0dHA6Ly9vY3NwLnN0YXJ0c3NsLmNvbS9jYTAtBggrBgEFBQcwAoYhaHR0cDovL3d3
dy5zdGFydHNzbC5jb20vc2ZzY2EuY3J0MFsGA1UdHwRUMFIwJ6AloCOGIWh0dHA6Ly93d3cu
c3RhcnRzc2wuY29tL3Nmc2NhLmNybDAnoCWgI4YhaHR0cDovL2NybC5zdGFydHNzbC5jb20v
c2ZzY2EuY3JsMIGABgNVHSAEeTB3MHUGCysGAQQBgbU3AQIBMGYwLgYIKwYBBQUHAgEWImh0
dHA6Ly93d3cuc3RhcnRzc2wuY29tL3BvbGljeS5wZGYwNAYIKwYBBQUHAgEWKGh0dHA6Ly93
d3cuc3RhcnRzc2wuY29tL2ludGVybWVkaWF0ZS5wZGYwDQYJKoZIhvcNAQEFBQADggIBADqp
Jw3I07QWke9plNBpxUxcffc7nUrIQpJHDci91DFG7fVhHRkMZ1J+BKg5UNUxIFJ2Z9B90Mic
c/NXcs7kPBRdn6XGO/vPc87Y6R+cWS9Nc9+fp3Enmsm94OxOwI9wn8qnr/6o3mD4noP9Jphw
UPTXwHovjavRnhUQHLfo/i2NG0XXgTHXS2Xm0kVUozXqpYpAdumMiB/vezj1QHQJDmUdPYMc
p+reg9901zkyT3fDW/ivJVv6pWtkh6Pw2ytZT7mvg7YhX3V50Nv860cV11mocUVcqBLv0gcT
+HBDYtbuvexNftwNQKD5193A7zN4vG7CTYkXxytSjKuXrpEatEiFPxWgb84nVj25SU5q/r1X
hwby6mLhkbaXslkVtwEWT3Van49rKjlK4XrUKYYWtnfzq6aSak5u0Vpxd1rY79tWhD3EdCvO
hNz/QplNa+VkIsrcp7+8ZhP1l1b2U6MaxIVteuVMD3X0vziIwr7jxYae9FZjbxlpUemqXjcC
0QaFfN7qI0JsQMALL7iGRBg7K0CoOBzECdD3fuZil5kU/LP9cr1BK31U0Uy651bFnAMMMkqh
AChIbn0ei72VnbpSsrrSdF0BAGYQ8vyHae5aCg+H75dVCV33K6FuxZrf09yTz+Vx/PkdRUYk
XmZz/OTfyJXsUOUXrym6KvI2rYpccSk5MIIGyjCCBbKgAwIBAgICBnIwDQYJKoZIhvcNAQEF
BQAwgYwxCzAJBgNVBAYTAklMMRYwFAYDVQQKEw1TdGFydENvbSBMdGQuMSswKQYDVQQLEyJT
ZWN1cmUgRGlnaXRhbCBDZXJ0aWZpY2F0ZSBTaWduaW5nMTgwNgYDVQQDEy9TdGFydENvbSBD
bGFzcyAyIFByaW1hcnkgSW50ZXJtZWRpYXRlIENsaWVudCBDQTAeFw0xMDAzMjMxNjI2NTZa
Fw0xMjAzMjQwNTQ2MjJaMIHHMSAwHgYDVQQNExcxNjg2MTctOUo5elVlMUVuNHg5b3ZiTzEL
MAkGA1UEBhMCREUxGzAZBgNVBAgTEkJhZGVuLVd1ZXJ0dGVtYmVyZzESMBAGA1UEBxMJS2Fy
bHNydWhlMS0wKwYDVQQLEyRTdGFydENvbSBWZXJpZmllZCBDZXJ0aWZpY2F0ZSBNZW1iZXIx
FzAVBgNVBAMTDk1paGFpIE1vbGRvdmFuMR0wGwYJKoZIhvcNAQkBFg5pb25pY0Bpb25pYy5k
ZTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMssU6wPYwJJAxY07er/P6ANPXgz
yCczuA+7q/eql1St56r91yQ534A4oeXEqRZvpMsDuvczNG1Yz80nLpM+lO3Wg8csxaGReewe
RBIS3abf40HCIBVlOl7oTcmzZuzqz2KE70CHZ7p3k0WAEUfUb7AS8qrqxuoj0dtUkrdMwjoD
rPWs3zJ+vHo5FU3sTvj2ksiStjG3NMERBT+1Gzf2pVx2cKJRBmqACbKZfwE9QufRqrZT8bWY
i5DCV34RL7eVLnejLL+MvtarZv2K8Acojq9t7zO9Z+0rnlr6o46c2egVB+s/ol28q3DEce6f
p1KrCiujqRqQwVQ8O/2ogg4l5h0CAwEAAaOCAvcwggLzMAkGA1UdEwQCMAAwCwYDVR0PBAQD
AgSwMB0GA1UdJQQWMBQGCCsGAQUFBwMCBggrBgEFBQcDBDAdBgNVHQ4EFgQU3JbCyOa+BBzV
nBAKycZGQAzit2wwHwYDVR0jBBgwFoAUrlWDb+wxyrn3HfqvazHzyB3jrLswGQYDVR0RBBIw
EIEOaW9uaWNAaW9uaWMuZGUwggFCBgNVHSAEggE5MIIBNTCCATEGCysGAQQBgbU3AQIBMIIB
IDAuBggrBgEFBQcCARYiaHR0cDovL3d3dy5zdGFydHNzbC5jb20vcG9saWN5LnBkZjA0Bggr
BgEFBQcCARYoaHR0cDovL3d3dy5zdGFydHNzbC5jb20vaW50ZXJtZWRpYXRlLnBkZjCBtwYI
KwYBBQUHAgIwgaowFBYNU3RhcnRDb20gTHRkLjADAgEBGoGRTGltaXRlZCBMaWFiaWxpdHks
IHNlZSBzZWN0aW9uICpMZWdhbCBMaW1pdGF0aW9ucyogb2YgdGhlIFN0YXJ0Q29tIENlcnRp
ZmljYXRpb24gQXV0aG9yaXR5IFBvbGljeSBhdmFpbGFibGUgYXQgaHR0cDovL3d3dy5zdGFy
dHNzbC5jb20vcG9saWN5LnBkZjBjBgNVHR8EXDBaMCugKaAnhiVodHRwOi8vd3d3LnN0YXJ0
c3NsLmNvbS9jcnR1Mi1jcmwuY3JsMCugKaAnhiVodHRwOi8vY3JsLnN0YXJ0c3NsLmNvbS9j
cnR1Mi1jcmwuY3JsMIGOBggrBgEFBQcBAQSBgTB/MDkGCCsGAQUFBzABhi1odHRwOi8vb2Nz
cC5zdGFydHNzbC5jb20vc3ViL2NsYXNzMi9jbGllbnQvY2EwQgYIKwYBBQUHMAKGNmh0dHA6
Ly93d3cuc3RhcnRzc2wuY29tL2NlcnRzL3N1Yi5jbGFzczIuY2xpZW50LmNhLmNydDAjBgNV
HRIEHDAahhhodHRwOi8vd3d3LnN0YXJ0c3NsLmNvbS8wDQYJKoZIhvcNAQEFBQADggEBACle
v1JwhVI4Pu8GzKRJzJdcYdsT7fJ9R5OzNnec4CADsb9Xu7HDyRa5qABBXihHvmo+fxGVe6Hy
8TxPvZYCGaeUi2t6aodIFOTQDWcdEP9o7SynBOXHqsN2lZ08Q4MBuoGfquJi0XjpCNnLY9KS
OZTHTwAIqGVH7lf99egY1Atfl+y/Lc0e6Sw/0qvcnaQSzwCZ/OkqVWSTGDZXwCDFuy6Cbwjy
Kn9qshZzeMqvSKHmHPihzJQ6eVXImZgrgWk5FrBpO8d59xoqO32PbSyM0cZhqvkbG/nlWPbz
Xn13+cgG7ajAGCg8XueMeh3m03sIIHinvgaeHOAqeO3TvVVv6WQxggPNMIIDyQIBATCBkzCB
jDELMAkGA1UEBhMCSUwxFjAUBgNVBAoTDVN0YXJ0Q29tIEx0ZC4xKzApBgNVBAsTIlNlY3Vy
ZSBEaWdpdGFsIENlcnRpZmljYXRlIFNpZ25pbmcxODA2BgNVBAMTL1N0YXJ0Q29tIENsYXNz
IDIgUHJpbWFyeSBJbnRlcm1lZGlhdGUgQ2xpZW50IENBAgIGcjAJBgUrDgMCGgUAoIICDjAY
BgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xMTA4MDExMzE4MjVa
MCMGCSqGSIb3DQEJBDEWBBRHul9vaFFKvLaT42rWdU7pNWmWKTBfBgkqhkiG9w0BCQ8xUjBQ
MAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwIC
AUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgaQGCSsGAQQBgjcQBDGBljCBkzCBjDELMAkG
A1UEBhMCSUwxFjAUBgNVBAoTDVN0YXJ0Q29tIEx0ZC4xKzApBgNVBAsTIlNlY3VyZSBEaWdp
dGFsIENlcnRpZmljYXRlIFNpZ25pbmcxODA2BgNVBAMTL1N0YXJ0Q29tIENsYXNzIDIgUHJp
bWFyeSBJbnRlcm1lZGlhdGUgQ2xpZW50IENBAgIGcjCBpgYLKoZIhvcNAQkQAgsxgZaggZMw
gYwxCzAJBgNVBAYTAklMMRYwFAYDVQQKEw1TdGFydENvbSBMdGQuMSswKQYDVQQLEyJTZWN1
cmUgRGlnaXRhbCBDZXJ0aWZpY2F0ZSBTaWduaW5nMTgwNgYDVQQDEy9TdGFydENvbSBDbGFz
cyAyIFByaW1hcnkgSW50ZXJtZWRpYXRlIENsaWVudCBDQQICBnIwDQYJKoZIhvcNAQEBBQAE
ggEASudSvUKEj74/MdzlSeyObr79i/kgN9x7rZ2k++98gNbmZ2joUb/LVPvUJ3TH6emaOlGD
0rK0kMgb89SB0tmd+WZdINU2eIObAMJhuAF25GKQzfguXe3h9XISo4YBZ8cpbx/JdvMq1HzT
OzRI9UgCkZvLef1RQGFqm0ToZH69BkhyHQqXBtomsF/yEdA6sC4eqKZSlJdYiksTFK1WmIpy
Z1TxmfKeBnL/2sUjmAg1CT5eCNzoepHfWKgHKtaStqTar0PR3yjPjK6Wlkoo9RQ4yd5/2gGM
C0db8pe2BgIgcAWBgUy3GP1DqeLysqsWN1/I/uPr2tRmFO3ptIXKIZVCTQAAAAAAAA==
--------------ms070908020000040008040903--
