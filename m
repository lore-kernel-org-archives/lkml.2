Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932814Ab2ASTjC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 14:39:02 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48296 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932675Ab2ASTjA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 14:39:00 -0500
Date: Thu, 19 Jan 2012 20:38:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Kay Sievers <kay.sievers@vrfy.org>, "Luck, Tony" <tony.luck@intel.com>,
        Greg KH <gregkh@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Sergei Trofimovich <slyich@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        Borislav Petkov <bp@amd64.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "prasad@linux.vnet.ibm.com" <prasad@linux.vnet.ibm.com>,
        Ming Lei <tom.leiming@gmail.com>, Djalal Harouni <tixxdz@opendz.org>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Andi Kleen <ak@linux.intel.com>,
        "gouders@et.bocholt.fh-gelsenkirchen.de" 
	<gouders@et.bocholt.fh-gelsenkirchen.de>,
        Marcos Souza <marcos.mage@gmail.com>,
        "justinmattock@gmail.com" <justinmattock@gmail.com>,
        Jeff Chua <jeff.chua.linux@gmail.com>
Subject: Re: [PATCH] mce: fix warning messages about static struct mce_device
Message-ID: <20120119193820.GA28362@elte.hu>
References: <4F181ACF.20505@linux.vnet.ibm.com>
 <Pine.LNX.4.44L0.1201191007541.1447-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1201191007541.1447-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alan Stern <stern@rowland.harvard.edu> wrote:

> Or to put it another way, even though no code takes references 
> to these device structures (can you really guarantee that even 
> now?), [...]

That's a good question. Do these devices get exposed to 
user-space access via sysfs somehow, where such an extra 
reference could materialize?

> [...] how do you prevent references being taken in future 
> versions of the kernel?  Calling memset while there still are 
> outstanding references very definitely _is_ a bug.

Unless there's a reference i missed the 'refcounting' here is 
very simple and does not exist at all.

IMHO you should not impose complexity and abstraction on code 
just because. Now i don't care much about the extra pointer, but 
the [NR_CPUS] array was doubly ugly (and Greg promised to fix 
that, so no problems from me).

So the conclusion is that the reasons stated here don't really 
apply. The one i mentioned *does* apply: the original bug was 
due to sloppy life time rules of this driver buffer, and that 
came back to bite us. Making it dynamic solves that kind of 
problem. In that sense the warning is fine too.

Thanks,

	Ingo
