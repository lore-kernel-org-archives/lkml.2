Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757612Ab1EXVe1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 17:34:27 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44695 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752792Ab1EXVe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 17:34:26 -0400
Subject: Re: [RFC 0/9] mce recovery for Sandy Bridge server
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tony Luck <tony.luck@intel.com>, Borislav Petkov <bp@amd64.org>,
        Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, Andi Kleen <andi@firstfloor.org>,
        Borislav Petkov <bp@alien8.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
In-Reply-To: <BANLkTi=BrrwL=gzn7H6O1rAGJpe=VPAQRQ@mail.gmail.com>
References: <4ddad79317108eb33d@agluck-desktop.sc.intel.com>
	 <20110524034023.GB25230@elte.hu>
	 <987664A83D2D224EAE907B061CE93D5301D5D0595B@orsmsx505.amr.corp.intel.com>
	 <20110524173326.GA7635@gere.osrc.amd.com>
	 <BANLkTinSOFAioAe2v5c6PRB9EKjJJNMg9w@mail.gmail.com>
	 <1306272274.2497.73.camel@laptop>
	 <BANLkTi=BrrwL=gzn7H6O1rAGJpe=VPAQRQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 May 2011 23:37:42 +0200
Message-ID: <1306273062.2497.80.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-24 at 14:30 -0700, Linus Torvalds wrote:
> On Tue, May 24, 2011 at 2:24 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> >
> > Right, so you can't do things like that from NMI context, but what perf
> > can do is raise a self-IPI and continue from IRQ context (question for
> > the HW folks, can there be cycles between the NMI iret and IRQ assert
> > from whatever context was before the NMI hit?)
> 
> Of course there can be - the code where the NMI hit may have
> interrupts disabled.

D'0h yes of course!..

Then I can't immediately see a way to stop a thread dead in its tracks.
Userspace yes, but not kernel-space.

