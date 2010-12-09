Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420Ab0LIQdL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 11:33:11 -0500
Received: from mail-bw0-f45.google.com ([209.85.214.45]:34360 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197Ab0LIQdK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 11:33:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=b8Fiqp1gV1xUFDbvPNdS69TklHPTHNnn2697QkKEM1Io6OBhYGzlRn0S9t15z8EB3p
         9nAnoTYQ0/Auh5KztOE6PfdvyJYrglRSRqkfymdFPBpcxedhiISfIqOp0HE5Ng2gA9jv
         gjNv40GOwMILAzSaYfDdTeqlqreA/ugZ/u30w=
MIME-Version: 1.0
Date: Thu, 9 Dec 2010 17:33:09 +0100
Message-ID: <AANLkTiknV+dAGLNn3wWxmtXH-NAoYLsaxV-DNGOJsfaK@mail.gmail.com>
Subject: 32bit process on a 64bit arch: ENOMEM on fork, what is the exact cause?
From: Francis Galiegue <fgaliegue@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Please Cc: me on replies, I am not on the list]

Hello everyone,

This is the situation:

* the machine is an RHEL 5.x, x86_64 with all updates applied;
* one user, tomcat, runs, well, Tomcat, with a 32bit JVM (Sun 1.6.0.16
FWIW) and it has to for now (a 32bit native Oracle driver has to be
used);
* this JVM has, as an argument -Xmx3072M:
* the application uses Runtime.exec() to fork processes on a regular basis;
* and this is the output of 'ulimit -a' for the user:
----
core file size          (blocks, -c) 0
data seg size           (kbytes, -d) unlimited
file size               (blocks, -f) unlimited
pending signals                 (-i) 1024
max locked memory       (kbytes, -l) 32
max memory size         (kbytes, -m) unlimited
open files                      (-n) 1024
pipe size            (512 bytes, -p) 8
POSIX message queues     (bytes, -q) 819200
stack size              (kbytes, -s) 10240
cpu time               (seconds, -t) unlimited
max user processes              (-u) 30720
virtual memory          (kbytes, -v) unlimited
file locks                      (-x) unlimited
----

In the logs, I sometimes see that it fails to execute an external
program with errno=12, which means ENOMEM. In spite of that, when this
error occurs, the machine still has 250 MB RAM free.

As all occurrences of such an error I could google out are RAM/swap
exhaustion and this is clearly not the case here, I suspect this is
due to the process being 32bit. But I cannot prove it. Am I at least
right in suspecting that? If yes, what is the real cause? What memory
region was exhausted? An SNMP JVM probe showed that an
OutOfMemoryError was far, far away...

Have fun,
-- 
Francis Galiegue, fgaliegue@gmail.com
"It seems obvious [...] that at least some 'business intelligence'
tools invest so much intelligence on the business side that they have
nothing left for generating SQL queries" (Stéphane Faroult, in "The
Art of SQL", ISBN 0-596-00894-5)
