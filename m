Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933264Ab1JGWDv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 18:03:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59597 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755662Ab1JGWDt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 18:03:49 -0400
Message-ID: <4E8F772D.20408@zytor.com>
Date: Fri, 07 Oct 2011 15:03:25 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Jason Baron <jbaron@redhat.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
        Richard Henderson <rth@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        David Daney <david.daney@cavium.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Jan Glauber <jang@linux.vnet.ibm.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        peterz@infradead.org
Subject: Re: [PATCH][RFC] jump_labels/x86: Use either 5 byte or 2 byte jumps
References: <4E8CF385.2080804@zytor.com> <4E8DEB19.1050509@goop.org>   <20111006181055.GA2505@redhat.com>   <1317925615.4729.14.camel@gandalf.stny.rr.com>   <4E8DF870.6010000@redhat.com>   <1317929321.4729.17.camel@gandalf.stny.rr.com> <4E8E20CD.5030207@goop.org>   <1317938775.4729.29.camel@gandalf.stny.rr.com> <4E8E275F.6010801@goop.org>   <1318007374.4729.58.camel@gandalf.stny.rr.com>   <20111007185214.GD2978@redhat.com>  <1318015311.4729.69.camel@gandalf.stny.rr.com> <4E8F73A3.5080904@zytor.com> <1318024853.4729.88.camel@gandalf.stny.rr.com>
In-Reply-To: <1318024853.4729.88.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2011 03:00 PM, Steven Rostedt wrote:
>
> Ouch, quite shaken by k.org? I guess I should have substituted go blind
> with being hacked.
>

Well, yes, but I would have said exactly the same thing before.

> The thing is, it may be as simple as an out of tree module screwing up
> the jump table. Or worse, gcc not doing things that we did not expect.
> If this is the case, jump labels can be disabled from modifying code.
>
> But if we just want to do the BUG() case, this will be a big hammer to
> the code and we just prevent any further progress until the issue is
> addressed. Which may be tell people to disable jump labels in their
> code, or use a different compiler.

That is EXACTLY what should happen.  Something is wrong to the point of 
the kernel is *known* to be executing the wrong code.  That is an 
extremely serious condition and should be treated as such.

If you want, you could have a debug option to demote this to WARN, but I 
really don't want to see it by default.

	-hpa
