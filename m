Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751615Ab1LRI77 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 03:59:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38588 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751300Ab1LRI74 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 03:59:56 -0500
Message-ID: <4EEDAB87.1030506@redhat.com>
Date: Sun, 18 Dec 2011 10:59:51 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 4/8] KVM: MMU: drop unsync_child_bitmap
References: <4EEB19AF.5070501@linux.vnet.ibm.com> <4EEB1A71.4040503@linux.vnet.ibm.com>
In-Reply-To: <4EEB1A71.4040503@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/2011 12:16 PM, Xiao Guangrong wrote:
> unsync_child_bitmap is used to record which spte has unsync page or unsync
> children, we can set a free bit in the spte instead of it
>

unsync_child_bitmap takes one cacheline; the shadow page table takes
64.  This will make unsync/resync much more expensive.

I suggest to put unsync_child_bitmap at the end (together with
unsync_children) and simply not allocate it when unneeded (have two
kmem_caches for the two cases).


-- 
error compiling committee.c: too many arguments to function

