Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968Ab2K0P4c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 10:56:32 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:61983 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754981Ab2K0P4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 10:56:31 -0500
MIME-Version: 1.0
In-Reply-To: <20121127154455.GK12969@redhat.com>
References: <1353993325.14050.49.camel@ThinkPad-T5421.cn.ibm.com>
	<CAFTL4hzzumANj7hF5hJPZ5pKPhz4YWC-Ukb3yUKdy_DO+vb3wg@mail.gmail.com>
	<20121127154455.GK12969@redhat.com>
Date: Tue, 27 Nov 2012 16:56:30 +0100
Message-ID: <CAFTL4hyfCt2imzBYW+Sn5QUAwham=ZQ2nNER5Np7Hq4yg1LzxA@mail.gmail.com>
Subject: Re: [RFC PATCH] Fix abnormal rcu dynticks_nesting values related to
 async page fault
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Gleb Natapov <gleb@redhat.com>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>,
        linux-next list <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, paulmck@linux.vnet.ibm.com,
        sasha.levin@oracle.com, avi@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/11/27 Gleb Natapov <gleb@redhat.com>:
> For KVM_PV_REASON_PAGE_NOT_PRESENT it behaves like an exception.

Ok.
There seem to be a bug in kvm_async_pf_task_wait(). Using
idle_cpu(cpu) to find out if the current task is the idle task may not
work if there is pending wake up. Me may schedule another task but
when that other task sleeps later we can't schedule back to idle until
the fault is completed.

The right way is to use is_idle_task(current)
