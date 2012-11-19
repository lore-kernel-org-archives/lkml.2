Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187Ab2KSITw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 03:19:52 -0500
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:43049 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753146Ab2KSITv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 03:19:51 -0500
Message-ID: <50A9EB89.70901@linux.vnet.ibm.com>
Date: Mon, 19 Nov 2012 16:19:21 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Josh Boyer <jwboyer@gmail.com>, mingo@kernel.org,
        haodong@linux.vnet.ibm.com, runzhen@linux.vnet.ibm.com,
        dsahern@gmail.com, tglx@linutronix.de, bp@alien8.de,
        namhyung@gmail.com, torvalds@linux-foundation.org, paulus@samba.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: Re: [PATCH 2/2] perf kvm: fix building perf kvm on PowerPC
References: <50A48912.20606@linux.vnet.ibm.com> <1378.1352379110@warthog.procyon.org.uk> <CA+5PVA5vMyNmQYCLX315Jc+kN9zQuZo_h0Devpjfr43TezE-qA@mail.gmail.com> <18065.1352820271@warthog.procyon.org.uk> <CA+5PVA6qaxCzr8RBV616D3kEXyj9XjS3okeZXhJJL1R4+-Yv_A@mail.gmail.com> <20121113163458.GA1023@ghostprotocols.net> <50A488DD.6090106@linux.vnet.ibm.com> <6764.1352976414@warthog.procyon.org.uk>
In-Reply-To: <6764.1352976414@warthog.procyon.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12111908-2000-0000-0000-000009EF71BE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/2012 06:46 PM, David Howells wrote:
> Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com> wrote:
> 
>> Now, 'perf kvm stat' is only supported on x86, let its code depend
>> on ARCH_X86 to fix building it on other architectures
> 
> Other parts of perf do this sort of thing:
> 
> 	#if defined(__x86_64__) || defined(__i386__)
> 

Yes, thanks for you point it out, David! How about this one?

Subject: [PATCH 2/2] perf kvm: fix building perf kvm on PowerPC

Now, 'perf kvm stat' is only supported on x86, let its code depend
on ARCH_X86 to fix building it on other architectures

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 tools/perf/builtin-kvm.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index 7fb426b..df30ca0 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -22,6 +22,7 @@
 #include <pthread.h>
 #include <math.h>

+#if defined(__i386__) || defined(__x86_64__)
 #include "../../arch/x86/include/asm/svm.h"
 #include "../../arch/x86/include/asm/vmx.h"
 #include "../../arch/x86/include/asm/kvm.h"
@@ -913,6 +914,7 @@ static int kvm_cmd_stat(const char *file_name, int argc, const char **argv)
 perf_stat:
 	return cmd_stat(argc, argv, NULL);
 }
+#endif

 static int __cmd_record(const char *file_name, int argc, const char **argv)
 {
@@ -1035,8 +1037,10 @@ int cmd_kvm(int argc, const char **argv, const char *prefix __maybe_unused)
 		return cmd_top(argc, argv, NULL);
 	else if (!strncmp(argv[0], "buildid-list", 12))
 		return __cmd_buildid_list(file_name, argc, argv);
+#if defined(__i386__) || defined(__x86_64__)
 	else if (!strncmp(argv[0], "stat", 4))
 		return kvm_cmd_stat(file_name, argc, argv);
+#endif
 	else
 		usage_with_options(kvm_usage, kvm_options);

-- 
1.7.7.6

