Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933636Ab0KOT1U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 14:27:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55206 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933611Ab0KOT1S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 14:27:18 -0500
Date: Mon, 15 Nov 2010 20:19:55 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: David Daney <ddaney@caviumnetworks.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, arnd@arndb.de,
        benh@kernel.crashing.org, cmetcalf@tilera.com, davem@davemloft.net,
        deller@gmx.de, heiko.carstens@de.ibm.com, hpa@zytor.com,
        jejb@parisc-linux.org, kyle@mcmartin.ca, mingo@elte.hu,
        roland@redhat.com, schwidefsky@de.ibm.com, tglx@linutronix.de,
        tony.luck@intel.com
Subject: Re: +
	exec_domain-establish-a-linux32-domain-on-config_compat-systems.patc
	h added to -mm tree
Message-ID: <20101115191955.GA17342@redhat.com>
References: <201011122022.oACKM6HH029696@imap1.linux-foundation.org> <20101113171722.GA2956@redhat.com> <4CE182A2.1020606@caviumnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CE182A2.1020606@caviumnetworks.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15, David Daney wrote:
>
> On 11/13/2010 09:17 AM, Oleg Nesterov wrote:
>>
>>> We can avoid the failed module loading overhead by building-in the
>>> linux32_exec_domain for systems that have CONFIG_COMPAT.
>>
>> Indeed. But at the same time this means it is not possible to use
>> personality-8.ko if the system has it.
>
> Well in the same way it is not possible to use personality-0.ko
> (PER_LINUX) because it is just as built-in.

Sure, but this was never possible. But your patch adds the obvious
user-visible change.

>> Don't get me wrong, I have no idea why anyone could want this module,
>> just I am a bit worried.
>
> If the personality is built-in, then I don't see how it makes any sense
> to attempt to override it with an externally supplied version.  If you
> want set a domain for PER_LINUX32, don't configure you system to supply
> a default version.

Well, no need to convince me ;) To me, this request_module() doesn't
make any sense at all.

I won't argue against this change. Just I wanted to be sure this
issue is not overlooked.

Oleg.

