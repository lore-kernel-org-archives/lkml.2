Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031Ab1L2ODH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 09:03:07 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:43325 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890Ab1L2ODE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 09:03:04 -0500
MIME-Version: 1.0
In-Reply-To: <4EFAE705.6070202@redhat.com>
References: <1324091975-20930-1-git-send-email-kernelfans@gmail.com>
	<1324975139-8836-1-git-send-email-kernelfans@gmail.com>
	<4EF9AA59.7050003@oss.ntt.co.jp>
	<CAFgQCTu+qO=_Pc3Nps5N+esB0a9xYu83nRUT4Q6JepM6pAZYAA@mail.gmail.com>
	<4EFAE705.6070202@redhat.com>
Date: Thu, 29 Dec 2011 22:03:03 +0800
Message-ID: <CAFgQCTtFFOYY09Edg_ibNTRYfxHh1HRjqgpRyBy7jUZYJgEJxA@mail.gmail.com>
Subject: Re: [PATCH v6] kvm: make vcpu life cycle separated from kvm instance
From: Liu ping fan <kernelfans@gmail.com>
To: Avi Kivity <avi@redhat.com>
Cc: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, aliguori@us.ibm.com, gleb@redhat.com,
        mtosatti@redhat.com, xiaoguangrong.eric@gmail.com, jan.kiszka@web.de,
        Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 28, 2011 at 5:53 PM, Avi Kivity <avi@redhat.com> wrote:
> On 12/28/2011 08:54 AM, Liu ping fan wrote:
>> >>
>> >>   struct kvm_vcpu {
>> >>       struct kvm *kvm;
>> >> +     struct list_head list;
>> >>   #ifdef CONFIG_PREEMPT_NOTIFIERS
>> >>       struct preempt_notifier preempt_notifier;
>> >>   #endif
>> >> @@ -251,12 +252,14 @@ struct kvm {
>> >>       struct mm_struct *mm; /* userspace tied to this vm */
>> >>       struct kvm_memslots *memslots;
>> >>       struct srcu_struct srcu;
>> >> +     struct srcu_struct srcu_vcpus;
>> >> +
>> >
>> > Another srcu.  This alone is worth explaining in the changelog IMO.
>> >
>> Sorry, but why? I think it is just a srcu, and because it has
>> different aim and want a independent grace period, so not multiplex
>> kvm->srcu.
>
> There is Documentation/virtual/kvm/locking.txt for that.
>
> btw, why does it have to be srcu?  Is rcu insufficient?
>
Just to survive from "if (yield_to(task, 1)) in  kvm_vcpu_on_spin()",

> Why do we want an independent grace period, is hotunplugging a vcpu that
> much different from hotunplugging memory?
>
I thought that if less readers on the same srcu lock, then
synchronize_srcu_expedited() may success to return more quickly.

Thanks and regards,
ping fan
> --
> error compiling committee.c: too many arguments to function
>
