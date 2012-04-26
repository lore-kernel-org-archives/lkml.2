Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670Ab2DZGp7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 02:45:59 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:56480 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753789Ab2DZGp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 02:45:58 -0400
Message-ID: <1335422729.26734.10.camel@ierdnac-hp>
Subject: Re: bluetooth oops
From: Andrei Popa <andrei.popa@i-neo.ro>
Reply-To: andrei.popa@i-neo.ro
To: Andrei Emeltchenko <andrei.emeltchenko.news@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Bluetooth Linux <linux-bluetooth@vger.kernel.org>
Date: Thu, 26 Apr 2012 09:45:29 +0300
In-Reply-To: <CAMXE1-rhPegy+97JwKQKBqrza-PZZX4H0RAYp35oDePmgEWHJw@mail.gmail.com>
References: <1335365016.6263.28.camel@ierdnac-hp>
	 <CAMXE1-rhPegy+97JwKQKBqrza-PZZX4H0RAYp35oDePmgEWHJw@mail.gmail.com>
Organization: INEOSOFT
Content-Type: multipart/signed; micalg="sha512";
	protocol="application/x-pkcs7-signature";
	boundary="=-HdgeBrUNQ9g8GHAm8M8g"
X-Mailer: Evolution 3.2.3 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-HdgeBrUNQ9g8GHAm8M8g
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi and thanks for the answer,

Unfortunately I can't reproduce the oops. If I find a way to reproduce
it I will apply the patches and see if it's fixed.

On Wed, 2012-04-25 at 23:59 +0300, Andrei Emeltchenko wrote:=20
> Hi Andrei
>=20
> On Wed, Apr 25, 2012 at 5:43 PM, Andrei Popa <andrei.popa@i-neo.ro> wrote=
:
> >
> > I was using kernel (Linux hp 3.3.3-pf-c236 #1 SMP PREEMPT Mon Apr 23
> > 21:09:50 EEST 2012 x86_64 Intel(R) Core(TM) i3 CPU M 380 @ 2.53GHz
> > GenuineIntel GNU/Linux) with pf patchset and when I was pairing a
> > bluettoth phone with the computer it oopses:
> >
> >
> > BUG: unable to handle kernel paging request at 0000000100000000
> > IP: [<ffffffff817a42f5>] _raw_spin_lock_irqsave+0x25/0x50
> > PGD 0
> > Oops: 0002 [#1] PREEMPT SMP
> > CPU 2
> > Modules linked in: r8169 rt2800pci eeprom_93cx6 rt2x00pci rt2800lib
> > rt2x00lib mac80211 psmouse cfg80211 [last unloaded: r8169]
> >
> > Pid: 15651, comm: bluetoothd Not tainted 3.3.3-pf-c236 #1
> > Hewlett-Packard HP ProBook 4320s/1423
> > RIP: 0010:[<ffffffff817a42f5>]  [<ffffffff817a42f5>]
> > _raw_spin_lock_irqsave+0x25/0x50
> > RSP: 0000:ffff8801f1143d10  EFLAGS: 00010002
> > RAX: 0000000000000100 RBX: 0000000100000000 RCX: 000000000000006d
> > RDX: 0000000000000206 RSI: ffff8801f1143d50 RDI: 0000000100000000
> > RBP: ffff8801f2ba08f0 R08: 0000000000000000 R09: 0000000000000000
> > R10: 000000000000000a R11: 0000000000000000 R12: ffff8801f1143d50
> > R13: 0000000100000000 R14: 00007fff2cfa5880 R15: 00007fa7c6e08760
> > FS:  00007fa7c6db5700(0000) GS:ffff88023bc80000(0000)
> > knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> > CR2: 0000000100000000 CR3: 000000010868a000 CR4: 00000000000006e0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> > Process bluetoothd (pid: 15651, threadinfo ffff8801f1142000, task
> > ffff88022a8eed70)
> > Stack:
> > ffffffff8107e3b3 0000000000000000 ffff8801f2ba08d8 0000000000000000
> > ffff8801f1143db0 ffff8801ef429570 ffffffff8107e82f ffff8801f1143d68
> > ffffffff8174abe0 ffffffff819b715b ffff8801f2ba0800 0000000000000000
> > atkbd serio0: Unknown key released (translated set 2, code 0xf8 on
> > isa0060/serio0).
> > atkbd serio0: Use 'setkeycodes e078 <keycode>' to make it known.
> > Call Trace:
> > [<ffffffff8107e3b3>] ? lock_timer_base.clone.28+0x33/0x70
> > [<ffffffff8107e82f>] ? del_timer+0x1f/0x80
> > [<ffffffff8174abe0>] ? hci_conn_del_sysfs+0x60/0xa0
> > [<ffffffff8173ebd0>] ? hci_conn_del+0x20/0x220
> > [<ffffffff8173ee40>] ? hci_conn_hash_flush+0x70/0xd0
>=20
> Probably related to:
>=20
> https://lkml.org/lkml/2012/3/7/68
>=20
> Could you try those patches below:
>=20
> http://git.kernel.org/?p=3Dlinux/kernel/git/next/linux-next.git;a=3Dpatch=
;h=3D2a5a5ec620a29d4ba07743c3151cdf0a417c8f8c
> http://git.kernel.org/?p=3Dlinux/kernel/git/next/linux-next.git;a=3Dpatch=
;h=3D3c4e0df028935618d052235ba85bc7079be13394
>=20
>=20
> Regards,
> Andrei

--=20
Andrei Popa
(+4) 0741.57.80.90


--=-HdgeBrUNQ9g8GHAm8M8g
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgMFADCABgkqhkiG9w0BBwEAAKCCDu0w
ggSdMIIDhaADAgECAhA0PekrrCc0/4/LNJT7zHBUMA0GCSqGSIb3DQEBBQUAMG8xCzAJBgNVBAYT
AlNFMRQwEgYDVQQKEwtBZGRUcnVzdCBBQjEmMCQGA1UECxMdQWRkVHJ1c3QgRXh0ZXJuYWwgVFRQ
IE5ldHdvcmsxIjAgBgNVBAMTGUFkZFRydXN0IEV4dGVybmFsIENBIFJvb3QwHhcNMDUwNjA3MDgw
OTEwWhcNMjAwNTMwMTA0ODM4WjCBrjELMAkGA1UEBhMCVVMxCzAJBgNVBAgTAlVUMRcwFQYDVQQH
Ew5TYWx0IExha2UgQ2l0eTEeMBwGA1UEChMVVGhlIFVTRVJUUlVTVCBOZXR3b3JrMSEwHwYDVQQL
ExhodHRwOi8vd3d3LnVzZXJ0cnVzdC5jb20xNjA0BgNVBAMTLVVUTi1VU0VSRmlyc3QtQ2xpZW50
IEF1dGhlbnRpY2F0aW9uIGFuZCBFbWFpbDCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEB
ALI5haTyfatBO2JGN67NwWB1vDll+UoaR6K5zEjMapjVTTUZuaRC5c5J4oovHnzSMQfHTrSDZJ0u
KdWiZMSFvYVRNXmkTmiQexx6pJKoF/KYFfKTzMmkMpW7DE8wvZigC4vlbhuiRvp4vKJvq1lepS/P
ytptqi/rrKGzaqq3Lmc1i3nhHmmI4uZGzaCl6r4LznY6eg6b6vzaJ1s9cx8i5khhxkzzabGoLhu2
1DEgLLyCio6kDqXXiUP8FlqvHXHXEVnauocNr/rz4cLwpMVnjNbWVDreCqS6A3ezZcj9HtN0YqoY
ymiTHqGFfvVHZcv4TVcodNI0/zC27vZiMBSMLOsCAwEAAaOB9DCB8TAfBgNVHSMEGDAWgBStvZh6
NLQm9/rEJlTvA73gJMtUGjAdBgNVHQ4EFgQUiYJnfcSdJnAAS7RQSHzePa4Ebn0wDgYDVR0PAQH/
BAQDAgEGMA8GA1UdEwEB/wQFMAMBAf8wEQYDVR0gBAowCDAGBgRVHSAAMEQGA1UdHwQ9MDswOaA3
oDWGM2h0dHA6Ly9jcmwudXNlcnRydXN0LmNvbS9BZGRUcnVzdEV4dGVybmFsQ0FSb290LmNybDA1
BggrBgEFBQcBAQQpMCcwJQYIKwYBBQUHMAGGGWh0dHA6Ly9vY3NwLnVzZXJ0cnVzdC5jb20wDQYJ
KoZIhvcNAQEFBQADggEBAAG8nONjKLDzMQHC33vdYqABnSMxD5ySc1NR6h9M+tafxMovZ354Mw90
FrmRh5H1iib6ZHAA2B75CwRiUIeTgdTa9SPbNLuFVrRwNG54gzcehRzFERWSX4cXvaxq/fHC0cyJ
X7F88D5R8jXzfOxgmGs6K+Dv37N9huu1G/Vb7KJ8mBPXAFC50S1z3gN4dOEFhTFey5q5nZTGuZQ3
dXLcRPtn6PD6JR5Sp9ol6UfgoMc8oE6xCjb7d0if75eK+7T+45QUqIO8XC0/0mBxYO7CcYIM6Yg2
49ogtKOgbKqWS7iAjnXKSQf2OxS639wF2Z/b4LLmTaB4JufnLW5/X8YeiBUwggUaMIIEAqADAgEC
AhBtGeqnGU9qMyLmIjJ6qnHeMA0GCSqGSIb3DQEBBQUAMIGuMQswCQYDVQQGEwJVUzELMAkGA1UE
CBMCVVQxFzAVBgNVBAcTDlNhbHQgTGFrZSBDaXR5MR4wHAYDVQQKExVUaGUgVVNFUlRSVVNUIE5l
dHdvcmsxITAfBgNVBAsTGGh0dHA6Ly93d3cudXNlcnRydXN0LmNvbTE2MDQGA1UEAxMtVVROLVVT
RVJGaXJzdC1DbGllbnQgQXV0aGVudGljYXRpb24gYW5kIEVtYWlsMB4XDTExMDQyODAwMDAwMFoX
DTIwMDUzMDEwNDgzOFowgZMxCzAJBgNVBAYTAkdCMRswGQYDVQQIExJHcmVhdGVyIE1hbmNoZXN0
ZXIxEDAOBgNVBAcTB1NhbGZvcmQxGjAYBgNVBAoTEUNPTU9ETyBDQSBMaW1pdGVkMTkwNwYDVQQD
EzBDT01PRE8gQ2xpZW50IEF1dGhlbnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0EwggEiMA0G
CSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCShIRbS1eY1F4vi6ThQMijU1hfZmXxMk73nzJ9VdB4
TFW3QpTg+SdxB8XGaaS5MsTxQBqQzCdWYn8XtXFpruUgG+TLY15gyqJB9mrho/+43x9IbWVDjCou
K2M4d9+xF6zC2oIC1tQyatRnbyATj1w1+uVUgK/YcQodNwoCUFNslR2pEBS0mZVZEjH/CaLSTNxS
297iQAFbSGjdxUq04O0kHzqvcV8H46y/FDuwJXFoPfQP1hdYRhWBPGiLi4MPbXohV+Y0sNsyfuNK
4aVScmQmkU6lkg//4LFg/RpvaFGZY40ai6XMQpubfSJj06mg/M6ekN9EGfRcWzW6FvOnm//BAgMB
AAGjggFLMIIBRzAfBgNVHSMEGDAWgBSJgmd9xJ0mcABLtFBIfN49rgRufTAdBgNVHQ4EFgQUehNO
AHRbxnhjZCfBL+KgW7x5xXswDgYDVR0PAQH/BAQDAgEGMBIGA1UdEwEB/wQIMAYBAf8CAQAwEQYD
VR0gBAowCDAGBgRVHSAAMFgGA1UdHwRRME8wTaBLoEmGR2h0dHA6Ly9jcmwudXNlcnRydXN0LmNv
bS9VVE4tVVNFUkZpcnN0LUNsaWVudEF1dGhlbnRpY2F0aW9uYW5kRW1haWwuY3JsMHQGCCsGAQUF
BwEBBGgwZjA9BggrBgEFBQcwAoYxaHR0cDovL2NydC51c2VydHJ1c3QuY29tL1VUTkFkZFRydXN0
Q2xpZW50X0NBLmNydDAlBggrBgEFBQcwAYYZaHR0cDovL29jc3AudXNlcnRydXN0LmNvbTANBgkq
hkiG9w0BAQUFAAOCAQEAhda+eFdVbTN/RFL+QtUGqAEDgIr7DbL9Sr/2r0FJ9RtaxdKtG3NuPukm
fOZMmMEwKN/L+0I8oSU+CnXW0D05hmbRoZu1TZtvryhsHa/l6nRaqNqxwPF1ei+eupN5yv7ikR5W
dLL4jdPgQ3Ib7Y/9YDkgR/uLrzplSDyYPaUlv73vYOBJ5RbI6z9Dg/Dg7g3B080zX5vQvWBqszv+
+tTJOjwf7Zv/m0kzvkIpOYPuM2kugp1FTahp2oAbHj3SGl18R5mlmwhtEpmG1l1XBxunML5LSUS4
kH7K0Xk467Qz+qA6XSZYnmFVGLQh1ZnV4ENAQjC+6qXnlNKw/vN1+X9u5zCCBSowggQSoAMCAQIC
EQCC1iLWCNlC//08NoDW0yDKMA0GCSqGSIb3DQEBBQUAMIGTMQswCQYDVQQGEwJHQjEbMBkGA1UE
CBMSR3JlYXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxmb3JkMRowGAYDVQQKExFDT01PRE8g
Q0EgTGltaXRlZDE5MDcGA1UEAxMwQ09NT0RPIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2Vj
dXJlIEVtYWlsIENBMB4XDTExMDczMDAwMDAwMFoXDTEyMDcyOTIzNTk1OVowJTEjMCEGCSqGSIb3
DQEJARYUYW5kcmVpLnBvcGFAaS1uZW8ucm8wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIB
AQDC7/8Wo7gDAqT2EkXadu9fEj4lW88MRYTy3axwSw8xnKZjAEK7opewFhj+a5VgXwS5yTSfbBl1
8wwSoApW2trvCZeUHJvQ0XTXJvfEzCjz8vJkqUu/3qNBLkxWQGq/7ZIDF7oi8fUi8qUQJutfMl9O
qfjscSAhCsbBy/Z2y3cijVVSkOJSpe7YTfO8FeOEGOR0xf2AiZ2K/4kJHNRB94L6Np7AgzAWaK/I
7kRVjnaR2ToltdvwVEwpCyLAIwdhb/M7HfpiB4pdx3zUagnF3deK+2/DpbqxkBVzIb/Jl9tC8qA5
kqcxtRBqGBQsQyj9ixaAXuxnozgl/hYulf2fcMLRAgMBAAGjggHkMIIB4DAfBgNVHSMEGDAWgBR6
E04AdFvGeGNkJ8Ev4qBbvHnFezAdBgNVHQ4EFgQUNOswJ18cdPpt45Hjk7cuY+8mZIcwDgYDVR0P
AQH/BAQDAgWgMAwGA1UdEwEB/wQCMAAwIAYDVR0lBBkwFwYIKwYBBQUHAwQGCysGAQQBsjEBAwUC
MBEGCWCGSAGG+EIBAQQEAwIFIDBGBgNVHSAEPzA9MDsGDCsGAQQBsjEBAgEBATArMCkGCCsGAQUF
BwIBFh1odHRwczovL3NlY3VyZS5jb21vZG8ubmV0L0NQUzBXBgNVHR8EUDBOMEygSqBIhkZodHRw
Oi8vY3JsLmNvbW9kb2NhLmNvbS9DT01PRE9DbGllbnRBdXRoZW50aWNhdGlvbmFuZFNlY3VyZUVt
YWlsQ0EuY3JsMIGIBggrBgEFBQcBAQR8MHowUgYIKwYBBQUHMAKGRmh0dHA6Ly9jcnQuY29tb2Rv
Y2EuY29tL0NPTU9ET0NsaWVudEF1dGhlbnRpY2F0aW9uYW5kU2VjdXJlRW1haWxDQS5jcnQwJAYI
KwYBBQUHMAGGGGh0dHA6Ly9vY3NwLmNvbW9kb2NhLmNvbTAfBgNVHREEGDAWgRRhbmRyZWkucG9w
YUBpLW5lby5ybzANBgkqhkiG9w0BAQUFAAOCAQEAO7mdp0TD7EDtK8g3pBvTLB6RyFeN9kuskL9y
V7LSd3XMRM6nFQXDXY44mTMBKfMqIxzWdO8TNvkuBDeUsRS2XpgoHmaVYXrYOZbtTHsbDjYvOOG4
PtTqF3gvUooC3a7TylM3TdIAm4I3DFKxDDh3uJGh7d+G1tgjC0iCEh/xquZLpj/B3Mahp8QWODWb
u6Nzql/2ar8cz66JGjEjrOcSTB+zKVN6YY8o1JscMYsjKe1g4Dq0kq3NkFpSvgBzerdT7Au5haLY
+vw6WZwhMPjLdWRqd8Lk5vB0PGNOU1HpoQhsE8Wd0dr5t8S3lTnWmlHy4G6+H1XmwSkm8RxHEjAt
DzGCAmEwggJdAgEBMIGpMIGTMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVz
dGVyMRAwDgYDVQQHEwdTYWxmb3JkMRowGAYDVQQKExFDT01PRE8gQ0EgTGltaXRlZDE5MDcGA1UE
AxMwQ09NT0RPIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBAhEAgtYi
1gjZQv/9PDaA1tMgyjANBglghkgBZQMEAgMFAKCBiTAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcB
MBwGCSqGSIb3DQEJBTEPFw0xMjA0MjYwNjQ1MjlaME8GCSqGSIb3DQEJBDFCBEBNDGeymXyjBPor
kkw4D81bM/RH6rIw2d5pr88ipB7y5V+qt3hIjLQZXWWVyQ98w4SZdu/qg9eoaflLb70oacbtMA0G
CSqGSIb3DQEBAQUABIIBAL3Wj4ZsBA0o9RVrUZCoLVbQRk3AFnyeeeuSgJlBKMXkHSlvXIbQv9Ly
Kk7Duor++hCmnn/9ICxYXbqjaLfdPGTduxti7Ya4flsgOKL1zmVlds4ZfODAgCL2J1yI3jvdfxfP
mg5sXSYSXSb7cJdFRPaJFm255bdr8w0ma9l0Sv+RZVGjJqpBeKy+ffOGf6V/FYrCMCrIo7DSB+Uv
FUAez0Y+fPvyBpvTo4ZEaPO8WOI9DJ4zb+aWDUg0FLkgHZoPDdYnw81bXkorLWqxLZi9zdRN08zI
AD+etTlnvzbGtN7L+E2X7n+AQYzGWvwoz6JM929ughBqSbDtDiXFQCLAFJIAAAAAAAA=


--=-HdgeBrUNQ9g8GHAm8M8g--

