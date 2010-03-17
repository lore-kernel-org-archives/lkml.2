Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369Ab0CQHUU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 03:20:20 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55710 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752579Ab0CQHUT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 03:20:19 -0400
Message-ID: <4BA082EC.8030101@cn.fujitsu.com>
Date: Wed, 17 Mar 2010 15:21:16 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [BUG] perf: hard lockup when using perf-sched
Content-Type: multipart/mixed;
 boundary="------------010200020209010705080304"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010200020209010705080304
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

An idea came to me that running perf-sched with a fork "bomb" might
reveal some bug.

So I wrote a program (attached), and did the following test:

# gcc fork.c
# ./a.out &
# perf sched record

After a few seconds, the machine froze, without printing any message.

I've tried the test both on v2.6.34-rc1 and v2.6.34-rc1-tip+.

I'll send you any other information you need.

--------------010200020209010705080304
Content-Type: text/plain;
 name="fork.c"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="fork.c"

I2luY2x1ZGUgPHVuaXN0ZC5oPgojaW5jbHVkZSA8c3RkbGliLmg+CiNpbmNsdWRlIDxzdGRp
by5oPgojaW5jbHVkZSA8c3lzL3R5cGVzLmg+CiNpbmNsdWRlIDxzeXMvd2FpdC5oPgoKaW50
IG1haW4odm9pZCkKewoJaW50IGk7CglpbnQgcGlkOwoKCXdoaWxlICgxKSB7CgkJZm9yIChp
ID0gMDsgaSA8IDQwMDsgaSsrKSB7CgkJCXBpZCA9IGZvcmsoKTsKCQkJaWYgKHBpZCA9PSAw
KSB7CgkJCQlyZXR1cm4gMDsKCQkJfSBlbHNlIGlmIChwaWQgPCAwKSB7CgkJCQlmcHJpbnRm
KHN0ZGVyciwgImZhaWxkIHRvIGZvcmshXG4iKTsKCQkJCWNvbnRpbnVlOwoJCQl9CgkJfQoK
CQlmb3IgKGkgPSAwOyBpIDwgNDAwOyBpKyspCgkJCWlmICh3YWl0KE5VTEwpIDwgMCkKCQkJ
CWJyZWFrOwoJfQoKCXJldHVybiAwOwp9Cgo=
--------------010200020209010705080304--
