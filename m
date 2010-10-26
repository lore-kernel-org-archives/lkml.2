Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759702Ab0JZPVi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 11:21:38 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:43631 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756235Ab0JZPVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 11:21:37 -0400
X-Authority-Analysis: v=1.1 cv=NFUeGz0loTdi/T6hXKngYYtckjed7x3pKvNOqmBBK18= c=1 sm=0 a=3FBkpXGU7PEA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=K4N9FRVqOz536K8D6GQA:9 a=mvmUoqG3u8cUQL2404iDQd8F1rYA:4 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [tip:perf/urgent] tracing: Prevent unloadable modules from
 using trace_bprintk()
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        rusty@rustcorp.com.au, fweisbec@gmail.com, srostedt@redhat.com,
        tglx@linutronix.de, Li Zefan <lizf@cn.fujitsu.com>
In-Reply-To: <AANLkTin7Daj=HnWXstuWxymjuBfF9axfKZWvei_EKefw@mail.gmail.com>
References: <tip-c3b87c579e5df72a59fe97d77d4c3791dc8154ec@git.kernel.org>
	 <AANLkTin7Daj=HnWXstuWxymjuBfF9axfKZWvei_EKefw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 26 Oct 2010 11:21:33 -0400
Message-ID: <1288106493.18238.82.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-26 at 08:06 -0700, Linus Torvalds wrote:
> On Tue, Oct 26, 2010 at 3:21 AM, tip-bot for Steven Rostedt
> <srostedt@redhat.com> wrote:
> >
> > tracing: Prevent unloadable modules from using trace_bprintk()
> 
> I still don't think this patch makes sense.
> 
> Some of it is just totally insane. The CONFIG_MODVERSIONS check is
> just crazy. MODVERSIONS has nothing what-so-ever to do with the issue.
> 
> Don't do this. It's total voodoo programming.

Yeah, I think Ingo pulled this by mistake (I asked him to do some pull
requests, and this was probably mixed in the real ones). I purposely
pulled it out of my other pull requests so we could debate it more.

The right answer is what Li Zefan said and that is to simply flush the
ring buffer on module removal if the module uses a trace_bprintk(). We
already do this for tracepoints.

-- Steve


