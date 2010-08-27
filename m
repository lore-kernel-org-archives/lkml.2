Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215Ab0H0OkU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 10:40:20 -0400
Received: from cantor.suse.de ([195.135.220.2]:58442 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752534Ab0H0OkR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 10:40:17 -0400
From: Petr Tesarik <ptesarik@suse.cz>
Organization: SUSE LINUX, s.r.o.
To: Hedi Berriche <hedi@sgi.com>
Subject: Re: Serious problem with ticket spinlocks on ia64
Date: Fri, 27 Aug 2010 16:40:48 +0200
User-Agent: KMail/1.9.10
Cc: linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tony Luck <tony.luck@intel.com>
References: <201008271537.35709.ptesarik@suse.cz> <201008271609.16099.ptesarik@suse.cz> <20100827143135.GY18967@zorg.emea.sgi.com>
In-Reply-To: <20100827143135.GY18967@zorg.emea.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201008271640.49542.ptesarik@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 27 of August 2010 16:31:35 Hedi Berriche wrote:
> On Fri, Aug 27, 2010 at 15:09 Petr Tesarik wrote:
> | On Friday 27 of August 2010 15:48:02 Hedi Berriche wrote:
> | > One more fact, the problem was introduced by commit
> | >
> | >     commit 9d40ee200a527ce08ab8c793ba8ae3e242edbb0e
> | >     Author: Tony Luck <tony.luck@intel.com>
> | >     Date:   Wed Oct 7 10:54:19 2009 -0700
> | >
> | >         [IA64] Squeeze ticket locks back into 4 bytes.
> | >
> | > Reverting the patch makes the problem go away.
> | >
> | > IOW, and as far as testing shows, the first incarnation of the ticket
> | > locks implementation on IA64 (commit 2c8696), the one that used 8
> | > bytes, does not exhibit this problem.
> |
> | I wouldn't be so sure about it. Given that I have only observed the
> | problem when the spinlock value wraps around, then an 8-byte spinlock
> | might only need much more time to trigger the bug.
>
> That's a possibility and that's why I said "as far as testing shows".
>
> That said, I'm letting my already over 36 hours run carry on chewing CPU
> time, and see if it will eventually trip the same problem seen with 4-byte
> ticket locks.

Hm, this doesn't sound like a viable approach. Since the siglock gets 
initialized to 0 when a new process is started, it may never actually wrap 
around.

I would rather attach a SystemTap probe somewhere during process fork and add 
a bias to the siglock. That should work fine. Let me knock up the SystemTap 
script...

Petr
