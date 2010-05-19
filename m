Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981Ab0ESQgq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 12:36:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:55480 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753576Ab0ESQgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 12:36:45 -0400
X-Authority-Analysis: v=1.1 cv=DB4JU8ZWelvwd5d0x20oybKyR86uyiSly0XbcMdosrc= c=1 sm=0 a=8EtQVlZUVNwA:10 a=hO-oPbc3tlwA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=hRW8RuVDvn31wFRIrZYA:9 a=4pe8B23pUEgkaVvZjkMgnxMoz30A:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: Unexpected splice "always copy" behavior observed
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Nick Piggin <npiggin@suse.de>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       mathieu.desnoyers@efficios.com, peterz@infradead.org,
       fweisbec@gmail.com, tardyp@gmail.com, mingo@elte.hu, acme@redhat.com,
       tzanussi@gmail.com, paulus@samba.org, linux-kernel@vger.kernel.org,
       arjan@infradead.org, ziga.mahkovec@gmail.com, davem@davemloft.net,
       linux-mm@kvack.org, akpm@linux-foundation.org,
       kosaki.motohiro@jp.fujitsu.com, cl@linux-foundation.org, tj@kernel.org,
       jens.axboe@oracle.com
In-Reply-To: <20100519155505.GD2516@laptop>
References: <20100518153440.GB7748@Krystal>
	 <1274197993.26328.755.camel@gandalf.stny.rr.com>
	 <1274199039.26328.758.camel@gandalf.stny.rr.com>
	 <alpine.LFD.2.00.1005180918300.4195@i5.linux-foundation.org>
	 <20100519063116.GR2516@laptop>
	 <alpine.LFD.2.00.1005190736370.23538@i5.linux-foundation.org>
	 <1274280968.26328.774.camel@gandalf.stny.rr.com>
	 <alpine.LFD.2.00.1005190758070.23538@i5.linux-foundation.org>
	 <E1OElGh-0005wc-I8@pomaz-ex.szeredi.hu>
	 <1274283942.26328.783.camel@gandalf.stny.rr.com>
	 <20100519155505.GD2516@laptop>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Wed, 19 May 2010 12:36:42 -0400
Message-ID: <1274287002.26328.808.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-20 at 01:55 +1000, Nick Piggin wrote:
> On Wed, May 19, 2010 at 11:45:42AM -0400, Steven Rostedt wrote:

> > If the "move only on append to file" is easy to implement, I would
> > really like to see that happen. The speed of splicing a disk image for a
> > virtual machine only impacts the patience of the user. The speed of
> > splicing tracing output, impacts how much you can trace without losing
> > events.
> 
> It's not "easy" to implement :) What's your ring buffer look like?
> Is it a normal user address which the kernel does copy_to_user()ish
> things into? Or a mmapped special driver?

Neither ;-)

> 
> If the latter, it get's even harder again. But either way if the
> source pages just have to be regenerated anyway (eg. via page fault
> on next access), then it might not even be worthwhile to do the
> splice move.

The ring buffer is written to by kernel events. To read it, the user can
either do a sys_read() and that is copied, or use splice. I do not
support mmap(), and if we were to do that, it would then not support
splice(). We have been talking about implementing both but with flags on
allocation of the ring buffer. You can either support mmap() or splice()
but not both with one instance of the ring buffer.

-- Steve





