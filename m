Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753133Ab3ACKqE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 05:46:04 -0500
Received: from mail-vc0-f181.google.com ([209.85.220.181]:50150 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753023Ab3ACKqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 05:46:02 -0500
MIME-Version: 1.0
In-Reply-To: <20130103001536.7fd1e952@annuminas.surriel.com>
References: <20130103001536.7fd1e952@annuminas.surriel.com>
Date: Thu, 3 Jan 2013 02:46:01 -0800
Message-ID: <CANN689GPzjJW7OiYhFJi1xLSN+606auMeJCsxR_CHL_T4aETZg@mail.gmail.com>
Subject: Re: [RFC PATCH 0/5] x86,smp: make ticket spinlock proportional
 backoff w/ auto tuning
From: Michel Lespinasse <walken@google.com>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, aquini@redhat.com, eric.dumazet@gmail.com,
        lwoodman@redhat.com, jeremy@goop.org,
        Jan Beulich <JBeulich@novell.com>,
        Thomas Gleixner <tglx@linutronix.de>, knoel@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 2, 2013 at 9:15 PM, Rik van Riel <riel@redhat.com> wrote:
> The v2 series integrates several ideas from Michel Lespinasse
> and Eric Dumazet, which should result in better throughput and
> nicer behaviour in situations with contention on multiple locks.
>
> Please let me know if you manage to break this code in any way,
> so I can fix it...

I'm seeing some very weird things on my 3 test machines. Looks like
the spinlock delay sometimes gets crazy, at which point spinlock
performance becomes unbearable and the network driver freaks out.

# ./spinlock_load_test
 1 spinlocks: 24159990
 2 spinlocks: 12900657
 3 spinlocks: 11547771
 4 spinlocks: 9113
 6 spinlocks: 259
 8 spinlocks: 310
12 spinlocks: 283
16 spinlocks:
<seems to be stuck here; meanwhile my serial console fills up with
network driver cries>

Well, I take it as an incitation to pay special attention to this code review :)

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
