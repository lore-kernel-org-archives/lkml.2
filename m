Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758790Ab2BNCXJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 21:23:09 -0500
Received: from gate.crashing.org ([63.228.1.57]:47411 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751515Ab2BNCXF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 21:23:05 -0500
Message-ID: <1329186144.2534.26.camel@pasglop>
Subject: Re: [RFC 0/5] kernel: backtrace unwind support
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Jan Blunck <jblunck@suse.de>
Date: Tue, 14 Feb 2012 13:22:24 +1100
In-Reply-To: <CA+55aFzhenNyPUzAVpXhuxfVpAuowY+OcvPGyfg8_o9NN4SDtw@mail.gmail.com>
References: <1328873119-21553-1-git-send-email-jolsa@redhat.com>
	 <1328895795.25989.29.camel@laptop>
	 <CA+55aFxgPXjGh0GSHaUGm6-Pfdjjk=PAP7HMuZHcFGE92VutUQ@mail.gmail.com>
	 <20120210192714.GE4998@infradead.org> <20120210194426.GA17650@elte.hu>
	 <20120210201850.GA26892@m.redhat.com>
	 <CA+55aFzhenNyPUzAVpXhuxfVpAuowY+OcvPGyfg8_o9NN4SDtw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-02-10 at 12:37 -0800, Linus Torvalds wrote:
> On Fri, Feb 10, 2012 at 12:18 PM, Jiri Olsa <jolsa@redhat.com> wrote:
> >
> > yep, looks interesting.. not sure about the mathematical proof though ;)
> 
> Well, I can already say what the old code did horribly horribly wrong:
> 
>  - *all* stack accesses need to go through a validation function, they
> can never *ever* just try to access the stack.
> 
>     The validation function really needs to really check the full
> range of the stack area, not something random.
> 
>  - all dwarf information accesses need to similarly validate the
> access, and accept that sometimes the dwarf info is simply missing or
> actively wrong.

In addition it should all go through something like
copy_from_user_inatomic(), ie, all access to that stuff should have
built-in fault recovery without triggering high level page faults, stack
expansion etc...

Cheers,
Ben.


