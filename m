Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255Ab1CZEjy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 00:39:54 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60372 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155Ab1CZEjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 00:39:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=Nz5HDb9YnmnxfF3k+CJS7d1i3xaYmJc/0slgASFqI74mjIkGbshTGSoE50pVBhLEdZ
         0wjJBr+ZVNCP6Z6BllEhMHzB5EG8vhcsfD5/Ycm7n4Z/vHn5dBXrja/8z1ZnD0vTVK/1
         Io+PfJedQdlV/H4KaARgq9VDY/SbDqvcvPE6E=
MIME-Version: 1.0
Date: Sat, 26 Mar 2011 04:39:51 +0000
Message-ID: <AANLkTikXdFc2dkiaakQERaa6cV7Z-VoEZ5bgRptvCc_w@mail.gmail.com>
Subject: ioprio_set: IDLE_CLASS doesn't work as its name suggests
From: "fykcee1@gmail.com" <fykcee1@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Heihaier <admin@heiher.info>
Content-Type: multipart/mixed; boundary=001517447a0a20a9b4049f5b4dc8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001517447a0a20a9b4049f5b4dc8
Content-Type: text/plain; charset=ISO-8859-1

Hi all,

I've tried to make a fast boot according to "Booting Linux in five
seconds"[1]. One method of boot fast is using readahead -- a process
"replay" read actions in IDLE IO class via readahead syscall. Sadly
observed negative results -- according to bootchat diagram, readahead
process actually uses more IO bandwidth that slows down all IO
operations of other ones.

Then I did some tests -- two I/O hog processes, the IDLE IO class one
largely degrades I/O performance of the other one.

The tests were performed on a machine with dual-core cpu (intel
E5400@2.7GHz), G33 and ICH7, 2G mem, running Ubuntu 10.04. The kernel
version was 2.6.35-25-generic with CFQ as default I/O scheduler.
We ran test programs which time "find $2 -type f -exec cat {} \;" on
~1.9G directory with Normal and IDLE IO class. Before each test, we
reboot the system. Here are the results:

1. Only ran one instance of the test program in Normal IO class:
Job finished in 4m2.365s

2. Ran two instances of the test program, one Normal IO class, the
other Idle IO class:
[Normal]: 7m0.999s
[Idle]: 7m43.180s

3. Ran two instances of the test program, both Normal IO class:
[Normal1]: 8m39.366s
[Normal2]: 8m39.377s

BTW, for those interested in the detail, try the attachment:
1. mkdir ioprio_test
2. cp ioprio_test.c run_test.sh ioprio_test
3. tar xf <system_image.tar.gz> -C ioprio_test/tdir1
4. tar xf <system_image.tar.gz> -C ioprio_test/tdir2
5. reboot; cd ioprio_test && ./run_test.sh 1 => result stored in F.txt
6. reboot; cd ioprio_test && ./run_test.sh 2 => result stored in
F[B0].txt B0[F].txt
7. reboot; cd ioprio_test && ./run_test.sh 3 => result stored in
F[B1].txt B1[F].txt



Regards,
cee1
-------
[1] http://lwn.net/Articles/299483/

--001517447a0a20a9b4049f5b4dc8
Content-Type: text/x-csrc; charset=US-ASCII; name="ioprio_test.c"
Content-Disposition: attachment; filename="ioprio_test.c"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_glq1f7fs0

I2luY2x1ZGUgPHVuaXN0ZC5oPgojaW5jbHVkZSA8c3lzL3N5c2NhbGwuaD4KCmludCBtYWluKGlu
dCBhcmdjLCBjaGFyICogYXJndltdKQp7CgljaGFyICpjbWRbXSA9IHsKCQkiL3Vzci9iaW4vZmlu
ZCIsCgkJTlVMTCwKCQkiLXR5cGUiLCAiZiIsCgkJIi1leGVjIiwgImNhdCIsICJ7fSIsICI7IiwK
CQlOVUxMCgl9OwoKCWNsb3NlKDEpOwoJY2xvc2UoMik7CgoJaWYoMyA+IGFyZ2MpCgl7CgkJcmV0
dXJuIC0xOwoJfQoJZWxzZQoJewoKCQljbWRbMV0gPSBhcmd2WzJdOwoKCQlpZignMCcgPT0gYXJn
dlsxXVswXSkKCQl7CgkJCS8qIElkbGUgKi8KCQkJc3lzY2FsbChTWVNfaW9wcmlvX3NldCwgMSwg
Z2V0cGlkKCksICgoMzw8MTMpIHwgMCkpOwoJCX0KCgkJZXhlY3YoY21kWzBdLCBjbWQpOwoJfQoK
CXJldHVybiAwOwp9Cgo=
--001517447a0a20a9b4049f5b4dc8
Content-Type: application/x-sh; name="run_test.sh"
Content-Disposition: attachment; filename="run_test.sh"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_glq1fvbw1

IyEvYmluL2Jhc2gKCmlmICEgZ3JlcCAtcSAiXFtjZnFcXSIgL3N5cy9ibG9jay9zZGEvcXVldWUv
c2NoZWR1bGVyOyB0aGVuCgllY2hvICJOb3QgQ0ZRIHNjaGVkdWxlISEhLCBxdWl0LiIKZmkKCmNh
c2UgJDEgaW4KCTEpCgkJZWNobyAiRW50ZXIgdGVzdDE6IG9uZSBGb3JlZ3JvdW5kIGpvYiIKCQko
dGltZSAuL3Rlc3QgMSB0ZGlyMSkgMj5GLnR4dAoJCWVjaG8gIkZpbmlzaGVkLi4uUGxlYXNlIHJl
Ym9vdC4iCgkJOzsKCTIpCgkJZWNobyAiRW50ZXIgdGVzdDI6IG9uZSBGb3JlZ3JvdW5kIGpvYiBw
bHVzIG9uZSBCYWNrZ3JvdW5kIGpvYltJTzogSURMRV0iCgkJKHRpbWUgLi90ZXN0IDAgdGRpcjIp
IDI+QjBbRl0udHh0ICYKCQkodGltZSAuL3Rlc3QgMSB0ZGlyMSkgMj5GW0IwXS50eHQKCQllY2hv
ICJGaW5pc2hlZC4uLlBsZWFzZSByZWJvb3QuIgoJCTs7CgkzKQoJCWVjaG8gIkVudGVyIHRlc3Qz
IgoJCSh0aW1lIC4vdGVzdCAxIHRkaXIyKSAyPkIxW0ZdLnR4dCAmCgkJKHRpbWUgLi90ZXN0IDEg
dGRpcjEpIDI+RltCMV0udHh0CgkJZWNobyAiRmluaXNoZWQuLi5QbGVhc2UgcmVib290LiIKCQk7
Owplc2FjCg==
--001517447a0a20a9b4049f5b4dc8--
