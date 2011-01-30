Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102Ab1A3NCQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jan 2011 08:02:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38052 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753804Ab1A3NCO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jan 2011 08:02:14 -0500
Message-ID: <4D456139.4090508@redhat.com>
Date: Sun, 30 Jan 2011 15:01:45 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Jan Beulich <JBeulich@novell.com>, Xiaowei Yang <xiaowei.yang@huawei.com>,
        Nick Piggin <npiggin@kernel.dk>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, fanhenglong@huawei.com,
        Kaushik Barde <kbarde@huawei.com>, Kenneth Lee <liguozhu@huawei.com>,
        linqaingmin <linqiangmin@huawei.com>, wangzhenguo@huawei.com,
        Wu Fengguang <fengguang.wu@intel.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        linux-kernel@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: One (possible) x86 get_user_pages bug
References: <4D416D9A.9010603@huawei.com> <4D419416020000780002ECB7@vpn.id2.novell.com> <4D41B90D.5000305@goop.org>
In-Reply-To: <4D41B90D.5000305@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2011 08:27 PM, Jeremy Fitzhardinge wrote:
> And even just considering virtualization, having non-IPI-based tlb
> shootdown is a measurable performance win, since a hypervisor can
> optimise away a cross-VCPU shootdown if it knows no physical TLB
> contains the target VCPU's entries.  I can imagine the KVM folks could
> get some benefit from that as well.

It's nice to avoid the IPI (and waking up a cpu if it happens to be 
asleep) but I think the risk of deviating too much from the baremetal 
arch is too large, as demonstrated by this bug.

(well, async page faults is a counterexample, I wonder if/when it will 
bite us)

-- 
error compiling committee.c: too many arguments to function

