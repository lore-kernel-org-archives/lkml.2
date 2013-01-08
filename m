Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755800Ab3AHKkT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 05:40:19 -0500
Received: from tama500.ecl.ntt.co.jp ([129.60.39.148]:36761 "EHLO
	tama500.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755645Ab3AHKkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 05:40:18 -0500
Date: Tue, 8 Jan 2013 19:40:44 +0900
From: Takuya Yoshikawa <yoshikawa_takuya_b1@lab.ntt.co.jp>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: gleb@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] KVM: Alleviate mmu_lock hold time when we start
 dirty logging
Message-Id: <20130108194044.aa857582.yoshikawa_takuya_b1@lab.ntt.co.jp>
In-Reply-To: <20130107203642.GA23155@amt.cnet>
References: <20121218162558.65a8bfd3.yoshikawa_takuya_b1@lab.ntt.co.jp>
	<20130107203642.GA23155@amt.cnet>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Jan 2013 18:36:42 -0200
Marcelo Tosatti <mtosatti@redhat.com> wrote:

> Looks good, except patch 1 - 
> 
> a) don't understand why it is necessary and 

What's really necessary is to make sure that we don't call the function
for a deleted slot.  My explanation was wrong.

> b) not confident its safe - isnt clearing necessary for KVM_SET_MEMORY
> instances other than
> 
> !(old.flags & LOG_DIRTY) && (new.flags & LOG_DIRTY)

I think flushing shadows should be enough for other cases, e.g. moving a slot.

But I've changed the condition (see v2) to make it easier to understand:
  npages && LOG_DIRTY

Since remove_write_access() is for dirty logging, this condition should be safe.

Thanks,
	Takuya
