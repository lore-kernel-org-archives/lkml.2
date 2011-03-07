Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752279Ab1CGOZi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 09:25:38 -0500
Received: from usmamail.tilera.com ([206.83.70.70]:61297 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731Ab1CGOZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 09:25:37 -0500
Message-ID: <4D74EADE.1030107@tilera.com>
Date: Mon, 7 Mar 2011 09:25:34 -0500
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.15) Gecko/20110303 Lightning/1.0b2 Thunderbird/3.1.9
MIME-Version: 1.0
To: Michel Lespinasse <walken@google.com>
CC: Darren Hart <dvhltc@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Matt Turner <mattst88@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        David Howells <dhowells@redhat.com>, Tony Luck <tony.luck@intel.com>,
        Michal Simek <monstr@monstr.eu>, Ralf Baechle <ralf@linux-mips.org>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] futex: cmpxchg_futex_value_locked API change
References: <20110307021127.GB31188@google.com>
In-Reply-To: <20110307021127.GB31188@google.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/6/2011 9:11 PM, Michel Lespinasse wrote:
> The cmpxchg_futex_value_locked API was funny in that it returned either
> the original, user-exposed futex value OR an error code such as -EFAULT.
> This was confusing at best, and could be a source of livelocks in places
> that retry the cmpxchg_futex_value_locked after trying to fix the issue
> by running fault_in_user_writeable().
>
> This change makes the cmpxchg_futex_value_locked API more similar to the
> get_futex_value_locked one, returning an error code and updating the
> original value through a reference argument.
> [...]
> diff --git a/arch/tile/include/asm/futex.h b/arch/tile/include/asm/futex.h

Makes sense to me; that API is a little crazy.

For the tile changes:

Acked-by: Chris Metcalf <cmetcalf@tilera.com>

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

