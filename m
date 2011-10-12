Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753031Ab1JLMhB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 08:37:01 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:60646 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752654Ab1JLMhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 08:37:00 -0400
MIME-Version: 1.0
Date: Wed, 12 Oct 2011 14:36:59 +0200
Message-ID: <CA+O4pCKMiLK3Z94j1NjVA3Zu-32X=tC-6eZnwGZCQXUTbhiEwA@mail.gmail.com>
Subject: [Patch] Increase USBFS Bulk Transfer size
From: Markus Rechberger <mrechberger@gmail.com>
To: Greg KH <gregkh@suse.de>, Alan Stern <stern@rowland.harvard.edu>,
        USB list <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=20cf303dd278bec88e04af1947c3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--20cf303dd278bec88e04af1947c3
Content-Type: text/plain; charset=ISO-8859-1

We have 2 products which can perform better with increased Bulk transfers

Device No. 1:
According to the hardware spec of on of our product
Available Bulk Transfer Size are:
- 188 * n bytes, where n = 1 ~ 256.

Although we can drive that one with 15K as well when setting the HW
register down to it.

Device No. 2
only creates jitter video with Bulk transfer sizes which are below
24064 bytes, no such chipfeature is available
to decrease the bulk transfer size.
http://sundtek.de/images/dtvjitter2.jpg
with transfer size of 24064:
http://sundtek.de/images/gooddata.jpg

The patch takes the features of Device No. 1 into account allowing a
maximum buffer of 48128 bytes.

Those issues have been evaluated with MacOSX and a customized patched
Linux version.
Device No. 2 also corrupts on MacOSX with too small packet sizes,
Windows and Mac are using 24064 bytes.

Default Bulk Transfersize of device No. 1 is around 1-2k which leads
to very high cpu usage, updating it to 15k lowers that one.

--20cf303dd278bec88e04af1947c3
Content-Type: text/x-patch; charset=US-ASCII; name="devio.c.diff"
Content-Disposition: attachment; filename="devio.c.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gtoauw0p0

LS0tIC4vZHJpdmVycy91c2IvY29yZS9kZXZpby5jX29sZAkyMDExLTEwLTEyIDE0OjIzOjM0LjAw
MDAwMDAwMCArMDIwMAorKysgLi9kcml2ZXJzL3VzYi9jb3JlL2RldmlvLmMJMjAxMS0xMC0xMiAx
NDoyNTozMC4wMDAwMDAwMDAgKzAyMDAKQEAgLTEwNyw3ICsxMDcsNyBAQAogCiAjZGVmaW5lIFVT
Ql9ERVZJQ0VfREVWCQlNS0RFVihVU0JfREVWSUNFX01BSk9SLCAwKQogCi0jZGVmaW5lCU1BWF9V
U0JGU19CVUZGRVJfU0laRQkxNjM4NAorI2RlZmluZQlNQVhfVVNCRlNfQlVGRkVSX1NJWkUJNDgx
MjgKIAogCiBzdGF0aWMgaW50IGNvbm5lY3RlZChzdHJ1Y3QgZGV2X3N0YXRlICpwcykK
--20cf303dd278bec88e04af1947c3--
