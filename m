Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751979Ab1DLS5D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 14:57:03 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:60411 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901Ab1DLS5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 14:57:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:user-agent;
        b=bKuONYES3LkJRsqrRXMYazmFMs47pUJjvRPmaLcMa/3w6ag0urLfX5kvsEpU/4+0zs
         Xb+X/WuCbEjcU4iAnbwrUcXSwJ0j+yykD5HUk7Ip6/op7Iv58qEwZKNeAVw4J/wPasLZ
         9hZyTYsc00AfmFzPSfmTPMYHv4kM+dRrCLaMw=
Date: Tue, 12 Apr 2011 15:56:52 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Borislav Petkov <bp@alien8.de>, Frederic Weisbecker <fweisbec@gmail.com>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: adding trace-cmd's plugins to perf
Message-ID: <20110412185652.GB20452@ghostprotocols.net>
References: <4DA12905.2020806@gmail.com>
 <20110412162245.GB2240@nowhere>
 <20110412183536.GA20452@ghostprotocols.net>
 <20110412185104.GA9891@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110412185104.GA9891@liondog.tnic>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Apr 12, 2011 at 08:51:04PM +0200, Borislav Petkov escreveu:
> On Tue, Apr 12, 2011 at 03:35:36PM -0300, Arnaldo Carvalho de Melo wrote:
> > Em Tue, Apr 12, 2011 at 06:22:47PM +0200, Frederic Weisbecker escreveu:
> > > On Sat, Apr 09, 2011 at 09:50:29PM -0600, David Ahern wrote:
> > > > Right now perf script cannot process kvm tracepoints:
> > > > 
> > > > perf record -e kvm:* -p 6446 -- sleep 5
> > > > 
> > > > perf script
> > > >   Warning: Error: expected type 4 but read 7
> > 
> > > > are about merging common code between the two commands. Also, trace-cmd and perf
> > > > are in separate repositories so a shared lib is going to inconvenience
> > > > one of the two.
> > > 
> > > So, we copied the tools/perf/util/trace-event-* files from trace-cmd to perf
> > > a while go. Then both files took their own path, both pulling fixes/enhancement
> > > from each others (probably more in the trace-cmd -> perf direction).
> > > 
> > > And perf is indeed a bit backward wrt parsing, because it lacks those plugins
> > > for example. So now it would be nice to unify that in a common lib so that it
> > > works well in both.
> > > 
> > > Steve proposed a shared tools/trace.so, that perf and trace-cmd could plug
> > > into, I really would like to see that happening too.
> > > 
> > > I think Ingo had some reserves about this, due to potential versioning
> > > and compatibility that such a dynamic lib would involve.
> > 
> > So we don't commit to an ABI for a while, just linking with it, changing
> > users when changing the ABI.
> > 
> > I encourage David to go and add the bits of trace-cmd he needs for
> > support the plugins he wants used in perf on tools/lib/ and make perf
> > use it.
> > 
> > That way we again reduce the differences between the codebases, or at least
> > reduce the feature gap.
> 
> Also, just FYI, I have this RAS daemon patchset which splits perf functionality
> into different sub-libs, which are more or less topic based:
> 
> tools/lib/trace/ - all the trace-event* stuff from Steven
> tools/lib/lk/	- generic enough stuff (git headers, etc) which several tools could use
> tools/lib/perf/ - functionality related to perf events
> 
> Here's the last submission http://marc.info/?l=linux-edac&m=129562244211501&w=2
> and I'm currently finishing a new rebase against tip/perf/core.
> 
> If you're fine with that split I'd suggest I load off my stuff first so
> that David can continue from there and I can finally stop rebasing like
> crazy each time perf moves forward.
> 
> Opinions? Suggestions?

Yeah, David, can you try Borislav's patchset and tell us what you think
wrt servicing your needs?

- Arnaldo
