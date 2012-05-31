Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758270Ab2EaSDt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 14:03:49 -0400
Received: from casper.infradead.org ([85.118.1.10]:38574 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754138Ab2EaSDq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 14:03:46 -0400
Message-ID: <1338487413.28384.103.camel@twins>
Subject: Re: [PATCH 1/5] ftrace: Synchronize variable setting with
 breakpoints
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Dave Jones <davej@redhat.com>,
        Andi Kleen <ak@linux.intel.com>
Date: Thu, 31 May 2012 20:03:33 +0200
In-Reply-To: <1338486820.13348.366.camel@gandalf.stny.rr.com>
References: <20120531012829.160060586@goodmis.org>
	 <20120531020440.476352979@goodmis.org> <1338462398.28384.52.camel@twins>
	 <1338473302.13348.336.camel@gandalf.stny.rr.com>
	 <1338486029.28384.93.camel@twins>
	 <1338486820.13348.366.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-31 at 13:53 -0400, Steven Rostedt wrote:
> On Thu, 2012-05-31 at 19:40 +0200, Peter Zijlstra wrote:
> > On Thu, 2012-05-31 at 10:08 -0400, Steven Rostedt wrote:
> > > > Also, why does this stuff live in ftrace? I always thought you were
> > > > going to replace text_poke() so everybody that uses cross-modifying code
> > > > could profit?
> > > 
> > > I discussed this with Masami at Collaboration Summit. The two are
> > > similar but also very different. But we want to start merging the two
> > > together where it makes sense. 
> > 
> > Argh,. I so disagree. You're doing it backwards.
> > 
> > First you merge whatever is there, regardless of who came first.
> 
> The comment about coming first was more about 're-inventing' then about
> merging. You can't reinvent something that didn't exist.
> 
> That said, I didn't even think about text poke while doing this.

Well, the fail is before that, how could we grow two pieces of code
doing similar things in the first place? 

>  I was
> just simply thinking about removing stop_machine from ftrace, that
> required this. It was only a after thought that text_poke() could do the
> same. And this came up at Collab, where I thought, oh yeah! we can
> incorporate this with text poke.

But but but but.. the thing far back when Mathieu proposed the int3
scheme it was text_poke().. how.. did you not think of it this time!?

> 
> > Then, when everybody doing text modification is using the same
> > interface, do a second implementation using a Kconfig knob. If the scary
> > new one breaks, no sweat, flip the config. If its proven stable, kill
> > off the old one.
> 
> What do you suggest then? To revert the code and rewrite it so that
> text_poke() does a similar thing?

Too late for that now I guess.. I just wonder why you all thought it was
a good idea to have two pieces of code doing cross-modifying-code. I
always assumed ftrace used text_poke().

I hardly ever use dyn-ftrace but I do use some text_poke() through
jump_labels.

I would still like to end up with one code base doing CMC with two
implementations depending on a Kconfig knob.
