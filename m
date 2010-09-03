Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753090Ab0ICGjr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 02:39:47 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57799 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751432Ab0ICGjp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 02:39:45 -0400
Date: Fri, 3 Sep 2010 08:39:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] [arch-x86] Allow SRAT integrity check to be skipped
Message-ID: <20100903063934.GA25863@elte.hu>
References: <20100901213318.19353.54619.stgit@localhost.localdomain>
 <20100902065731.GB29972@elte.hu>
 <20100902100308.GA17167@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100902100308.GA17167@basil.fritz.box>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> > This isnt a particularly useful solution to users of said systems - 
> > they have to figure out that this option exists, and then they have 
> > to enter this option on the boot line.
> 
> This usually only happens in early preproduction systems. So far the 
> BIOS always got fixed before they shipped to users.

'Usually' != 'always'. Read the changelog:

  ' There are BIOSes in production that have these failures, so this will 
    allow people in the field to work around these BIOS issues. '

Peter, which system in production that has this problem? That one needs 
a DMI match.

Preproduction systems can certainly be hacked around with the boot 
option and are not worth the DMI match. (preproduction systems also tend 
to have have very unspecific DMI strings in most cases - things like 
'1234567890' or 'to be filled by OEM')

In important cases a PCI ID match can be done for serious bugs in 
widespread preproduction systems - we have a handful of examples in-tree 
for such workarounds - but i doubt this is such a case - we use it for 
crasher bugs, not for 'boots up slow' cases.

Nevertheless, production systems need a DMI match.

Thanks,

	Ingo
