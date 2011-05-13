Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759443Ab1EMPUt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 11:20:49 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53851 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758615Ab1EMPUr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 11:20:47 -0400
Date: Fri, 13 May 2011 17:20:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: huang ying <huang.ying.caritas@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>, Huang Ying <ying.huang@intel.com>,
        linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Robert Richter <robert.richter@amd.com>,
        Andi Kleen <ak@linux.intel.com>, Borislav Petkov <bp@alien8.de>
Subject: Re: [RFC] x86, NMI, Treat unknown NMI as hardware error
Message-ID: <20110513152033.GB3854@elte.hu>
References: <1305275018-20596-1-git-send-email-ying.huang@intel.com>
 <20110513124523.GM13984@redhat.com>
 <20110513130011.GA6474@elte.hu>
 <BANLkTi=Z_3MZVs2CQyk82NfvZj-KdSw5kw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTi=Z_3MZVs2CQyk82NfvZj-KdSw5kw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* huang ying <huang.ying.caritas@gmail.com> wrote:

> > What should be done instead is to add an event for unknown NMIs, which can 
> > then be processed by the RAS daemon to implement policy.
> >
> > By using 'active' event filters it could even be set on a system to panic 
> > the box by default.
> 
> If there is real fatal hardware error, maybe we have no luxury to go from NMI 
> handler to user space RAS daemon to determine what to do. System may explode, 
> bad data may go to disk before that.

That is why i suggested:

  > > By using 'active' event filters it could even be set on a system to panic 
  > > the box by default.

event filters are evaluated in the kernel, so the panic could be instantaneous, 
without the event having to reach user-space.

Thanks,

	Ingo
