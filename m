Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761416Ab0J2MSO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 08:18:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:62403 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890Ab0J2MSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 08:18:12 -0400
X-Authority-Analysis: v=1.1 cv=6ptpMFIBtxRk0xdOb6IhJTbTLVRlKjWFes7R4SsWCrA= c=1 sm=0 a=ygIiTo8ZIjQA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=yd-9aiblakt9m_ewWcMA:9 a=6JAf1Z1vT588NWI_XOci7J2jECsA:4 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 2/2] jump label: disable due to compiler bug
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jason Baron <jbaron@redhat.com>, David Daney <ddaney@caviumnetworks.com>,
        rth@redhat.com, "H. Peter Anvin" <hpa@zytor.com>,
        mathieu.desnoyers@polymtl.ca, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com,
        avi@redhat.com, davem@davemloft.net, vgoyal@redhat.com,
        sam@ravnborg.org, tony@bakeyournoodle.com, dsd@laptop.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20101029063450.GE29463@elte.hu>
References: <cover.1288212485.git.jbaron@redhat.com>
	 <2d1b1d5d2b3930e1acb063cefffbcb2faf049854.1288212486.git.jbaron@redhat.com>
	 <ce4ff595-f9d1-4c17-b68e-82739b07ad3e@email.android.com>
	 <20101028141757.GA2875@redhat.com> <4CC9C724.3020004@caviumnetworks.com>
	 <20101028201112.GA4792@redhat.com>  <20101029063450.GE29463@elte.hu>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 29 Oct 2010 08:18:07 -0400
Message-ID: <1288354687.18238.433.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-29 at 08:34 +0200, Ingo Molnar wrote:
> * Jason Baron <jbaron@redhat.com> wrote:
> 
> > Thus, I'm going to propose a patch, which makes jump label conditional on x86_64 
> > for now [...]
> 
> No, we dont do 64-bit only features really.
> 
> > [...] (adding -maccumulate-outgoing-args to x86 increases the text size, so I'm 
> > not proposing adding the flag there).
> 
> Please make jump labels configurable instead. (dependent on EMBEDDED)

Do you mean to have it dependent on !EMBEDDED, or perhaps 
!CC_OPTIMIZE_FOR_SIZE ?

I can see people making a big stink about adding back a gcc option that
makes the kernel bigger.

-- Steve

> 
> Also, could you please send the fix to me ASAP? We dont need confirmation and 
> re-confirmation and testing, as this thing is crashing on me several times every 
> single day ...
> 
> I also know that 64-bit never crashed this way, nor did the 32-bit kernel with 
> function tracer enabled - so -maccumulate-outgoing-args will likely fix it.
> 
> Lets get the ball rolling so we can get it to Linus today ...



