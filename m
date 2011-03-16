Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753232Ab1CPPGa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 11:06:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:45956 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752446Ab1CPPGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 11:06:23 -0400
X-Authority-Analysis: v=1.1 cv=qyUSAyc82z9xLljZQc9ErY9Tl2GSEfqK/XYZS35I9d8= c=1 sm=0 a=Upx0gwFd4kMA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=d1NOsjx2Xrt1CVOz9scA:9 a=SIN_Lqn2qpi7XKQQE0kA:7 a=-kzIhit1ZWzR29AU4pwPG7lBXe8A:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: jump label: mips alignment required?
From: Steven Rostedt <rostedt@goodmis.org>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Jason Baron <jbaron@redhat.com>, ddaney@caviumnetworks.com,
        LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        "David S. Miller" <davem@davemloft.net>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
In-Reply-To: <20110316145739.GA18787@linux-mips.org>
References: <20110314150219.GA2568@redhat.com>
	 <20110316145739.GA18787@linux-mips.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 16 Mar 2011 11:06:20 -0400
Message-ID: <1300287980.16880.37.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-16 at 15:57 +0100, Ralf Baechle wrote:
> On Mon, Mar 14, 2011 at 11:02:20AM -0400, Jason Baron wrote:
> 
> > (off-list)

Added LKML back, as well as others. There was really no reason to take
this off list.

> 
> Adding Steve Rosted again.
> 
> > After last weeks discussion, I'm going to be re-posting the jump label
> > series. I'm adding the following to the x86 code. If you want to add
> > something similar for mips, I can include it in my posting (as coming
> > from you).
> > 
> > thanks,
> > 
> > -Jason
> > 
> > diff --git a/arch/x86/include/asm/jump_label.h b/arch/x86/include/asm/jump_label.h
> > index f217cee..a32b18c 100644
> > --- a/arch/x86/include/asm/jump_label.h
> > +++ b/arch/x86/include/asm/jump_label.h
> > @@ -16,6 +16,7 @@ static __always_inline bool arch_static_branch(struct jump_label_key *key)
> >  	asm goto("1:"
> >  		JUMP_LABEL_INITIAL_NOP
> >  		".pushsection __jump_table,  \"aw\" \n\t"
> > +		_ASM_ALIGN "\n\t"
> >  		_ASM_PTR "1b, %l[l_yes], %c0 \n\t"
> >  		".popsection \n\t"
> >  		: :  "i" (key) : : l_yes);
> 
> I don't think we'll need something like this on MIPS.  Gas is smart enough to
> set the __jump_table's section automatically to 64-bit if _ASM_PTR is emitting
> 64-bit pointers.  So no alignment magic needed nor do I think x86 would need this
> to work correct on both i386 and x86_64.

Yeah, I still have strong doubts that the linker would add holes into a
word aligned section. Such a linker IMNSHO would be broken. Why waste
space?

OK, Jason, I think it's fine if you repost the patches. You can keep the
alignment in x86_64 just to be paranoid^Wsafe.

-- Steve


