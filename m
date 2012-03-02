Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758883Ab2CBQcK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 11:32:10 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:44746 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758838Ab2CBQcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 11:32:08 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of mdeneen@gmail.com designates 10.236.184.8 as permitted sender) smtp.mail=mdeneen@gmail.com; dkim=pass header.i=mdeneen@gmail.com
MIME-Version: 1.0
From: Mark Deneen <mdeneen@gmail.com>
Date: Fri, 2 Mar 2012 11:31:48 -0500
Message-ID: <CAP6JJ88cwdWWKJ9AdaZ=OU1UiUR6jnKv=B=44YNZPNUKNfqLrA@mail.gmail.com>
Subject: [PATCH linux-3.3.0-rc4 1/1] option: add vid/pid for Novatel Ovation MC551
To: linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=20cf3056406727adae04ba451e73
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--20cf3056406727adae04ba451e73
Content-Type: text/plain; charset=ISO-8859-1

This patch adds support for the Novatel MC551 USB cell modem.  The
option driver exposes a usb serial port and some novatel specific AT
commands must be issued in order to initiate a connection.

For documentation purposes, here are the commands:

To connect: At$nwqmiconnect=,,
To disconnect: At$nwqmidisconnect
To get status: At$nwqmistatus
To get signal strength: At$nwrssi


After connecting, a new ethernet interface is available (cdc_ether)
and you can configure the interface with DHCP.

-M

--20cf3056406727adae04ba451e73
Content-Type: text/x-patch; charset=US-ASCII; name="usb_serial_option_novatel_mc551.patch"
Content-Disposition: attachment; 
	filename="usb_serial_option_novatel_mc551.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gzbfq2ki0

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvdXNiL3NlcmlhbC9vcHRpb24uYyBiL2RyaXZlcnMvdXNiL3Nl
cmlhbC9vcHRpb24uYwppbmRleCAzOWVkMWY0Li5jNzliY2I3IDEwMDY0NAotLS0gYS9kcml2ZXJz
L3VzYi9zZXJpYWwvb3B0aW9uLmMKKysrIGIvZHJpdmVycy91c2Ivc2VyaWFsL29wdGlvbi5jCkBA
IC0yMDQsNiArMjA0LDggQEAgc3RhdGljIHZvaWQgb3B0aW9uX2luc3RhdF9jYWxsYmFjayhzdHJ1
Y3QgdXJiICp1cmIpOwogLyogT1ZBVElPTiBQUk9EVUNUUyAqLwogI2RlZmluZSBOT1ZBVEVMV0lS
RUxFU1NfUFJPRFVDVF9NQzcyNwkJMHg0MTAwCiAjZGVmaW5lIE5PVkFURUxXSVJFTEVTU19QUk9E
VUNUX01DOTUwRAkJMHg0NDAwCisjZGVmaW5lIE5PVkFURUxXSVJFTEVTU19QUk9EVUNUX01DNTUx
CQkweEIwMDEKKwogLyoKICAqIE5vdGUgZnJvbSBOb3ZhdGVsIFdpcmVsZXNzOgogICogQWxsIFBJ
RCBpbiB0aGUgNXh4eCByYW5nZSBhcmUgY3VycmVudGx5IHJlc2VydmVkIGZvcgpAQCAtNzE1LDYg
KzcxNyw3IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3QgdXNiX2RldmljZV9pZCBvcHRpb25faWRzW10g
PSB7CiAJeyBVU0JfREVWSUNFKE5PVkFURUxXSVJFTEVTU19WRU5ET1JfSUQsIE5PVkFURUxXSVJF
TEVTU19QUk9EVUNUX0cxKSB9LAogCXsgVVNCX0RFVklDRShOT1ZBVEVMV0lSRUxFU1NfVkVORE9S
X0lELCBOT1ZBVEVMV0lSRUxFU1NfUFJPRFVDVF9HMV9NKSB9LAogCXsgVVNCX0RFVklDRShOT1ZB
VEVMV0lSRUxFU1NfVkVORE9SX0lELCBOT1ZBVEVMV0lSRUxFU1NfUFJPRFVDVF9HMikgfSwKKwl7
IFVTQl9ERVZJQ0VfQU5EX0lOVEVSRkFDRV9JTkZPKE5PVkFURUxXSVJFTEVTU19WRU5ET1JfSUQs
IE5PVkFURUxXSVJFTEVTU19QUk9EVUNUX01DNTUxLCAweGZmLCAweGZmLCAweGZmKSB9LAogCiAJ
eyBVU0JfREVWSUNFKEFNT0lfVkVORE9SX0lELCBBTU9JX1BST0RVQ1RfSDAxKSB9LAogCXsgVVNC
X0RFVklDRShBTU9JX1ZFTkRPUl9JRCwgQU1PSV9QUk9EVUNUX0gwMUEpIH0sCgpTaWduZWQtb2Zm
LWJ5OiBNYXJrIERlbmVlbiA8bWRlbmVlbkBnbWFpbC5jb20+Cg==
--20cf3056406727adae04ba451e73--
