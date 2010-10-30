Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958Ab0J3OA0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 10:00:26 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:60603 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142Ab0J3OAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 10:00:24 -0400
X-Authority-Analysis: v=1.1 cv=kXGwZUU/u1JTMRv8Axk4W0omja+vfTT+sGlOkodD8F8= c=1 sm=0 a=ygIiTo8ZIjQA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=xXoaG0mu6ZuicIMNSmoA:9 a=igzBPwQLflvVfqlNjD3qs1qxNWgA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 2/2] jump label: disable due to compiler bug
From: Steven Rostedt <rostedt@goodmis.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, David Daney <ddaney@caviumnetworks.com>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Ingo Molnar <mingo@elte.hu>, Jason Baron <jbaron@redhat.com>,
        rth@redhat.com, tglx@linutronix.de, roland@redhat.com,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com, avi@redhat.com,
        davem@davemloft.net, vgoyal@redhat.com, sam@ravnborg.org,
        tony@bakeyournoodle.com, dsd@laptop.org, linux-kernel@vger.kernel.org
In-Reply-To: <20101030074749.GB1721@basil.fritz.box>
References: <20101029063450.GE29463@elte.hu>
	 <1288354687.18238.433.camel@gandalf.stny.rr.com>
	 <20101029122230.GA25663@elte.hu>
	 <1288356418.18238.454.camel@gandalf.stny.rr.com>
	 <20101029133524.GA23916@Krystal>
	 <1288369108.29632.1.camel@gandalf.stny.rr.com>
	 <4CCB01D1.2050004@caviumnetworks.com>
	 <1288373582.29632.3.camel@gandalf.stny.rr.com> <4CCB2B7B.6020002@zytor.com>
	 <1288385260.29632.24.camel@gandalf.stny.rr.com>
	 <20101030074749.GB1721@basil.fritz.box>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Sat, 30 Oct 2010 10:00:19 -0400
Message-ID: <1288447219.29632.53.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-10-30 at 09:47 +0200, Andi Kleen wrote:
> > Fine, but we can wait till 2.6.38 for that. For now we have a manual
> > config option. I'm not changing it until I have 4.5.2 in my distcc farm
> > and testing it out.
> 
> It's probably obvious, but a manual config option still breaks
> the allyes|modconfig crowd.

Enabling the config only adds the workaround which causes the kernel to
be a bit bigger (adds -maccumulate-outgoing-args) and does not break the
kernel. When we have the test, we wont need to add this workaround if
the test passes.

This is still a new feature, and until we are sure its safe, we should
have it as an option.

There's lots of things in the kernel that will break with
all{yes,mod}config. I know, because I keep hitting them with my
randconfig tests.


-- Steve


