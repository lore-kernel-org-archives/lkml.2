Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752244Ab1AERql (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 12:46:41 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:40121 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309Ab1AERqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 12:46:39 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=mIBq1ZzCEX8A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=8Ipz_qBANfp3AE-v800A:9 a=zN1l6uoZCkBcIX2Fq1WPesXacNIA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 2/2] jump label: introduce static_branch()
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jason Baron <jbaron@redhat.com>, peterz@infradead.org,
        mathieu.desnoyers@polymtl.ca, hpa@zytor.com, mingo@elte.hu,
        tglx@linutronix.de, andi@firstfloor.org, roland@redhat.com,
        rth@redhat.com, masami.hiramatsu.pt@hitachi.com, avi@redhat.com,
        davem@davemloft.net, sam@ravnborg.org, ddaney@caviumnetworks.com,
        michael@ellerman.id.au, linux-kernel@vger.kernel.org
In-Reply-To: <20110105171516.GB1692@nowhere>
References: <cover.1294239591.git.jbaron@redhat.com>
	 <2d8c38bd7ca93e162aedb8e7acfc8bdb96d85de2.1294239591.git.jbaron@redhat.com>
	 <20110105171516.GB1692@nowhere>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 05 Jan 2011 12:46:36 -0500
Message-ID: <1294249596.26623.38.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-05 at 18:15 +0100, Frederic Weisbecker wrote:
> On Wed, Jan 05, 2011 at 10:43:12AM -0500, Jason Baron wrote:
> > diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
> > index 152f7de..0ad9c2e 100644
> > --- a/include/linux/jump_label.h
> > +++ b/include/linux/jump_label.h
> > @@ -22,6 +22,11 @@ struct module;
> >  
> >  #ifdef HAVE_JUMP_LABEL
> >  
> > +static __always_inline bool static_branch(struct jump_label_key *key)
> > +{
> > +	return __static_branch(key);
> 
> Not very important, but __static_branch() would be more self-explained
> if it was called arch_static_branch().

I disagree, I think it is very important ;-)

Yes, the kernel has been moving to adding "arch_" to functions that are
implemented dependently by different archs. Please change this to
"arch_static_branch()".

Thanks,

-- Steve


