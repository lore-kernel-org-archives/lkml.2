Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752636Ab1LSM71 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 07:59:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1563 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752478Ab1LSM7Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 07:59:25 -0500
Message-ID: <4EEF351E.8040002@redhat.com>
Date: Mon, 19 Dec 2011 14:59:10 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Eric B Munson <emunson@mgebm.net>, mingo@redhat.com, hpa@zytor.com,
        arnd@arndb.de, ryanh@linux.vnet.ibm.com, aliguori@us.ibm.com,
        jeremy.fitzhardinge@citrix.com, levinsasha928@gmail.com,
        Jan Kiszka <jan.kiszka@siemens.com>, kvm@vger.kernel.org,
        linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5 V5] Avoid soft lockup message when KVM is stopped
 by host
References: <1323116344-17911-1-git-send-email-emunson@mgebm.net> <4EDF7B0D.4060001@redhat.com> <20111214121622.GB18317@amt.cnet> <4EE8B53C.6070502@redhat.com> <20111214182101.GB21945@amt.cnet> <4EE9CA1C.3010801@redhat.com> <20111216093149.GA26982@amt.cnet>
In-Reply-To: <20111216093149.GA26982@amt.cnet>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/2011 11:31 AM, Marcelo Tosatti wrote:
> > >
> > > Slow enough that progress of the watchdog thread is unable to keep up
> > > with timer interrupt processing. This is considered a hang and
> > > should be reported.
> > 
> > It's not a guest hang though!
>
> No, but your host system is in such a load state that for the sake of
> system usability you better print out a warning message.

What's the point in printing it in the guest?  The guest can't observe
host conditions.

> I don't see the advantage of preempt notifiers over the simple, paravirt
> solution proposed? Note kvmclock is already paravirt.

Right.

> What do you want to be done in preempt notifiers? Measure what to
> consider setting this flag?

Preemption while TASK_RUNNING or TASK_UNINTERRUPTIBLE.

-- 
error compiling committee.c: too many arguments to function

