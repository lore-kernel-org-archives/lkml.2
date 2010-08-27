Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986Ab0H0Obr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 10:31:47 -0400
Received: from relay2.sgi.com ([192.48.179.30]:35212 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751872Ab0H0Obo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 10:31:44 -0400
Date: Fri, 27 Aug 2010 15:31:35 +0100
From: Hedi Berriche <hedi@sgi.com>
To: Petr Tesarik <ptesarik@suse.cz>
Cc: linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tony Luck <tony.luck@intel.com>
Subject: Re: Serious problem with ticket spinlocks on ia64
Message-ID: <20100827143135.GY18967@zorg.emea.sgi.com>
Mail-Followup-To: Petr Tesarik <ptesarik@suse.cz>,
	linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org,
	Tony Luck <tony.luck@intel.com>
References: <201008271537.35709.ptesarik@suse.cz> <20100827134802.GX18967@zorg.emea.sgi.com> <201008271609.16099.ptesarik@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201008271609.16099.ptesarik@suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 27, 2010 at 15:09 Petr Tesarik wrote:
| On Friday 27 of August 2010 15:48:02 Hedi Berriche wrote:
|
| > One more fact, the problem was introduced by commit
| >
| >     commit 9d40ee200a527ce08ab8c793ba8ae3e242edbb0e
| >     Author: Tony Luck <tony.luck@intel.com>
| >     Date:   Wed Oct 7 10:54:19 2009 -0700
| >
| >         [IA64] Squeeze ticket locks back into 4 bytes.
| >
| > Reverting the patch makes the problem go away.
| >
| > IOW, and as far as testing shows, the first incarnation of the ticket locks
| > implementation on IA64 (commit 2c8696), the one that used 8 bytes, does not
| > exhibit this problem.
| 
| I wouldn't be so sure about it. Given that I have only observed the problem 
| when the spinlock value wraps around, then an 8-byte spinlock might only need 
| much more time to trigger the bug.

That's a possibility and that's why I said "as far as testing shows".

That said, I'm letting my already over 36 hours run carry on chewing CPU
time, and see if it will eventually trip the same problem seen with 4-byte
ticket locks.

Cheers,
Hedi.
-- 
Hedi Berriche
Global Product Support
http://www.sgi.com/support
