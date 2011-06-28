Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756844Ab1F1HtV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 03:49:21 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36991 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756150Ab1F1Hsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 03:48:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=BpcY/XVXgZiCYV85v//5S3HyXjoY1oOFOPavyJWEiCRjkqrePJOpmrkRb6qajOA12q
         tURxsDCmZFZVnu67sD4y63FGhUT92QzFC2BnwnYJ1i4SBOxiOoSWrMClxOSt7vGMe66X
         6sJYXN1q5Y+pl3diTuUOAhKmBBfgIJZAbN/Ss=
MIME-Version: 1.0
Date: Tue, 28 Jun 2011 03:48:38 -0400
Message-ID: <CAJRGBZw6cqqPmR9rxfKOeT69vpOLFFBr842Yy4A1_VbLX=r+1Q@mail.gmail.com>
Subject: [PATCH] fix memory leak in acpi-cpufreq
From: Luming Yu <luming.yu@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Len Brown <lenb@kernel.org>
Content-Type: multipart/mixed; boundary=90e6ba2121735d96d904a6c0e5bb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--90e6ba2121735d96d904a6c0e5bb
Content-Type: text/plain; charset=UTF-8

Hi there,

I came across a memory leak problem found in cyclic cpu-online-offline test.
The inlined patch simple does this to fix it.

> b/drivers/cpufreq/acpi-cpufreq.c
>static void __exit acpi_cpufreq_exit(void)
>  	cpufreq_unregister_driver(&acpi_cpufreq_driver);
> -	free_percpu(acpi_perf_data);
>+	free_acpi_perf_data();

Ps. The patch is enclosed in attachment. The inline one
is c&p of it for reading.


Thanks,
Luming

Signed-off-by: Yu Luming <luming.yu@intel.com>

--90e6ba2121735d96d904a6c0e5bb
Content-Type: text/x-diff; charset=US-ASCII; name="acpi-cpufreq-memleak.patch"
Content-Disposition: attachment; filename="acpi-cpufreq-memleak.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gpgjv3m50

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvY3B1ZnJlcS9hY3BpLWNwdWZyZXEuYyBiL2RyaXZlcnMvY3B1
ZnJlcS9hY3BpLWNwdWZyZXEuYwppbmRleCA0ZTA0ZTEyLi41OTZkNWRkIDEwMDY0NAotLS0gYS9k
cml2ZXJzL2NwdWZyZXEvYWNwaS1jcHVmcmVxLmMKKysrIGIvZHJpdmVycy9jcHVmcmVxL2FjcGkt
Y3B1ZnJlcS5jCkBAIC03NTksNyArNzU5LDcgQEAgc3RhdGljIHZvaWQgX19leGl0IGFjcGlfY3B1
ZnJlcV9leGl0KHZvaWQpCiAKIAljcHVmcmVxX3VucmVnaXN0ZXJfZHJpdmVyKCZhY3BpX2NwdWZy
ZXFfZHJpdmVyKTsKIAotCWZyZWVfcGVyY3B1KGFjcGlfcGVyZl9kYXRhKTsKKwlmcmVlX2FjcGlf
cGVyZl9kYXRhKCk7CiB9CiAKIG1vZHVsZV9wYXJhbShhY3BpX3BzdGF0ZV9zdHJpY3QsIHVpbnQs
IDA2NDQpOwo=
--90e6ba2121735d96d904a6c0e5bb--
