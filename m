Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596Ab0F3JYZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 05:24:25 -0400
Received: from casper.infradead.org ([85.118.1.10]:40649 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805Ab0F3JYX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 05:24:23 -0400
Subject: Re: [PATCH 4/4, v2] x86: enlightenment for ticket spin locks -
 improve yield behavior on Xen
From: Peter Zijlstra <peterz@infradead.org>
To: Jan Beulich <JBeulich@novell.com>
Cc: jeremy.fitzhardinge@citrix.com, mingo@elte.hu, tglx@linutronix.de,
       Ky Srinivasan <KSrinivasan@novell.com>, linux-kernel@vger.kernel.org,
       hpa@zytor.com
In-Reply-To: <4C2B21300200007800008BDC@vpn.id2.novell.com>
References: <4C2A20E30200007800008A17@vpn.id2.novell.com>
	 <1277885485.1868.74.camel@laptop>
	 <4C2B21300200007800008BDC@vpn.id2.novell.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 30 Jun 2010 11:24:14 +0200
Message-ID: <1277889854.1868.104.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-30 at 09:49 +0100, Jan Beulich wrote:
> >>> On 30.06.10 at 10:11, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Tue, 2010-06-29 at 15:35 +0100, Jan Beulich wrote:
> >> 
> >> The (only) additional overhead this introduces for native execution is
> >> the writing of the owning CPU in the lock acquire paths. 
> > 
> > Uhm, and growing the size of spinlock_t to 6 (or 8 bytes when aligned)
> > bytes when NR_CPUS>256.
> 
> Indeed, I should have mentioned that. Will do so in an eventual
> next version.

It would be good to also get a measure of data structure bloat caused by
this, not sure .data section size is representable there, but its
something easy to provide.

Something like: pahole -s build/vmlinux | awk '{t+=$2} END {print t}'
from before and after might also be interesting.
