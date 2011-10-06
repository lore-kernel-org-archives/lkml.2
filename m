Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935908Ab1JFWKp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 18:10:45 -0400
Received: from claw.goop.org ([74.207.240.146]:34606 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935612Ab1JFWKn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 18:10:43 -0400
Message-ID: <4E8E275F.6010801@goop.org>
Date: Thu, 06 Oct 2011 15:10:39 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Richard Henderson <rth@redhat.com>, Jason Baron <jbaron@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "David S. Miller" <davem@davemloft.net>,
        David Daney <david.daney@cavium.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Jan Glauber <jang@linux.vnet.ibm.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        peterz@infradead.org
Subject: Re: [PATCH RFC V2 3/5] jump_label: if a key has already been initialized,
 don't nop it out
References: <cover.1317506051.git.jeremy.fitzhardinge@citrix.com>    <477dead9647029012f93c651f2892ed0e86b89e7.1317506051.git.jeremy.fitzhardinge@citrix.com>    <20111003150205.GB2462@redhat.com> <4E89E28C.7010700@goop.org>    <20111004141011.GA2520@redhat.com> <4E8B3489.60902@zytor.com>    <4E8CF348.4080405@goop.org> <4E8CF385.2080804@zytor.com>    <4E8DEB19.1050509@goop.org> <20111006181055.GA2505@redhat.com>   <1317925615.4729.14.camel@gandalf.stny.rr.com>   <4E8DF870.6010000@redhat.com>  <1317929321.4729.17.camel@gandalf.stny.rr.com> <4E8E20CD.5030207@goop.org> <1317938775.4729.29.camel@gandalf.stny.rr.com>
In-Reply-To: <1317938775.4729.29.camel@gandalf.stny.rr.com>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/2011 03:06 PM, Steven Rostedt wrote:
> But it only speeds up the tracing case. The non-tracing case is a nop
> and 5bytes is 5bytes regardless.
>
> Did you see a 5% speed up while tracing was happening? How did you do
> your test. I find a 5 byte compared to a 2 byte jump being negligible
> with the rest of the overhead of tracing, but I could be wrong.

You're right, this was a completely artificial microbenchmark.  In
practice the improvement would be a much smaller effect.

But bear in mind, I'm not using jump-label for tracing.  While its
important for the "disabled" state to be quick, performance of the
"enabled" state is also important.

Thanks,
    J
