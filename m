Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757385Ab1EXVbe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 17:31:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48738 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753842Ab1EXVbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 17:31:33 -0400
MIME-Version: 1.0
In-Reply-To: <1306272274.2497.73.camel@laptop>
References: <4ddad79317108eb33d@agluck-desktop.sc.intel.com>
 <20110524034023.GB25230@elte.hu> <987664A83D2D224EAE907B061CE93D5301D5D0595B@orsmsx505.amr.corp.intel.com>
 <20110524173326.GA7635@gere.osrc.amd.com> <BANLkTinSOFAioAe2v5c6PRB9EKjJJNMg9w@mail.gmail.com>
 <1306272274.2497.73.camel@laptop>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 24 May 2011 14:30:41 -0700
Message-ID: <BANLkTi=BrrwL=gzn7H6O1rAGJpe=VPAQRQ@mail.gmail.com>
Subject: Re: [RFC 0/9] mce recovery for Sandy Bridge server
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Tony Luck <tony.luck@intel.com>, Borislav Petkov <bp@amd64.org>,
        Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, Andi Kleen <andi@firstfloor.org>,
        Borislav Petkov <bp@alien8.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 24, 2011 at 2:24 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>
> Right, so you can't do things like that from NMI context, but what perf
> can do is raise a self-IPI and continue from IRQ context (question for
> the HW folks, can there be cycles between the NMI iret and IRQ assert
> from whatever context was before the NMI hit?)

Of course there can be - the code where the NMI hit may have
interrupts disabled.

                                Linus
