Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757932Ab1DHUif (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 16:38:35 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40429 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757841Ab1DHUie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 16:38:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Jhh60ywZhXF8VlLkH/1XIuuxZ9T/mQJLnD3oJAW2H3mD78bdGwaZKz6sSVso/Ftyhs
         0AdRuo3JRsMytnNZzgU4tZwG1YX62HlYwzfEF+/DgNIdGrzFf66FuZ9qiI5VzyuuBGXD
         tMpUSbiwlemXNxSWMxPGMJd2fjECmzyj/68tA=
Date: Fri, 8 Apr 2011 22:38:29 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Stephane Eranian <eranian@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michael Rubin <mrubin@google.com>, Ken Chen <kenchen@google.com>,
        linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [RFC] tracing: Adding cgroup aware tracing functionality
Message-ID: <20110408203827.GA26667@nowhere>
References: <BANLkTik_jtjWTsOueUzfdQXRx17OcgyDgA@mail.gmail.com>
 <20110407013349.GH1867@nowhere>
 <BANLkTinKsYqkEEUu98t+Gn9ciPn_bmsMFQ@mail.gmail.com>
 <20110407120608.GB1798@nowhere>
 <BANLkTim70Ef0gy+W+4h76PABn32wDRvTtw@mail.gmail.com>
 <20110407213208.GE1798@nowhere>
 <BANLkTimOvWYgiRc6cviB6iiUt9MH-Au1qw@mail.gmail.com>
 <20110408002812.GG1798@nowhere>
 <1302248268.21026.18.camel@frodo>
 <20110408190052.GC1967@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110408190052.GC1967@nowhere>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 08, 2011 at 09:00:56PM +0200, Frederic Weisbecker wrote:
> On Fri, Apr 08, 2011 at 03:37:48AM -0400, Steven Rostedt wrote:
> > I actually agree, as perf is more focused on per process (or group) than
> > ftrace. But that said, I guess the issue is also, if they have a simple
> > solution that is not invasive and suits their needs, what's the harm in
> > accepting it?
> 
> What about a kind of cgroup_of(path) operator that we can use on
> filters?
> 
> 	common_pid cgroup_of(path)
> or
> 	common_pid __cgroup_of__ path
> 
> That way you don't bloat the tracing fast path?

Note in this example, we would simply ignore the common_pid
value and assume that pid is the one of current. This economizes
a step to pid -> task resolution.
