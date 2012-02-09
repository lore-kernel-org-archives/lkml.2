Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757411Ab2BIJHB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 04:07:01 -0500
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:37472 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268Ab2BIJG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 04:06:58 -0500
Message-ID: <4F338CAA.10807@linux.vnet.ibm.com>
Date: Thu, 09 Feb 2012 17:06:50 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        David Ahern <dsahern@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH v4 0/3] KVM: perf: kvm events analysis tool
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12020909-9574-0000-0000-0000014DF319
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changlog:
There are some changes from David Ahern's review:
- let the tool to be off-box analysis by getting cpu isa
  from HEADER_CPUID feature and removing max-vcpu related code.

- attach per vcpu record structure to the thread by adding a void pointer
  in "struct thread".

- remove unnecessary tool argument(-v).

The output example is following:
# ./perf kvm-events report --event mmio --vcpu 3
  Warning: Error: expected type 5 but read 4
  Warning: Error: expected type 5 but read 0
  Warning: unknown op '}'


Analyze events for VCPU 3:

         MMIO Access    Samples  Samples%     Time%         Avg time

        0xfee00380:W      45534    78.00%    84.76%      5.27us ( +-   0.77% )
        0xfee00300:W       4280     7.33%     9.37%      6.20us ( +-   1.91% )
        0xfee00300:R       4280     7.33%     3.34%      2.21us ( +-   1.53% )
        0xfee00310:W       4280     7.33%     2.52%      1.67us ( +-   0.71% )

Total Samples:58374, Total events handled time:283257.68us.

