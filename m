Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964976Ab2CSJfA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 05:35:00 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:39523 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752221Ab2CSJe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 05:34:58 -0400
Message-ID: <4F66FDB9.1000306@linux.vnet.ibm.com>
Date: Mon, 19 Mar 2012 17:34:49 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
CC: avi@redhat.com, mtosatti@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] KVM: Switch to srcu-less get_dirty_log()
References: <20120301193007.04b2db8e.yoshikawa.takuya@oss.ntt.co.jp> <20120301193316.96682d60.yoshikawa.takuya@oss.ntt.co.jp> <4F62C9B4.7060804@linux.vnet.ibm.com> <20120316155511.70455b4a.yoshikawa.takuya@oss.ntt.co.jp> <4F62EC25.5060306@linux.vnet.ibm.com> <20120316165547.4df2abe4.yoshikawa.takuya@oss.ntt.co.jp> <4F62F9C8.6090803@linux.vnet.ibm.com> <20120316184459.3c64c8cf.yoshikawa.takuya@oss.ntt.co.jp>
In-Reply-To: <20120316184459.3c64c8cf.yoshikawa.takuya@oss.ntt.co.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12031823-1396-0000-0000-000000D5CBC4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/16/2012 05:44 PM, Takuya Yoshikawa wrote:

> On Fri, 16 Mar 2012 16:28:56 +0800
> Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com> wrote:
> 
>> Thanks for your explanation, maybe you are right, i do not know migration
>> much.
>>
>> What i worried about is, you have changed the behaviour of GET_DIRTY_LOG,
>> in the current one, it can get all the dirty pages when it is called; after
>> your change, GET_DIRTY_LOG can get a empty dirty bitmap but dirty page exists.
> 
> The current code also see the same situation because nothing prevents the
> guest from writing to pages before GET_DIRTY_LOG returns and the userspace
> checks the bitmap.  Everything is running.
> 


The current code is under the protection of s-rcu:
IIRC, it always holds s-rcu when write guest page and set dirty bit,
that mean the dirty page is logged either in the old dirty_bitmap or in the
current memslot->dirty_bitmap. Yes?

