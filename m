Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932462Ab2JRWjt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 18:39:49 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:36521 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932248Ab2JRWjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 18:39:47 -0400
MIME-Version: 1.0
In-Reply-To: <507F7313.8010707@oracle.com>
References: <507F7313.8010707@oracle.com>
Date: Thu, 18 Oct 2012 15:39:45 -0700
X-Google-Sender-Auth: JYmN1ZPjD-lvQ0H8IXYRU6gFbSI
Message-ID: <CAGXu5jKSD8nRMJ11DpKRe8M79W9MZ2eowAafXOQ9_WCj4dZXug@mail.gmail.com>
Subject: Re: yama: lockdep warning on yama_ptracer_del
From: Kees Cook <keescook@chromium.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: james.l.morris@oracle.com, John Johansen <john.johansen@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-security-module@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2012 at 8:10 PM, Sasha Levin <sasha.levin@oracle.com> wrote:
> Hi all,
>
> I was fuzzing with trinity within a KVM tools guest (lkvm) on a linux-next kernel, and got the
> following dump which I believe to be noise due to how the timers work - but I'm not 100% sure.
> ...
> [  954.674123]  Possible interrupt unsafe locking scenario:
> [  954.674123]
> [  954.674123]        CPU0                    CPU1
> [  954.674123]        ----                    ----
> [  954.674123]   lock(ptracer_relations_lock);
> [  954.674123]                                local_irq_disable();
> [  954.674123]                                lock(&(&new_timer->it_lock)->rlock);
> [  954.674123]                                lock(ptracer_relations_lock);
> [  954.674123]   <Interrupt>
> [  954.674123]     lock(&(&new_timer->it_lock)->rlock);
> [  954.674123]
> [  954.674123]  *** DEADLOCK ***

I've been wanting to get rid of the Yama ptracer_relations_lock
anyway, so maybe I should do that now just to avoid this case at all?

-Kees

-- 
Kees Cook
Chrome OS Security
