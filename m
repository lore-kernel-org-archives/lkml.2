Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756563Ab0FOCts (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 22:49:48 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52545 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753632Ab0FOCtq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 22:49:46 -0400
Message-ID: <4C16E974.8000304@cn.fujitsu.com>
Date: Tue, 15 Jun 2010 10:46:12 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: [PATCH 0/6] KVM: MMU: support pte prefetch when intercepted guest
 #PF
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Avi, Marcelo,

This patchset support pte prefetch when intercepted guest #PF,
the aim is to reduce guest #PF which can be intercepted by VMM.

If we meet any failure in the prefetch path, we will exit it
and not try other ptes to avoid become heavy path.

During my performance test, under EPT enabled case, unixbench
shows the performance improved ~1.2%, user EPT disable case,
unixbench shows the performance improved ~3.6%





