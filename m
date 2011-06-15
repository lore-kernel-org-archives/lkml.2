Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755716Ab1FOO4X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 10:56:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62568 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755666Ab1FOO4U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 10:56:20 -0400
Message-ID: <4DF8C80F.7090403@redhat.com>
Date: Wed, 15 Jun 2011 10:56:15 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: Linux kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kyle McMartin <kyle@redhat.com>
Subject: SLUB BUG: check_slab called with interrupts enabled
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,

last night I got an interesting backtrace running 3.0-rc3
(Fedora Rawhide kernel package).  Unfortunately netconsole
seems to be incompatible with KVM at the moment, so I had
to capture the oops on my digital camera and will be
transcribing just the backtrace.

Essentially, kernel 3.0-rc3 hit this bug:

static int check_slab(struct kmem_cache *s, struct page *page)
{
         int maxobj;

         VM_BUG_ON(!irqs_disabled());

The call trace:

check_slab
alloc_debug_processing
__slab_alloc
kmem_cache_alloc
bvec_alloc_bs
bio_alloc_bioset
bio_alloc
mpage_alloc
do_mpage_readpage
... followed by ext4 and VFS code, obviously innocent


Is this a known issue, Christoph?

If not, anything I can do to help debug/fix this?

-- 
All rights reversed
