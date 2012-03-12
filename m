Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756206Ab2CLSEm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 14:04:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63219 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756153Ab2CLSEb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 14:04:31 -0400
Message-ID: <4F5E3AAB.7020603@redhat.com>
Date: Mon, 12 Mar 2012 20:04:27 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
CC: mtosatti@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] KVM: Avoid checking huge page mappings in get_dirty_log()
References: <20120301193007.04b2db8e.yoshikawa.takuya@oss.ntt.co.jp> <20120301193216.b14538bb.yoshikawa.takuya@oss.ntt.co.jp>
In-Reply-To: <20120301193216.b14538bb.yoshikawa.takuya@oss.ntt.co.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/01/2012 12:32 PM, Takuya Yoshikawa wrote:
> Dropped such mappings when we enabled dirty logging and we will never
> create new ones until we stop the logging.
>
> For this we introduce a new function which can be used to write protect
> a range of PT level pages: although we do not need to care about a range
> of pages at this point, the following patch will need this feature to
> optimize the write protection of many pages.
>
>

It occurs to me that we should write-protect huge page tables, since it
makes write protection much faster (we make up for this later at write
fault time, but that might not occur, and even if it does we reduce
guest jitter).  In fact I once proposed a more involved variant, called
O(1) write protection, in which we write-protect the topmost page table
only and only un-write-protect the paths that fault.

That can be done later however and shouldn't affect this patchset.

-- 
error compiling committee.c: too many arguments to function

