Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755102Ab1KRJQk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 04:16:40 -0500
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:36761 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549Ab1KRJQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 04:16:38 -0500
Message-ID: <4EC6226B.3080408@linux.vnet.ibm.com>
Date: Fri, 18 Nov 2011 17:16:27 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH v2 0/6] KVM: optimize memslots searching
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 11111809-3864-0000-0000-000000242491
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the more work base on my v1 patchset which is posted some months ago,
it can be found at:
https://lkml.org/lkml/2011/2/22/68

Change log:
- sort memslots base on its size and do the line search instead of binary
  search base on gfn, it is from Avi's idea.
- in order to reduce cache footprint, memslots are sorted in the array of
  kvm->memslots->memslots[] and introduce a table to map slot id to index in
  the array

There is the performance result:

autotest for RHEL.6.1 setup/boot/reboot/shutdown(average):
ept=1:	before: 449.5	after: 447.8
ept=0:	before: 532.7	after: 529.8

kernbench(average):
ept=1:	before: 127.94	after: 126.98
ept=0:	before: 196.85	after: 189.66

