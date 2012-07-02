Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755629Ab2GBCWg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 22:22:36 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:35746 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754571Ab2GBCWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 22:22:34 -0400
Message-ID: <4FF105D0.8010400@linux.vnet.ibm.com>
Date: Mon, 02 Jul 2012 10:22:08 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>, mtosatti@redhat.com,
        agraf@suse.de, paulus@samba.org, aarcange@redhat.com,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linux-kernel@vger.kernel.org, takuya.yoshikawa@gmail.com
Subject: Re: [PATCH 5/6] KVM: Separate rmap_pde from kvm_lpage_info->write_count
References: <20120628105733.ccd9abb3.yoshikawa.takuya@oss.ntt.co.jp> <20120628110141.7b908c91.yoshikawa.takuya@oss.ntt.co.jp> <4FEBCBB3.3060707@linux.vnet.ibm.com> <20120628124546.83a829f3.yoshikawa.takuya@oss.ntt.co.jp> <4FEC96EB.1050307@redhat.com>
In-Reply-To: <4FEC96EB.1050307@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12070202-4790-0000-0000-0000037DDBA8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29/2012 01:39 AM, Avi Kivity wrote:

> But I still think it's the right thing since it simplifies the code.
> Maybe we should add a prefetch() on write_count do mitigate the
> overhead, if it starts showing up in profiles.
> 

Long time ago, there was a discussion about dropping prefetch in the
operation of list walking:
	http://lwn.net/Articles/444336/
IIRC, the conclusion is that it is better to let CPU prefetch memory
by itself.

Actually, when i developed lockless spte walking, i measure the performance if
prefetch was used, but i did not see the improvement.


