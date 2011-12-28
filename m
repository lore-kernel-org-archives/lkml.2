Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872Ab1L1JxY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 04:53:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:65186 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752150Ab1L1JxV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 04:53:21 -0500
Message-ID: <4EFAE705.6070202@redhat.com>
Date: Wed, 28 Dec 2011 11:53:09 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Liu ping fan <kernelfans@gmail.com>
CC: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, aliguori@us.ibm.com, gleb@redhat.com,
        mtosatti@redhat.com, xiaoguangrong.eric@gmail.com, jan.kiszka@web.de,
        Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
Subject: Re: [PATCH v6] kvm: make vcpu life cycle separated from kvm instance
References: <1324091975-20930-1-git-send-email-kernelfans@gmail.com> <1324975139-8836-1-git-send-email-kernelfans@gmail.com> <4EF9AA59.7050003@oss.ntt.co.jp> <CAFgQCTu+qO=_Pc3Nps5N+esB0a9xYu83nRUT4Q6JepM6pAZYAA@mail.gmail.com>
In-Reply-To: <CAFgQCTu+qO=_Pc3Nps5N+esB0a9xYu83nRUT4Q6JepM6pAZYAA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/28/2011 08:54 AM, Liu ping fan wrote:
> >>
> >>   struct kvm_vcpu {
> >>       struct kvm *kvm;
> >> +     struct list_head list;
> >>   #ifdef CONFIG_PREEMPT_NOTIFIERS
> >>       struct preempt_notifier preempt_notifier;
> >>   #endif
> >> @@ -251,12 +252,14 @@ struct kvm {
> >>       struct mm_struct *mm; /* userspace tied to this vm */
> >>       struct kvm_memslots *memslots;
> >>       struct srcu_struct srcu;
> >> +     struct srcu_struct srcu_vcpus;
> >> +
> >
> > Another srcu.  This alone is worth explaining in the changelog IMO.
> >
> Sorry, but why? I think it is just a srcu, and because it has
> different aim and want a independent grace period, so not multiplex
> kvm->srcu.

There is Documentation/virtual/kvm/locking.txt for that.

btw, why does it have to be srcu?  Is rcu insufficient?

Why do we want an independent grace period, is hotunplugging a vcpu that
much different from hotunplugging memory?

-- 
error compiling committee.c: too many arguments to function

