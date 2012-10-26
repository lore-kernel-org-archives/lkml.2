Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932861Ab2JZM5S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 08:57:18 -0400
Received: from casper.infradead.org ([85.118.1.10]:42655 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932766Ab2JZM5Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 08:57:16 -0400
Message-ID: <1351256204.16863.56.camel@twins>
Subject: Re: [PATCH 01/16] math128: Introduce various 128bit primitives
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Juri Lelli <juri.lelli@gmail.com>, mingo@redhat.com,
        rostedt@goodmis.org, oleg@redhat.com, fweisbec@gmail.com,
        darren@dvhart.com, johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, nicola.manica@disi.unitn.it,
        luca.abeni@unitn.it, dhaval.giani@gmail.com, hgu1972@gmail.com,
        paulmck@linux.vnet.ibm.com, raistlin@linux.it, insop.song@ericsson.com,
        liming.wang@windriver.com, jkacur@redhat.com,
        harald.gustafsson@ericsson.com, vincent.guittot@linaro.org,
        Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 26 Oct 2012 14:56:44 +0200
In-Reply-To: <1351248244.16863.13.camel@twins>
References: <1351115634-8420-1-git-send-email-juri.lelli@gmail.com>
	 <1351115634-8420-2-git-send-email-juri.lelli@gmail.com>
	 <CA+55aFwLnz4ZNgKxJ6ANn7usppJC_OKHy0uVuh2+EhYTuiL5yw@mail.gmail.com>
	 <1351172849.12171.10.camel@twins>
	 <CA+55aFx5jCKtEbEY9iuv0J2TFipkwJP=tBH-F2x_bzJG1RBzTQ@mail.gmail.com>
	 <1351241389.12171.45.camel@twins> <20121026092421.GB628@gmail.com>
	 <1351244130.16863.7.camel@twins> <20121026094207.GA2179@gmail.com>
	 <1351245264.16863.12.camel@twins>
	 <alpine.LFD.2.02.1210261208170.2756@ionos>
	 <1351248244.16863.13.camel@twins>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-10-26 at 12:44 +0200, Peter Zijlstra wrote:
> > We can still have the user space interface handing in the information
> > in nsec resolution, but it's reasonable to scale it down to something
> > useful. Just shift the incoming information right by 10, so you're in
> > the 1us resolution for all the internal math and all your limitation
> > problems are gone. A shift by ten for converting back and forth to
> > nsecs is not a real performance issue.
> 
> I'm fine with that.. all I wanted was to not have the undefined overflow
> we initially had. 

Note that we still need the constraint checking with this, although with
both values shifted right 10 bits the range is now much bigger and
shouldn't be a practical limit anymore.
