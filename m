Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932828Ab0JFPqi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 11:46:38 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:41038 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932489Ab0JFPqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 11:46:20 -0400
X-Authority-Analysis: v=1.1 cv=iGF3DqghDyT/uy4mV2LvOKNXCATMSjL+tOl9cucoGVk= c=1 sm=0 a=-tYYMGhhkdgA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=C05qvj7hLEYE1rfiw6wA:9 a=fmCWDqTv9IMF4S37-9rBrX4wNgAA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 1/5] jump label: fix module __init section race
From: Steven Rostedt <rostedt@goodmis.org>
To: Jason Baron <jbaron@redhat.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>, mingo@elte.hu,
        mathieu.desnoyers@polymtl.ca, hpa@zytor.com, tglx@linutronix.de,
        andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        vgoyal@redhat.com, sam@ravnborg.org, tony@bakeyournoodle.com,
        ddaney@caviumnetworks.com, linux-kernel@vger.kernel.org,
        2nddept-manager@sdl.hitachi.co.jp
In-Reply-To: <20101006154140.GA2941@redhat.com>
References: <cover.1285965957.git.jbaron@redhat.com>
	 <c6f037b7598777668025ceedd9294212fd95fa34.1285965957.git.jbaron@redhat.com>
	 <4CA6F44A.1000907@hitachi.com>
	 <1286370051.6750.180.camel@gandalf.stny.rr.com>
	 <20101006154140.GA2941@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 06 Oct 2010 11:46:14 -0400
Message-ID: <1286379974.6661.0.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-10-06 at 11:41 -0400, Jason Baron wrote:
> On Wed, Oct 06, 2010 at 09:00:50AM -0400, Steven Rostedt wrote:
> > On Sat, 2010-10-02 at 17:58 +0900, Masami Hiramatsu wrote:
> > 
> > > > +static void remove_module_init(struct module *mod)
> > > 
> > > Hi Jason,
> > > 
> > > Just a comment, I prefer remove_jump_label_module_init() than this name,
> > > because remove_module_init is too general.
> > 
> > This is probably not too big of a deal since it is static, but the name
> > change may make it easier for etags and ctags users.
> > 
> > Jason, are you OK if I pull in this patch and make the change myself?
> > 
> > -- Steve
> > 
> 
> fine with me. I had a more specific function name and then shortened it
> because it seemed too long, either way is fine with me.
> 

Maybe call it jl_remove_module_init()?  For static functions, I usually
use abbreviations. As long as it isn't too confusing.

-- Steve


