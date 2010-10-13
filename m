Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257Ab0JMKmp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 06:42:45 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:47683 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752985Ab0JMKmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 06:42:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=sFWfZQxAqhPnMqiv9hd1z8of8wrfRhEHjJEu7IBwHQVWH9JfNdVResYMmHLzrC4ipq
         s1SZFs+dQfLXw6nqo3bk6AWyRnxGE97eaQ71xTwmpPFwc508eWz9l4Ob+Wi9Nm8ihCSn
         tbq0nXn4xg5MH6Gwg4/V03G74AYqxUV8A+rPE=
Subject: Re: [PATCH 17/18] fs: icache remove inode_lock
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Nick Piggin <npiggin@kernel.dk>
Cc: Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20101013072058.GA3121@amd>
References: <1286515292-15882-1-git-send-email-david@fromorbit.com>
	 <1286515292-15882-18-git-send-email-david@fromorbit.com>
	 <20101013072058.GA3121@amd>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 13 Oct 2010 12:42:36 +0200
Message-ID: <1286966556.3876.261.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 13 octobre 2010 à 18:20 +1100, Nick Piggin a écrit :

> I don't think the patchset has suddenly become vastly more urgent
> in the past month, so I think my approach of having it get a lot
> of testing and go in Al's vfs tree for a while is best.
> 

Hi Nick 

Not vastly urgent, but highly wanted on many workloads, even ones not
really related to 'fs'...

In current tree, a "close(socket())" needs 31 us on a 2x4x2 machine,
instead of 1.45 us if single thread.

But yes, I agree a lot of testing is needed :)

--------------------------------------------------------------------------------------------
   PerfTop:   16584 irqs/sec  kernel:99.8%  exact:  0.0% [1000Hz cycles],  (all, 16 CPUs)
--------------------------------------------------------------------------------------------

             samples  pcnt function                 DSO
             _______ _____ ________________________ _______

           101217.00 87.8% _raw_spin_lock           vmlinux
             1365.00  1.2% kmem_cache_alloc         vmlinux
             1220.00  1.1% d_alloc                  vmlinux
             1159.00  1.0% sock_alloc_file          vmlinux
              881.00  0.8% __d_instantiate          vmlinux
              657.00  0.6% memset                   vmlinux
              516.00  0.4% dput                     vmlinux
              423.00  0.4% new_inode                vmlinux
              401.00  0.3% _atomic_dec_and_lock     vmlinux
              397.00  0.3% iput                     vmlinux
              358.00  0.3% dentry_iput              vmlinux
              320.00  0.3% kmem_cache_free          vmlinux
              309.00  0.3% __slab_free              vmlinux
              297.00  0.3% __sk_free                vmlinux
              264.00  0.2% kmem_cache_alloc_notrace vmlinux
              263.00  0.2% __call_rcu               vmlinux

Thanks


