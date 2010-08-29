Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914Ab0H2SoB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 14:44:01 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:33085 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183Ab0H2SoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 14:44:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=usHb1Y6vQm/Ve6F0nCY5gInwEv6b3HAEZruw1x+86TIGg68Twjw7ZADakc8ReAoelK
         4Jwp32olWvFxCKcZrTXeqpUg11X2pQB1tmsHk0NFDB9PWcSmVr6GqtxEuihgBYEgLLfL
         cRgYB2ohGpgVj598AWFh3MnM/Kp/W01Zm0hts=
Message-ID: <4C7AAAA4.6060709@gmail.com>
Date: Sun, 29 Aug 2010 11:44:52 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: gcc-help@gcc.gnu.org
Subject: kernel/perf_event.c:5879:1: internal compiler error: in cgraph_estimate_size_after_inlining,
 at ipa-inline.c:208
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

well.. I know 2.6.35-rc6-00191-ga2dccdb builds without any such 
errors..(I can bisect this if need be)

keep in mind this happens with: gcc --version
gcc (GCC) 4.6.0 20100416 (experimental)

                  from include/linux/hardirq.h:10,
                  from kernel/perf_event.c:26:
include/linux/irq.h: In function 'alloc_desc_masks':
include/linux/irq.h:442:8: warning: variable 'gfp' set but not used
kernel/perf_event.c: At top level:
kernel/perf_event.c:5879:1: internal compiler error: in 
cgraph_estimate_size_after_inlining, at ipa-inline.c:208
Please submit a full bug report,
with preprocessed source if appropriate.
See <http://gcc.gnu.org/bugs.html> for instructions.
make[1]: *** [kernel/perf_event.o] Error 1
make: *** [kernel] Error 2


just tested on my other machine running
gcc --version: gcc (GCC) 4.6.0 20100731 (experimental)
and this does not occur. kernel builds fine.(not sure with other 
versions of gcc though).

Justin P. Mattock
