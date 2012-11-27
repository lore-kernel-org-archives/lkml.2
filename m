Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513Ab2K0OCW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 09:02:22 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:45818 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752561Ab2K0OCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 09:02:21 -0500
Message-ID: <50B4C7BD.90807@oracle.com>
Date: Tue, 27 Nov 2012 09:01:33 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121112 Thunderbird/16.0.1
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Li Zhong <zhong@linux.vnet.ibm.com>,
        linux-next list <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, paulmck@linux.vnet.ibm.com,
        avi@redhat.com, fweisbec@gmail.com
Subject: Re: [RFC PATCH] Fix abnormal rcu dynticks_nesting values related
 to async page fault
References: <1353993325.14050.49.camel@ThinkPad-T5421.cn.ibm.com> <20121127130703.GW25516@redhat.com>
In-Reply-To: <20121127130703.GW25516@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27/2012 08:07 AM, Gleb Natapov wrote:
> Those rcu_irq_enter()/rcu_irq_exit() were introduced by commit
> c5e015d4949aa665 "KVM guest: exit idleness when handling
> KVM_PV_REASON_PAGE_NOT_PRESENT", but now I am starting to question this
> commit. KVM_PV_REASON_PAGE_NOT_PRESENT should not kick cpu out of
> idleness. kvm_async_pf_task_wait() checks that cpu is idle and calls
> halt if it is. After that commit schedule() may be called between
> rcu_irq_enter()/rcu_irq_exit() which is probably illegal. Paul?

otoh, calling schedule() apparently kicks cpu out of idleness now.


Thanks,
Sasha
