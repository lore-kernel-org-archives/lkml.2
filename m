Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756287Ab1KII4v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 03:56:51 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:32904 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750936Ab1KII4t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 03:56:49 -0500
Date: Wed, 9 Nov 2011 09:55:10 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Gerd Hoffmann <kraxel@redhat.com>, Theodore Tso <tytso@mit.edu>,
        Anthony Liguori <anthony@codemonkey.ws>,
        Pekka Enberg <penberg@kernel.org>, Vince Weaver <vince@deater.net>,
        Avi Kivity <avi@redhat.com>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        qemu-devel Developers <qemu-devel@nongnu.org>,
        Alexander Graf <agraf@suse.de>, Blue Swirl <blauwirbel@gmail.com>,
        =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [F.A.Q.] the advantages of a shared tool/kernel Git repository,
 tools/perf/ and tools/kvm/
Message-ID: <20111109085510.GE11473@elte.hu>
References: <CAOJsxLEKx5M5L_N42pQpo2hcNhseQKhUo6CXAyQHesJRWFASKQ@mail.gmail.com>
 <4EB85969.2010108@codemonkey.ws>
 <12F471C8-2CF3-4CD7-B417-C8CC898669E6@mit.edu>
 <20111108093225.GB32533@elte.hu>
 <EDBAFB6F-4E3B-42B0-93E6-DF162B9859A6@mit.edu>
 <20111108125609.GA14272@ghostprotocols.net>
 <4EB9315A.10806@redhat.com>
 <20111108143228.GC14272@ghostprotocols.net>
 <4EB94D08.3010207@redhat.com>
 <20111108161342.GD14272@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111108161342.GD14272@ghostprotocols.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
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


* Arnaldo Carvalho de Melo <acme@redhat.com> wrote:

> > sure the colors have enougth contrast so they are readable.
> 
> Problem is figuring out something that is considered a good default 
> :-\ There will always be somebody that will complain.
> 
> When doing the coding to allow using the default xterm colors I 
> tried several of the gnome-terminal xterm profiles and all looked 
> kinda sane for the "top" (hottest functions, with most hits) and 
> "medium" lines, where we combine some chosen foreground color 
> ("red" and "green").
> 
> Laziest solution would be: If the user customizes that much, could 
> the user please customize this as well? :-)

I don't think it's acceptable to output unreadable color combinations 
(red on dark red, etc.) in any case, so we should add some safety 
mechanism that detects bad color combinations and a fallback, static 
color scheme.

I like the current way how perf top/report adapts to the xterm color 
scheme. I use it both on dark and white backgrounds and it's easy to 
mistake it for --stdio output - which is good, a good TUI should 
blend into the console's color scheme. So i think we should keep that 
and just detect the few cases where it results in something 
unreadable.

Thanks,

	Ingo
