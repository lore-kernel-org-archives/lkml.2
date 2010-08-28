Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753001Ab0H1LzH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 07:55:07 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64253 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751938Ab0H1LzF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 07:55:05 -0400
Message-ID: <4C78FA00.8090606@cn.fujitsu.com>
Date: Sat, 28 Aug 2010 19:58:56 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH 0/4] KVM: MMU: mmu audit code improved
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The audit can help us to detect the mmu bugs as early as possible, it's also
can help us to fix them.

It's so useful but the linux distribution is imposable to use it since:

- it need enable it by define "AUDIT" macro and compile it
- the audit code is very high overload, it lets the guest mostly hung

So, this patchset supports to enable/disable it dynamically, it's very low
overhead if disable it, and it lowers the audit frequency to assure the guest
running.

After this patchset, we can enable it by:
mount -t debugfs none debugfs
echo 1 > debugfs/kvm/mmu-debug

disable it by:
echo 0 > debugfs/kvm/mmu-debug

default, the audit is disabled

[PATCH 1/4] KVM: MMU: support disable/enable mmu audit dynamically
[PATCH 2/4] KVM: MMU: improve active sp audit
[PATCH 3/4] KVM: MMU: improve spte audit
[PATCH 4/4] KVM: MMU: lower the aduit frequency
