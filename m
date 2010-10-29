Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934245Ab0J2SDK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 14:03:10 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:36722 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948Ab0J2SDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 14:03:09 -0400
X-Authority-Analysis: v=1.1 cv=kXGwZUU/u1JTMRv8Axk4W0omja+vfTT+sGlOkodD8F8= c=1 sm=0 a=ygIiTo8ZIjQA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=mDV3o1hIAAAA:8 a=Kxyjif0ptt18vN705yEA:9 a=ooMwxeiABZX_-QqhGRcA:7 a=ZbykD86UYitdZSVDSzwwqjdU4mEA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 2/2] jump label: disable due to compiler bug
From: Steven Rostedt <rostedt@goodmis.org>
To: David Daney <ddaney@caviumnetworks.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Ingo Molnar <mingo@elte.hu>, Jason Baron <jbaron@redhat.com>,
        rth@redhat.com, "H. Peter Anvin" <hpa@zytor.com>, tglx@linutronix.de,
        andi@firstfloor.org, roland@redhat.com,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com, avi@redhat.com,
        davem@davemloft.net, vgoyal@redhat.com, sam@ravnborg.org,
        tony@bakeyournoodle.com, dsd@laptop.org, linux-kernel@vger.kernel.org
In-Reply-To: <4CCB08EB.8070004@caviumnetworks.com>
References: <cover.1288212485.git.jbaron@redhat.com>
	 <2d1b1d5d2b3930e1acb063cefffbcb2faf049854.1288212486.git.jbaron@redhat.com>
	 <ce4ff595-f9d1-4c17-b68e-82739b07ad3e@email.android.com>
	 <20101028141757.GA2875@redhat.com> <4CC9C724.3020004@caviumnetworks.com>
	 <20101028201112.GA4792@redhat.com> <20101029063450.GE29463@elte.hu>
	 <1288354687.18238.433.camel@gandalf.stny.rr.com>
	 <20101029122230.GA25663@elte.hu>
	 <1288356418.18238.454.camel@gandalf.stny.rr.com>
	 <20101029133524.GA23916@Krystal>
	 <1288369108.29632.1.camel@gandalf.stny.rr.com>
	 <4CCB01D1.2050004@caviumnetworks.com>
	 <1288373582.29632.3.camel@gandalf.stny.rr.com>
	 <4CCB08EB.8070004@caviumnetworks.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 29 Oct 2010 14:03:06 -0400
Message-ID: <1288375386.29632.12.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-29 at 10:48 -0700, David Daney wrote:

> The test case is in the GCC bug report, and is quite small:
> 
> http://gcc.gnu.org/bugzilla/show_bug.cgi?id=46226
> 
> Perhaps it could be integrated with the current checks for the presence 
> of 'asm goto'

Yeah, but it's too late in the merge window to do this much hackery.
Lets slow down a bit and do it right. This test case shows that gcc is
broken, but do we really know if it wont produce a false positive
(saying gcc works when it does not)?

Adding a manual option for this release is the right thing to do. This
will let things settle down. Users that want it can enable it
themselves, and then they choose to be our testers ;-)

Once we have a better idea on things and have a test case we know shows
gcc works when it really does work and that it fails when it really does
fail, then we can add that in. Perhaps for 38.

-- Steve


