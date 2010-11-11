Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757627Ab0KKBF5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 20:05:57 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:61112 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757427Ab0KKBF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 20:05:56 -0500
X-Authority-Analysis: v=1.1 cv=kXGwZUU/u1JTMRv8Axk4W0omja+vfTT+sGlOkodD8F8= c=1 sm=0 a=UWg-Qlbn-4MA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=taGs_qngAAAA:8 a=CvOBL4saVFUMqDW05vwA:9 a=jKRIg8DYmaLSi5vqNGMA:7 a=7VNV9A5D4tkJthJ1nejdtkVCHFsA:4 a=PUjeQqilurYA:10 a=n7Cch7CHiCMA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] Delegate unknown module parameters to interested
 parties
From: Steven Rostedt <rostedt@goodmis.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com, mingo@redhat.com
In-Reply-To: <201011111105.09255.rusty@rustcorp.com.au>
References: <0d30dc$k4dmjb@orsmga001.jf.intel.com>
	 <201011101621.28946.rusty@rustcorp.com.au>
	 <1289397360.12418.119.camel@gandalf.stny.rr.com>
	 <201011111105.09255.rusty@rustcorp.com.au>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 10 Nov 2010 20:05:53 -0500
Message-ID: <1289437553.12418.217.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-11 at 11:05 +1030, Rusty Russell wrote:
>  
> > Yep, this way we could even enable tracepoints that are in the init
> > section.
> 
> *Exactly* how would it be used though?  Please provide a synopsis for
> someone unaware of what tracing does these days?

Well, if you have a tracepoint in the module, and you want to enable it
as soon as the module is loaded, it would be nice to have that ability.

> 
> Because we could compile an extra module_parm() into the module using
> modpost, for example, at a cost of an extra 16/32 bytes per module.
> 
> > But, personally, I like the generic addition. Perhaps others will hook into
> > it without fear of having to hack the module code, which can be quite
> > intimidating to some.
> 
> We *all* want to build infrastructure; when other coders are forced to use
> it we rise up the kernel dominance hierarchy. Ook ook!  (Every Unix app has
> its own config language for the same reason: the author distils the mental
> sweat of the users into some kind of Elixer of Coder Hubris).

Note, I would have just done the hack, but I liked Chris's generic
approach. /me ook ooks Chris!


> 
> Yet abstractions obfuscate: let's resist our primal urges to add another
> speed hump on the lengthening road to kernel expertese.

Adding a generic way to do global module options is a primal urge?

> 
> And this one's classicly easy: in single uses cases we always get the
> infrastructure wrong for future users anyway, so let's not do it until
> we have more than one user.

OK, we can add the hack for now. But perhaps have an archive of this
patch (maybe even sneak a link to it in the change log).

Hmm, we can just add:

LKML-Reference: <1289311867-10096-1-git-send-email-chris@chris-wilson.co.uk>


-- Steve


