Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756411Ab0FYUFM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 16:05:12 -0400
Received: from mx4-phx2.redhat.com ([209.132.183.25]:56211 "EHLO
	mx02.colomx.prod.int.phx2.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752605Ab0FYUFK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 16:05:10 -0400
Date: Fri, 25 Jun 2010 16:04:41 -0400 (EDT)
From: Ulrich Drepper <drepper@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Darren Hart <dvhltc@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andreas Schwab <schwab@redhat.com>, Danny Feng <dfeng@redhat.com>,
       Jakub Jelinek <jakub@redhat.com>, linux-kernel@vger.kernel.org,
       Oleg Nesterov <oleg@redhat.com>
Message-ID: <235959492.961541277496281970.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
In-Reply-To: <alpine.LFD.2.00.1006252140410.18683@localhost.localdomain>
Subject: Re: Q: sys_futex() && timespec_valid()
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [10.5.5.72]
X-Mailer: Zimbra 5.0.21_GA_3150.RHEL4_64 (ZimbraWebClient - FF3.0 (Linux)/5.0.21_GA_3150.RHEL4_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- "Thomas Gleixner" <tglx@linutronix.de> wrote:
> tv->sec < 0 is definitely an invalid value for both CLOCK_REALTIME
> and CLOCK_MONOTONIC.

CLOCK_MONOTONIC is different but it's wrong for CLOCK_REALTIME.  Why would it be invalid?  Because times before Epoch will not be used?  By that logic you would have to declare all values before Linus' first running kernel as invalid.  None of this makes sense.

The tv_sec in timespec is of type time_t and for absolute time values the same semantics as for naked time_t values applies.  The absolute time is

  epoch + tv_sec + tv_nsec / 1000000000

If tv_sec is negative these are values before epoch.

If there are other interfaces with absolute timeouts they certainly should be changed as well.

-- 
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
