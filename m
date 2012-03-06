Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758858Ab2CFIz7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 03:55:59 -0500
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:42409 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758795Ab2CFIz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 03:55:58 -0500
Message-ID: <4F55D110.2020609@linux.vnet.ibm.com>
Date: Tue, 06 Mar 2012 16:55:44 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>, Arnaldo Carvalho de Melo <acme@infradead.org>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        David Ahern <dsahern@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH v5 0/3] KVM: perf: kvm events analysis tool
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12030608-3864-0000-0000-000001B59B9B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changlong:

Thanks to David's review, there are some changes:
- add kvm-events compile-depend files to tools/perf/MANIFEST

- fix some typos and little clean up

- rebase it on -tip tree

The output example is following:

#./perf kvm-events report --event mmio --vcpu 3


Analyze events for VCPU 3:

         MMIO Access    Samples  Samples%     Time%         Avg time

        0xfee00380:W      29688    61.16%    64.52%      3.37us ( +-   0.86% )
        0xfee00300:W       6285    12.95%    20.06%      4.95us ( +-   2.34% )
        0xfee00300:R       6285    12.95%     8.08%      1.99us ( +-   0.59% )
        0xfee00310:W       6285    12.95%     7.34%      1.81us ( +-   6.76% )

Total Samples:48543, Total events handled time:155156.31us.

