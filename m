Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766Ab0HPH2b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 03:28:31 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37632 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751339Ab0HPH2a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 03:28:30 -0400
Date: Mon, 16 Aug 2010 09:28:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH] x86: Don't write io_apic ID if it is not changed
Message-ID: <20100816072805.GA22479@elte.hu>
References: <4C66FEA9.3040303@kernel.org>
 <m1hbiv6fcb.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1hbiv6fcb.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.2.5
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.2916]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Eric W. Biederman <ebiederm@xmission.com> wrote:

> Yinghai Lu <yinghai@kernel.org> writes:
> 
> > For 32bit mptable path, setup_ids_from_mpc() always write io apic id
> > register, even there is no change needed.
> >
> > So try to do that when they are different bewteen reading out and
> > mptable
> 
> What is the advantage of not writing the value?

Just guessing, but if other OSs dont do it we might surprise buggy hardware 
[and trigger erratas in them], so this would be a standard 'dont touch the hw 
unless necessary' defensive move.

Similar bugs are not unprecedented.

Thanks,

	Ingo
