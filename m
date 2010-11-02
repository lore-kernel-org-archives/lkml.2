Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932365Ab0KBHX2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 03:23:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43863 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754150Ab0KBHXV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 03:23:21 -0400
Date: Tue, 2 Nov 2010 08:21:45 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: dhowells@redhat.com, lizf@cn.fujitsu.com, paul.moore@hp.com,
        johannes@sipsolutions.net, dipankar@in.ibm.com,
        linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH 2/3] kernel,cred,kvm,security - removing superfluous
 rcu_read_lock_held check
Message-ID: <20101102072145.GA1871@jolsa.brq.redhat.com>
References: <1288638909-10541-1-git-send-email-jolsa@redhat.com>
 <1288638909-10541-3-git-send-email-jolsa@redhat.com>
 <4CCF424F.3050205@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CCF424F.3050205@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 01, 2010 at 11:42:23PM +0100, Paolo Bonzini wrote:
> On 11/01/2010 08:15 PM, Jiri Olsa wrote:
> >diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> >index a055742..a90a7e3 100644
> >--- a/include/linux/kvm_host.h
> >+++ b/include/linux/kvm_host.h
> >@@ -256,7 +256,6 @@ void kvm_put_kvm(struct kvm *kvm);
> >  static inline struct kvm_memslots *kvm_memslots(struct kvm *kvm)
> >  {
> >  	return rcu_dereference_check(kvm->memslots,
> >-			srcu_read_lock_held(&kvm->srcu)
> >  			|| lockdep_is_held(&kvm->slots_lock));
> >  }
> >
> 
> This is an srcu_read_lock_held, which you don't touch here:
> 
> >diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
> >index 9d8e8fb..0956a73 100644
> >--- a/kernel/rcutorture.c
> >+++ b/kernel/rcutorture.c
> >@@ -807,7 +807,6 @@ static void rcu_torture_timer(unsigned long unused)
> > 	idx = cur_ops->readlock();
> > 	completed = cur_ops->completed();
> > 	p = rcu_dereference_check(rcu_torture_current,
> >-				  rcu_read_lock_held() ||
> > 				  rcu_read_lock_bh_held() ||
> > 				  rcu_read_lock_sched_held() ||
> > 				  srcu_read_lock_held(&srcu_ctl));
> 
> I guess the kvm hunk is the incorrect one?
ops, you're right. I overlooked it, please skip the kvm hunk..

thanks,
jirka
