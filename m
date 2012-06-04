Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760385Ab2FDNLC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 09:11:02 -0400
Received: from mail2.dkrz.de ([136.172.12.2]:58283 "EHLO mail2.dkrz.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751483Ab2FDNLA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 09:11:00 -0400
X-Greylist: delayed 1148 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 Jun 2012 09:10:59 EDT
Message-ID: <4FCCAF5D.7050808@dkrz.de>
Date: Mon, 04 Jun 2012 14:51:41 +0200
From: Thomas Jahns <jahns@dkrz.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120506 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: linux-ide@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: ASMedia 106x devices
X-Enigmail-Version: 1.0.1
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms060705070909030407070209"
X-Greylist: Sender succeeded STARTTLS authentication, not delayed by milter-greylist-4.2.7 (mail2.dkrz.de [IPv6:2001:638:70e:10c::2]); Mon, 04 Jun 2012 14:51:44 +0200 (CEST)
X-Spam-Report: * -0.0 T_RP_MATCHES_RCVD Envelope sender domain matches handover relay
	*      domain
	* -1.9 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms060705070909030407070209
Content-Type: multipart/mixed;
 boundary="------------020702050204050007070401"

This is a multi-part message in MIME format.
--------------020702050204050007070401
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hello,

I found a description on how to make the following device functional in L=
inux at

https://bugzilla.kernel.org/show_bug.cgi?id=3D42804

My adapter is a USB 3.0/S-ATA 6g controller which shows up as follows
(after patching kernel 3.2.17 as distributed by Debian):

$ lspci -v
04:00.0 USB Controller: Device 1b21:1040 (prog-if 30)
	Subsystem: Device 174c:2104
	Flags: bus master, fast devsel, latency 0, IRQ 17
	Memory at d2100000 (64-bit, non-prefetchable) [size=3D32K]
	Capabilities: <access denied>
	Kernel driver in use: xhci_hcd

05:00.0 IDE interface: Device 1b21:0611 (rev 01) (prog-if 85 [Master SecO=
 PriO])
	Subsystem: Device 1b21:1060
	Flags: bus master, fast devsel, latency 0, IRQ 51
	I/O ports at 5020 [size=3D8]
	I/O ports at 5014 [size=3D4]
	I/O ports at 5018 [size=3D8]
	I/O ports at 5010 [size=3D4]
	I/O ports at 5000 [size=3D16]
	Memory at d2200000 (32-bit, non-prefetchable) [size=3D512]
	Capabilities: <access denied>
	Kernel driver in use: ahci

Therefore I wanted to ask someone to please apply the attached patch.

Like the original author, Hiroaki Nito, I've had good experience using th=
is
patch with my card, a Delock 89299.

The patch fixes, from my incomplete understanding, the fact that the devi=
ce
"lies" about its capabilities, by presenting itself as an IDE device when=
 in
fact it's an AHCI controller.

I hope this completes the process. Which, from my investigation of the em=
ail
archive, Hiroaki Nito started, but did not follow through because the adv=
ice to
follow Documentation/SubmittingPatches was given much later.

Regards, Thomas Jahns

P.S.: I'm not subscribed to either linux-ide or linux-kernel. So, if this=
 patch
is still insufficient to be included, please email me directly.
--=20
Thomas Jahns
DKRZ GmbH, Department: Application software

Deutsches Klimarechenzentrum
Bundesstra=DFe 45a
D-20146 Hamburg

Phone: +49-40-460094-151
Fax: +49-40-460094-270
Email: Thomas Jahns <jahns@dkrz.de>

--------------020702050204050007070401
Content-Type: text/x-patch;
 name="ahci-asmedia.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="ahci-asmedia.patch"

Author: Hiroaki Nito
Signed-off-by: Thomas Jahns <jahns@dkrz.de>
--- a/drivers/ata/ahci.c	2012-05-20 23:56:54.000000000 +0200
+++ b/drivers/ata/ahci.c	2012-05-31 14:51:01.577045033 +0200
@@ -391,6 +391,9 @@
 	{ PCI_VDEVICE(PROMISE, 0x3f20), board_ahci },	/* PDC42819 */
=20
 	/* Asmedia */
+        { PCI_VDEVICE(ASMEDIA, 0x0601), board_ahci },   /* ASM106x */
+        { PCI_VDEVICE(ASMEDIA, 0x0602), board_ahci },   /* ASM106x */
+        { PCI_VDEVICE(ASMEDIA, 0x0611), board_ahci },   /* ASM1061 */
 	{ PCI_VDEVICE(ASMEDIA, 0x0612), board_ahci },	/* ASM1061 */
=20
 	/* Generic, PCI class code for AHCI */

--------------020702050204050007070401--

--------------ms060705070909030407070209
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIITUDCC
BCEwggMJoAMCAQICAgDHMA0GCSqGSIb3DQEBBQUAMHExCzAJBgNVBAYTAkRFMRwwGgYDVQQK
ExNEZXV0c2NoZSBUZWxla29tIEFHMR8wHQYDVQQLExZULVRlbGVTZWMgVHJ1c3QgQ2VudGVy
MSMwIQYDVQQDExpEZXV0c2NoZSBUZWxla29tIFJvb3QgQ0EgMjAeFw0wNjEyMTkxMDI5MDBa
Fw0xOTA2MzAyMzU5MDBaMFoxCzAJBgNVBAYTAkRFMRMwEQYDVQQKEwpERk4tVmVyZWluMRAw
DgYDVQQLEwdERk4tUEtJMSQwIgYDVQQDExtERk4tVmVyZWluIFBDQSBHbG9iYWwgLSBHMDEw
ggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDpm8NnhfkNrvWNVMOWUDU9YuluTO2U
1wBblSJ01CDrNI/W7MAxBAuZgeKmFNJSoCgjhIt0iQReW+DieMF4yxbLKDU5ey2QRdDtoAB6
fL9KDhsAw4bpXCsxEXsM84IkQ4wcOItqaACa7txPeKvSxhObdq3u3ibo7wGvdA/BCaL2a869
080UME/15eOkyGKbghoDJzANAmVgTe3RCSMqljVYJ9N2xnG2kB3E7f81hn1vM7PbD8URwoqD
oZRdQWvY0hD1TP3KUazZve+Sg7va64sWVlZDz+HVEz2mHycwzUlU28kTNJpxdcVs6qcLmPkh
nSevPqM5OUhqjK3JmfvDEvK9AgMBAAGjgdkwgdYwcAYDVR0fBGkwZzBloGOgYYZfaHR0cDov
L3BraS50ZWxlc2VjLmRlL2NnaS1iaW4vc2VydmljZS9hZl9Eb3dubG9hZEFSTC5jcmw/LWNy
bF9mb3JtYXQ9WF81MDkmLWlzc3Vlcj1EVF9ST09UX0NBXzIwHQYDVR0OBBYEFEm3xs/oPR9/
6kR7Eyn38QpwPt5kMB8GA1UdIwQYMBaAFDHDeRu69VPXF+CJei0XbAqzK50zMA4GA1UdDwEB
/wQEAwIBBjASBgNVHRMBAf8ECDAGAQH/AgECMA0GCSqGSIb3DQEBBQUAA4IBAQA74Vp3wEgX
3KkY7IGvWonwvSiSpspZGBJw7Cjy565/lizn8l0ZMfYTK3S9vYCyufdnyTmieTvhERHua3iR
M347XyYndVNljjNj7s9zw7CSI0khUHUjoR8Y4pSFPT8z6XcgjaK95qGFKUD2P3MyWA0Ja6ba
hWzAP7uNZmRWJE6uDT8yNQFb6YyC2XJZT7GGhfF0hVblw/hc843uR7NTBXDn5U2KaYMo4RMJ
hp5eyOpYHgwf+aTUWgRo/Sg+iwK2WLX2oSw3VwBnqyNojWOl75lrXP1LVvarQIc01BGSbOyH
xQoLBzNytG8MHVQs2FHHzL8w00Ny8TK/jM5JY6gA9/IcMIIE8TCCA9mgAwIBAgIECgyxeTAN
BgkqhkiG9w0BAQUFADBaMQswCQYDVQQGEwJERTETMBEGA1UEChMKREZOLVZlcmVpbjEQMA4G
A1UECxMHREZOLVBLSTEkMCIGA1UEAxMbREZOLVZlcmVpbiBQQ0EgR2xvYmFsIC0gRzAxMB4X
DTA3MDMwNjA5MjcwNloXDTE5MDMwNTAwMDAwMFowbTELMAkGA1UEBhMCREUxKjAoBgNVBAoT
IURldXRzY2hlcyBLbGltYXJlY2hlbnplbnRydW0gR21iSDEWMBQGA1UEAxMNREtSWiBDQSAt
IEcwMjEaMBgGCSqGSIb3DQEJARYLcGtpQGRrcnouZGUwggEiMA0GCSqGSIb3DQEBAQUAA4IB
DwAwggEKAoIBAQCqhnbMtlVx2/scupWN3EJJYUWc1C2wnH5KrT2EZxUS41fKjm/rwfXBtpsb
ODSoEEAIsO0MJg0KhhTx3c6WBIIArZqDF7xfZhY1IbJu4qIzsOQz67cLMF+6SOwLYvJO+W8l
BFUVKa0ImVHLvSP6CGq1ySZD6sM4ZfYu9kyxkqx2gGz8ERUZL9x+/JUIa8fC2IGnIrpalgKB
hZBE/8L5AaAP8W4SeZQ0s/Moy8kCbN8YXiXConE+C8XvumN0XwVDEz4gf85To4FTv121Q+KV
9lXWxVmqNyAxfwb2k8Q0SAvs6Ji1rWEKTqc9PR3yD8Q41l00nXj8QmzUELyWFAN32RwbAgMB
AAGjggGqMIIBpjAPBgNVHRMBAf8EBTADAQH/MAsGA1UdDwQEAwIBBjAdBgNVHQ4EFgQUqzPo
OiMdOS5e4AWiCVkpSC3s5jYwHwYDVR0jBBgwFoAUSbfGz+g9H3/qRHsTKffxCnA+3mQwFgYD
VR0RBA8wDYELcGtpQGRrcnouZGUwgYgGA1UdHwSBgDB+MD2gO6A5hjdodHRwOi8vY2RwMS5w
Y2EuZGZuLmRlL2dsb2JhbC1yb290LWNhL3B1Yi9jcmwvY2FjcmwuY3JsMD2gO6A5hjdodHRw
Oi8vY2RwMi5wY2EuZGZuLmRlL2dsb2JhbC1yb290LWNhL3B1Yi9jcmwvY2FjcmwuY3JsMIGi
BggrBgEFBQcBAQSBlTCBkjBHBggrBgEFBQcwAoY7aHR0cDovL2NkcDEucGNhLmRmbi5kZS9n
bG9iYWwtcm9vdC1jYS9wdWIvY2FjZXJ0L2NhY2VydC5jcnQwRwYIKwYBBQUHMAKGO2h0dHA6
Ly9jZHAyLnBjYS5kZm4uZGUvZ2xvYmFsLXJvb3QtY2EvcHViL2NhY2VydC9jYWNlcnQuY3J0
MA0GCSqGSIb3DQEBBQUAA4IBAQDLJ4vuu+mrQURE+IiAeArFJN0ANThgTAM/vc1CgzxrzrCP
raTfxWmHvxLQmEJuliqmFuHLhYWQK/zaU8RreFdNTd5gslTml+v6am6ZJlew6BxhpfjOwdS6
X5SFqfmRM+SzrFDZaklrIF1qbspCpMrec/Cd+E9Up3dY8Or6sPPh8uayKdLNzrMYmNdG+olF
hBOzo1CeJng5k1h2BYgyq8TdTXU0lmZy/wyefajoGvfPJKWtE5iE1Ld+VykQF40SkBPaoYj3
4hOXDKTlz2qqt0Rx+lpjLJXX1OiJaI+XU39wUTVMZYLK4WYGoAxERUovlNHcg9SzU3SHhNTF
KnmiEP0yMIIFFzCCA/+gAwIBAgIEDqDqxzANBgkqhkiG9w0BAQUFADBtMQswCQYDVQQGEwJE
RTEqMCgGA1UEChMhRGV1dHNjaGVzIEtsaW1hcmVjaGVuemVudHJ1bSBHbWJIMRYwFAYDVQQD
Ew1ES1JaIENBIC0gRzAyMRowGAYJKoZIhvcNAQkBFgtwa2lAZGtyei5kZTAeFw0wOTA4MTEx
MzA4MDhaFw0xMjA4MTAxMzA4MDhaMG8xCzAJBgNVBAYTAkRFMSowKAYDVQQKEyFEZXV0c2No
ZXMgS2xpbWFyZWNoZW56ZW50cnVtIEdtYkgxHTAbBgNVBAsTFEFwcGxpY2F0aW9uIFNvZnR3
YXJlMRUwEwYDVQQDEwxUaG9tYXMgSmFobnMwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEK
AoIBAQC5dsWM41nkS7Y8cSDnINmTCHeldyOL/EkHKKV1YFJwI2CY4fee/NfH/2LS1DPC7aFe
oKT6PuImohUfl7OOtsXDbg/GYalkS3SM3MvxDIkLXHJ56z2Prx9ahHF0QOML+4qz/E3B/w8W
lShDY368s/9XB0D80YA4haBl34Zy2ljg9sfr6QRthSfw9e6Cz1cUp4hZLo08Uv9v/arfaHDV
VZnCVRTCIy5CtNR6B6Iqii2/jplwfvNHLU0L8k5Gmhw/awMKqnilajE7tvqPr0dupjjCNkVc
ehn60vhSo4cQrac2Ej0TrOyXOZ86SK7fanj7KNXesg3PjH7zpA5fOu8keYCjAgMBAAGjggG7
MIIBtzAJBgNVHRMEAjAAMAsGA1UdDwQEAwIF4DApBgNVHSUEIjAgBggrBgEFBQcDAgYIKwYB
BQUHAwQGCisGAQQBgjcUAgIwHQYDVR0OBBYEFEf50vzRtbPDYOhu5TBuLuEBLFg5MB8GA1Ud
IwQYMBaAFKsz6DojHTkuXuAFoglZKUgt7OY2MBgGA1UdEQQRMA+BDWphaG5zQGRrcnouZGUw
fQYDVR0fBHYwdDA4oDagNIYyaHR0cDovL2NkcDEucGNhLmRmbi5kZS9ka3J6LWNhL3B1Yi9j
cmwvZ19jYWNybC5jcmwwOKA2oDSGMmh0dHA6Ly9jZHAyLnBjYS5kZm4uZGUvZGtyei1jYS9w
dWIvY3JsL2dfY2FjcmwuY3JsMIGYBggrBgEFBQcBAQSBizCBiDBCBggrBgEFBQcwAoY2aHR0
cDovL2NkcDEucGNhLmRmbi5kZS9ka3J6LWNhL3B1Yi9jYWNlcnQvZ19jYWNlcnQuY3J0MEIG
CCsGAQUFBzAChjZodHRwOi8vY2RwMi5wY2EuZGZuLmRlL2RrcnotY2EvcHViL2NhY2VydC9n
X2NhY2VydC5jcnQwDQYJKoZIhvcNAQEFBQADggEBAGlZQcy433DZWh4cDXu8IAqKZdWI6H0R
ww50Nc3wPfZsuaweR3++OgPLfCmEAvGdD0c+ePEOD9VXTv/CoUoRRItkTMudEvlMgBQAzG7K
tCeSez6e4X901UNQPxGhfwU85yfMf4tu18fG/mJcPKCVdIC7mSVFlEzDkvWSv/sQGOa0hV/9
TA1WzYqHivTCQRrlfLhm8EQ+zXwKc6gxbRah8ruemgeTpcBxGfjsC4eDPisb0wuga6+9iFfn
0+nBhRGwHa/bWp0bJYTs1iDxk9bWNYXLPnKKYivy09kXQINakZDd9R/zwyupGVpWcF6gpXIg
4w5I+LfhzV4b+u7apbtWaAkwggUXMIID/6ADAgECAgQOoOrHMA0GCSqGSIb3DQEBBQUAMG0x
CzAJBgNVBAYTAkRFMSowKAYDVQQKEyFEZXV0c2NoZXMgS2xpbWFyZWNoZW56ZW50cnVtIEdt
YkgxFjAUBgNVBAMTDURLUlogQ0EgLSBHMDIxGjAYBgkqhkiG9w0BCQEWC3BraUBka3J6LmRl
MB4XDTA5MDgxMTEzMDgwOFoXDTEyMDgxMDEzMDgwOFowbzELMAkGA1UEBhMCREUxKjAoBgNV
BAoTIURldXRzY2hlcyBLbGltYXJlY2hlbnplbnRydW0gR21iSDEdMBsGA1UECxMUQXBwbGlj
YXRpb24gU29mdHdhcmUxFTATBgNVBAMTDFRob21hcyBKYWhuczCCASIwDQYJKoZIhvcNAQEB
BQADggEPADCCAQoCggEBALl2xYzjWeRLtjxxIOcg2ZMId6V3I4v8SQcopXVgUnAjYJjh9578
18f/YtLUM8LtoV6gpPo+4iaiFR+Xs462xcNuD8ZhqWRLdIzcy/EMiQtccnnrPY+vH1qEcXRA
4wv7irP8TcH/DxaVKENjfryz/1cHQPzRgDiFoGXfhnLaWOD2x+vpBG2FJ/D17oLPVxSniFku
jTxS/2/9qt9ocNVVmcJVFMIjLkK01HoHoiqKLb+OmXB+80ctTQvyTkaaHD9rAwqqeKVqMTu2
+o+vR26mOMI2RVx6GfrS+FKjhxCtpzYSPROs7Jc5nzpIrt9qePso1d6yDc+MfvOkDl867yR5
gKMCAwEAAaOCAbswggG3MAkGA1UdEwQCMAAwCwYDVR0PBAQDAgXgMCkGA1UdJQQiMCAGCCsG
AQUFBwMCBggrBgEFBQcDBAYKKwYBBAGCNxQCAjAdBgNVHQ4EFgQUR/nS/NG1s8Ng6G7lMG4u
4QEsWDkwHwYDVR0jBBgwFoAUqzPoOiMdOS5e4AWiCVkpSC3s5jYwGAYDVR0RBBEwD4ENamFo
bnNAZGtyei5kZTB9BgNVHR8EdjB0MDigNqA0hjJodHRwOi8vY2RwMS5wY2EuZGZuLmRlL2Rr
cnotY2EvcHViL2NybC9nX2NhY3JsLmNybDA4oDagNIYyaHR0cDovL2NkcDIucGNhLmRmbi5k
ZS9ka3J6LWNhL3B1Yi9jcmwvZ19jYWNybC5jcmwwgZgGCCsGAQUFBwEBBIGLMIGIMEIGCCsG
AQUFBzAChjZodHRwOi8vY2RwMS5wY2EuZGZuLmRlL2RrcnotY2EvcHViL2NhY2VydC9nX2Nh
Y2VydC5jcnQwQgYIKwYBBQUHMAKGNmh0dHA6Ly9jZHAyLnBjYS5kZm4uZGUvZGtyei1jYS9w
dWIvY2FjZXJ0L2dfY2FjZXJ0LmNydDANBgkqhkiG9w0BAQUFAAOCAQEAaVlBzLjfcNlaHhwN
e7wgCopl1YjofRHDDnQ1zfA99my5rB5Hf746A8t8KYQC8Z0PRz548Q4P1VdO/8KhShFEi2RM
y50S+UyAFADMbsq0J5J7Pp7hf3TVQ1A/EaF/BTznJ8x/i27Xx8b+Ylw8oJV0gLuZJUWUTMOS
9ZK/+xAY5rSFX/1MDVbNioeK9MJBGuV8uGbwRD7NfApzqDFtFqHyu56aB5OlwHEZ+OwLh4M+
KxvTC6Brr72IV+fT6cGFEbAdr9tanRslhOzWIPGT1tY1hcs+copiK/LT2RdAg1qRkN31H/PD
K6kZWlZwXqClciDjDkj4t+HNXhv67tqlu1ZoCTGCA24wggNqAgEBMHUwbTELMAkGA1UEBhMC
REUxKjAoBgNVBAoTIURldXRzY2hlcyBLbGltYXJlY2hlbnplbnRydW0gR21iSDEWMBQGA1UE
AxMNREtSWiBDQSAtIEcwMjEaMBgGCSqGSIb3DQEJARYLcGtpQGRrcnouZGUCBA6g6scwCQYF
Kw4DAhoFAKCCAc4wGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcN
MTIwNjA0MTI1MTQxWjAjBgkqhkiG9w0BCQQxFgQUAW00usiEXU5hCvxyVXi6vdQRYr4wXwYJ
KoZIhvcNAQkPMVIwUDALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCA
MA0GCCqGSIb3DQMCAgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGEBgkrBgEEAYI3EAQx
dzB1MG0xCzAJBgNVBAYTAkRFMSowKAYDVQQKEyFEZXV0c2NoZXMgS2xpbWFyZWNoZW56ZW50
cnVtIEdtYkgxFjAUBgNVBAMTDURLUlogQ0EgLSBHMDIxGjAYBgkqhkiG9w0BCQEWC3BraUBk
a3J6LmRlAgQOoOrHMIGGBgsqhkiG9w0BCRACCzF3oHUwbTELMAkGA1UEBhMCREUxKjAoBgNV
BAoTIURldXRzY2hlcyBLbGltYXJlY2hlbnplbnRydW0gR21iSDEWMBQGA1UEAxMNREtSWiBD
QSAtIEcwMjEaMBgGCSqGSIb3DQEJARYLcGtpQGRrcnouZGUCBA6g6scwDQYJKoZIhvcNAQEB
BQAEggEATlW2eBfC071bMNI3oFzDWLNwsOL4r5si/EsvdSbXCvmC32gVUoOJpglNZV9m12ZC
1d4o7uElfdUB1NwacJmB5QJvzYvjNna8IKzuMMnNiGFoz9zmv769oTL3UekHYvCEKWJJ3Q3f
tf6wLivUsmArZG6a6gBf9tNqwtkv+vM+sjrZP7Q4w0A0wMgeFQb03NLB8iHL02yjHr6Gnx6C
4jChfg2igRyWrkAgaPAzkVvJUSlYnx0Kijh/bpASVAnWA+rXgNSIzgoB0Dmhn2c9hag59Z+A
/hYs8VIy3fw9ioWfK4vdb8I6rl8tuTg+ad9nirUtaRlPy4g49jXXIr4EGyg3SAAAAAAAAA==
--------------ms060705070909030407070209--
