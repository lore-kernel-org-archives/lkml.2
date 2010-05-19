Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384Ab0ESPpt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 11:45:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:51432 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565Ab0ESPpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 11:45:47 -0400
X-Authority-Analysis: v=1.1 cv=DB4JU8ZWelvwd5d0x20oybKyR86uyiSly0XbcMdosrc= c=1 sm=0 a=8EtQVlZUVNwA:10 a=hO-oPbc3tlwA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=n60Vwz4mJqZaziYBhsAA:9 a=-5B0SYW93aXBYXS8RHWtPZ6HBYIA:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: Unexpected splice "always copy" behavior observed
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, npiggin@suse.de,
       mathieu.desnoyers@efficios.com, peterz@infradead.org,
       fweisbec@gmail.com, tardyp@gmail.com, mingo@elte.hu, acme@redhat.com,
       tzanussi@gmail.com, paulus@samba.org, linux-kernel@vger.kernel.org,
       arjan@infradead.org, ziga.mahkovec@gmail.com, davem@davemloft.net,
       linux-mm@kvack.org, akpm@linux-foundation.org,
       kosaki.motohiro@jp.fujitsu.com, cl@linux-foundation.org, tj@kernel.org,
       jens.axboe@oracle.com
In-Reply-To: <E1OElGh-0005wc-I8@pomaz-ex.szeredi.hu>
References: <20100518153440.GB7748@Krystal>
	 <1274197993.26328.755.camel@gandalf.stny.rr.com>
	 <1274199039.26328.758.camel@gandalf.stny.rr.com>
	 <alpine.LFD.2.00.1005180918300.4195@i5.linux-foundation.org>
	 <20100519063116.GR2516@laptop>
	 <alpine.LFD.2.00.1005190736370.23538@i5.linux-foundation.org>
	 <1274280968.26328.774.camel@gandalf.stny.rr.com>
	 <alpine.LFD.2.00.1005190758070.23538@i5.linux-foundation.org>
	 <E1OElGh-0005wc-I8@pomaz-ex.szeredi.hu>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Wed, 19 May 2010 11:45:42 -0400
Message-ID: <1274283942.26328.783.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-19 at 17:33 +0200, Miklos Szeredi wrote:
> On Wed, 19 May 2010, Linus Torvalds wrote:
> > Btw, since you apparently have a real case - is the "splice to file" 
> > always just an append? IOW, if I'm not right in assuming that the only 
> > sane thing people would reasonable care about is "append to a file", then 
> > holler now.
> 
> Virtual machines might reasonably need this for splicing to a disk
> image.

This comes down to balancing speed and complexity. Perhaps a copy is
fine in this case.

I'm concerned about high speed tracing, where we are always just taking
pages from the trace ring buffer and appending them to a file or sending
them off to the network. The slower this is, the more likely you will
lose events.

If the "move only on append to file" is easy to implement, I would
really like to see that happen. The speed of splicing a disk image for a
virtual machine only impacts the patience of the user. The speed of
splicing tracing output, impacts how much you can trace without losing
events.

-- Steve


