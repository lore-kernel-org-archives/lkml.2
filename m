Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754425Ab1HSVNZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 17:13:25 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:57168 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754558Ab1HSVNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 17:13:21 -0400
X-Authority-Analysis: v=1.1 cv=Pm0sEXe2MdIPK/rOEC7hwDW84D/yDsPO3JtCzsVYOFU= c=1 sm=0 a=aKKvsJ_FXZsA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=s8pGmF8eWzNV9ccvty4A:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] x86: jump_label: arch_jump_label_text_poke_early: add
 missing __init
From: Steven Rostedt <rostedt@goodmis.org>
To: Kevin Winchester <kjwinchester@gmail.com>
Cc: jbaron@redhat.com, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <CAELBVzBBBc7HCPbE+orLD-tE1nBvGM2BBv+ietzoJJi-ubPdCQ@mail.gmail.com>
References: <1313539478-30303-1-git-send-email-kjwinchester@gmail.com>
	 <1313778007.15704.106.camel@gandalf.stny.rr.com>
	 <CAELBVzBBBc7HCPbE+orLD-tE1nBvGM2BBv+ietzoJJi-ubPdCQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 19 Aug 2011 17:13:16 -0400
Message-ID: <1313788396.15704.117.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-08-19 at 17:51 -0300, Kevin Winchester wrote:
> On 19 August 2011 15:20, Steven Rostedt <rostedt@goodmis.org> wrote:
> > On Tue, 2011-08-16 at 21:04 -0300, Kevin Winchester wrote:
> >> arch_jump_label_text_poke_early calls text_poke_early, which is
> >> an __init function.  Thus arch_jump_label_text_poke_early should
> >> be the same.
> >
> > but text_poke_early is not __init but instead __init_or_module. Your
> > patch just caused this bug:
> >
> 
> Sorry about that.  I have:
> 
> # CONFIG_MODULES is not set
> 
> which makes __init_or_module equivalent to __init for me.  Thus the
> patch was fine for my case, but I expect your modification is the
> right thing to do overall.

Um yeah.

I guess you're another one just like Peter Zijlstra ...

"Modules? Modules? We don't need no stinking modules!"

-- Steve


