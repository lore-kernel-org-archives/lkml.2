Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756809Ab2BBRZm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 12:25:42 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:48468 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756702Ab2BBRZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 12:25:39 -0500
Message-ID: <4F2AC707.7020801@gmail.com>
Date: Fri, 03 Feb 2012 01:25:27 +0800
From: Xiao Guangrong <xiaoguangrong.eric@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Stefan Hajnoczi <stefanha@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH v2] KVM: perf: a smart tool to analyse kvm events
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changlog:

- calculate stddev.
- make it works both for old kernel and new kernel.
- dynamically inquire max vcpus and cpu isa.

This is a example result of vmexit:

# ./perf kvm-events report
  Warning: Error: expected type 5 but read 4
  Warning: Error: expected type 5 but read 0
  Warning: unknown op '}'


Analyze events for all VCPUs:

             VM-EXIT    Samples  Samples%     Time%         Avg time

         APIC_ACCESS     152367    34.07%     1.74%     15.69us ( +-   2.02% )
      IO_INSTRUCTION     142663    31.90%     1.76%     16.91us ( +-   2.87% )
                 HLT      46681    10.44%    95.87%   2816.04us ( +-   2.94% )
       EPT_VIOLATION      40184     8.98%     0.15%      5.17us ( +-   1.26% )
               CPUID      21284     4.76%     0.04%      2.47us ( +-   0.66% )
  EXTERNAL_INTERRUPT      21215     4.74%     0.36%     23.39us ( +-   2.83% )
       EXCEPTION_NMI      11723     2.62%     0.04%      5.21us ( +-   2.46% )
           CR_ACCESS       5810     1.30%     0.02%      5.06us ( +-   1.01% )
   PENDING_INTERRUPT       5322     1.19%     0.01%      3.69us ( +-   1.73% )

Total Samples:447249, Total events handled time:137125528.85us.

Any comments are welcome! :)
