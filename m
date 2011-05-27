Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538Ab1E0NiU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 09:38:20 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56610 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751152Ab1E0NiS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 09:38:18 -0400
Date: Fri, 27 May 2011 15:38:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Dan Rosenberg <drosenberg@vsecurity.com>, Tony Luck <tony.luck@gmail.com>,
        linux-kernel@vger.kernel.org, davej@redhat.com,
        kees.cook@canonical.com, davem@davemloft.net, eranian@google.com,
        torvalds@linux-foundation.org, adobriyan@gmail.com, penberg@kernel.org,
        hpa@zytor.com, Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Valdis.Kletnieks@vt.edu,
        pageexec@freemail.hu, Eric Paris <eparis@redhat.com>
Subject: Re: [RFC][PATCH] Randomize kernel base address on boot
Message-ID: <20110527133804.GC23626@elte.hu>
References: <1306269105.21443.20.camel@dan>
 <20110526203502.GK29496@redhat.com>
 <20110526204030.GL29496@redhat.com>
 <1306442674.2279.29.camel@dan>
 <20110526205549.GM29496@redhat.com>
 <20110527093853.GI21386@elte.hu>
 <20110527130731.GA8053@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110527130731.GA8053@redhat.com>
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


* Vivek Goyal <vgoyal@redhat.com> wrote:

> On Fri, May 27, 2011 at 11:38:53AM +0200, Ingo Molnar wrote:
> > 
> > * Vivek Goyal <vgoyal@redhat.com> wrote:
> > 
> > > > Is it common to run kexec-tools as non-root?  It may be necessary 
> > > > to restrict this interface to root when randomization is used 
> > > > (keep in mind nobody's going to force you to turn this on by 
> > > > default, at least for the foreseeable future).
> > > 
> > > kexec-tools runs as root. And I see that /proc/iomem permissions 
> > > are also for root only. So it probably is a non-issue.
> > 
> > it might be an issue to keep in mind for later projects that try to 
> > lock down root itself from being able to patch the kernel (other than 
> > rebooting the box), using signed modules, disabled direct-ioport 
> > access, and other hardened facilities.
> 
> For such environments, Eric Paris had posted a patch to be able to 
> disable loading of kexec/kdump kernel, similar to disabling module 
> loading.
> 
>    https://lkml.org/lkml/2011/1/19/412
> 
> I don't see that in Linus's tree. So looks like it never got 
> committed.

That patch looks sane enough. Ping akpm about it please?

Thanks,

	Ingo
