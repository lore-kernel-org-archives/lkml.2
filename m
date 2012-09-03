Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756320Ab2ICLIJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 07:08:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56838 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756301Ab2ICLIH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 07:08:07 -0400
Message-ID: <50448F72.80702@redhat.com>
Date: Mon, 03 Sep 2012 14:07:30 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Dong Hao <haodong@linux.vnet.ibm.com>
CC: acme@infradead.org, mtosatti@redhat.com, mingo@elte.hu,
        xiaoguangrong@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v7 2/3] KVM: x86: trace mmio begin and complete
References: <1346061106-5364-1-git-send-email-haodong@linux.vnet.ibm.com> <1346061106-5364-3-git-send-email-haodong@linux.vnet.ibm.com>
In-Reply-To: <1346061106-5364-3-git-send-email-haodong@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/2012 12:51 PM, Dong Hao wrote:
> From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> 
> 'perf kvm stat record/report' will use kvm_exit and kvm_mmio(read...) to
> calculate mmio read emulated time for the old kernel, in order to trace
> mmio read event more exactly, we add kvm_mmio_begin to trace the time when
> mmio read begins, also, add kvm_io_done to trace the time when mmio/pio is
> completed
> 

Why is this so critical?

If a lot of time is spent in in-kernel mmio, then 'perf top' will report
it.  Otherwise the time between kvm_exit and kvm_entry describes the
time spent in the host.  Not all of it is mmio handling, but it is quite
close.

-- 
error compiling committee.c: too many arguments to function
