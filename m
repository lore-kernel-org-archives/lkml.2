Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761989Ab0J2Urp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 16:47:45 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:37819 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761845Ab0J2Uro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 16:47:44 -0400
X-Authority-Analysis: v=1.1 cv=NFUeGz0loTdi/T6hXKngYYtckjed7x3pKvNOqmBBK18= c=1 sm=0 a=ygIiTo8ZIjQA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=aP4u4SVMGcFHZkWRAQEA:9 a=2dYd9ZXfFzrfZGm65Wdf1RISnWQA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 2/2] jump label: disable due to compiler bug
From: Steven Rostedt <rostedt@goodmis.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: David Daney <ddaney@caviumnetworks.com>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Ingo Molnar <mingo@elte.hu>, Jason Baron <jbaron@redhat.com>,
        rth@redhat.com, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com,
        avi@redhat.com, davem@davemloft.net, vgoyal@redhat.com,
        sam@ravnborg.org, tony@bakeyournoodle.com, dsd@laptop.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <4CCB2B7B.6020002@zytor.com>
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
	 <1288373582.29632.3.camel@gandalf.stny.rr.com> <4CCB2B7B.6020002@zytor.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 29 Oct 2010 16:47:40 -0400
Message-ID: <1288385260.29632.24.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-29 at 13:15 -0700, H. Peter Anvin wrote:

> I disagree with that assessment.
> 
> We know that if version >= 4.5.2 the problem has been fixed, and that
> for earlier versions we can't know if it's there, so just disable it for
> gcc < 4.5.2.  The fix might have been backported, but it's not a big
> deal if the users of backported compilers don't see the full benefit --
> it's only a problem during a limited time window anyway.
> 
> Admittedly it would be nice to have a header file or even a
> configuration file where the gcc version is tested and workarounds are
> centralized; then the backporters could put their own overrides in there.

Fine, but we can wait till 2.6.38 for that. For now we have a manual
config option. I'm not changing it until I have 4.5.2 in my distcc farm
and testing it out.

If things turn out fine, we can have > 4.5.2 || run check option. Or
just stick with 4.5.2. But we can debate this later (or at KS if you
want ;-)

-- Steve


