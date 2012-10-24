Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933714Ab2JXMsi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 08:48:38 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:56657 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932517Ab2JXMsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 08:48:37 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1210232138540.2756@ionos>
References: <CAAHN_R1O3asyJGXqjs5qt0b_qGR6S6RuM+E_85VaEoWAyAMheQ@mail.gmail.com>
	<1350876034-22023-1-git-send-email-siddhesh.poyarekar@gmail.com>
	<5086A3D1.7080709@linux.intel.com>
	<alpine.LFD.2.02.1210232138540.2756@ionos>
Date: Wed, 24 Oct 2012 18:18:36 +0530
Message-ID: <CAAHN_R0jTey+4TOXfKh96aApOPUXQq6wwobejmhFeRuTV2VJKA@mail.gmail.com>
Subject: Re: [PATCH] [RESEND 2] Take over futex of dead task only if
 FUTEX_WAITERS is not set
From: Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Darren Hart <dvhart@linux.intel.com>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Now there is a different solution to that problem. Do not look at the
> user space value at all and enforce a lookup of possibly available
> pi_state. If pi_state can be found, then the new incoming locker T3
> blocks on that pi_state and legitimately races with T2 to acquire the
> rt_mutex and the pi_state and therefor the proper ownership of the
> user space futex.

That works. Thanks for the detailed explanation too.


-- 
http://siddhesh.in
