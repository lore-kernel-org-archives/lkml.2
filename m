Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756209Ab2EaRxp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 13:53:45 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20904 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756107Ab2EaRxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 13:53:43 -0400
X-Authority-Analysis: v=2.0 cv=D8PF24tj c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=nA43mK65oyIA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=x471vVjH-gD-dFFqGdQA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1338486820.13348.366.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 1/5] ftrace: Synchronize variable setting with
 breakpoints
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Dave Jones <davej@redhat.com>,
        Andi Kleen <ak@linux.intel.com>
Date: Thu, 31 May 2012 13:53:40 -0400
In-Reply-To: <1338486029.28384.93.camel@twins>
References: <20120531012829.160060586@goodmis.org>
	 <20120531020440.476352979@goodmis.org> <1338462398.28384.52.camel@twins>
	 <1338473302.13348.336.camel@gandalf.stny.rr.com>
	 <1338486029.28384.93.camel@twins>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-31 at 19:40 +0200, Peter Zijlstra wrote:
> On Thu, 2012-05-31 at 10:08 -0400, Steven Rostedt wrote:
> > > Also, why does this stuff live in ftrace? I always thought you were
> > > going to replace text_poke() so everybody that uses cross-modifying code
> > > could profit?
> > 
> > I discussed this with Masami at Collaboration Summit. The two are
> > similar but also very different. But we want to start merging the two
> > together where it makes sense. 
> 
> Argh,. I so disagree. You're doing it backwards.
> 
> First you merge whatever is there, regardless of who came first.

The comment about coming first was more about 're-inventing' then about
merging. You can't reinvent something that didn't exist.

That said, I didn't even think about text poke while doing this. I was
just simply thinking about removing stop_machine from ftrace, that
required this. It was only a after thought that text_poke() could do the
same. And this came up at Collab, where I thought, oh yeah! we can
incorporate this with text poke.


> Then, when everybody doing text modification is using the same
> interface, do a second implementation using a Kconfig knob. If the scary
> new one breaks, no sweat, flip the config. If its proven stable, kill
> off the old one.

What do you suggest then? To revert the code and rewrite it so that
text_poke() does a similar thing?

-- Steve


