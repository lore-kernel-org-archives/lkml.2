Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754679Ab2ECAQG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 20:16:06 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60834 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754309Ab2ECAQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 20:16:04 -0400
Date: Thu, 3 May 2012 09:15:58 +0900
From: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, Avi Kivity <avi@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 06/10] KVM: MMU: fast path of handling guest page
 fault
Message-Id: <20120503091558.866e158916f0dd67daf5a9a2@gmail.com>
In-Reply-To: <4FA0C8A7.9000001@linux.vnet.ibm.com>
References: <4F9776D2.7020506@linux.vnet.ibm.com>
	<4F9777A4.208@linux.vnet.ibm.com>
	<20120426234535.GA5057@amt.cnet>
	<4F9A3445.2060305@linux.vnet.ibm.com>
	<20120427145213.GB28796@amt.cnet>
	<20120429175004.b54d8c095a60d98c8cdbc942@gmail.com>
	<4FA0C8A7.9000001@linux.vnet.ibm.com>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 02 May 2012 13:39:51 +0800
Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com> wrote:

> > Was the problem really mmu_lock contention?

> Takuya, i am so tired to argue the advantage of lockless write-protect
> and lockless O(1) dirty-log again and again.

You are missing my point.  Please do not take my comments as an objection
to your whole work: whey do you feel so?

I thought that your new fast-page-fault path was fast and optimized
the guest during dirty logging.

So in this v4, you might get a similar result even before dropping
mmu_lock, without 07/10?, if the problem Marcelo explained was not there.


Of course there is a problem of mmu_lock contention.  What I am suggesting
is to split that problem and do measurement separately so that part of
your work can be merged soon.

Your guest size and workload was small to make get_dirty hold mmu_lock
long time.  If you want to appeal the real value of lock-less, you need to
do another measurment.


But this is your work and it's up to you.  Although I was thinking to help
your measurement, I cannot do that knowing the fact that you would not
welcome my help.


> > Although I am not certain about what will be really needed in the
> > final form, if this kind of maybe-needed-overhead is going to be
> > added little by little, I worry about possible regression.

> Well, will you suggest Linus to reject all patches and stop
> all discussion for the "possible regression" reason?

My concern was for Marcelo's examples, not your current implementation.
If you can show explicitely what will be needed in the final form,
I do not have any concern.


Sorry for disturbing.

Thanks,
	Takuya
