Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753769Ab0ESU7T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 16:59:19 -0400
Received: from n64.bullet.mail.sp1.yahoo.com ([98.136.44.189]:33359 "HELO
	n64.bullet.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750943Ab0ESU7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 16:59:17 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 740573.80074.bm@omp103.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type;
  b=4rhi3Ntg3d5TLRrlSwTMJB2LrZ0nv/YnNjrMYzLrdH5kclwpB7w4fjmMQePZzkOHVchS2Un5D4BlBX7yH4daHBO8kg2PAURPjOET+mWaz55rbtYfWrmcS791hxO4A40XSEuW1Fv2DjTg+Hn9DIuMwPfP954djNp+EkcEi03kIwE=;
Message-ID: <641426.722.qm@web114309.mail.gq1.yahoo.com>
X-YMail-OSG: tKB6L5gVM1mlfbpqxXwM9QLKMNJ.rMLRw0E5PfcLLoX1rCb
 JwbZTh5Z63rMswshoIzCGrSXBevQkSzkOKUTOa0YBH0g8NBAnRVDp0XqO6B4
 IdhHZ0Bt.E49AUUIj.JohflwHJe658TSqG4Qe3rg3dniZolgKBHdwbPz9y0x
 JXHzMBxoj5i5gpTLEYhW_LVwoRMQg65UFy9tFpUe_p3hlRTpoXC1AaG9.1DK
 xMeqkY1z471VMPRQfPKYqQ72yf1OXCKBi03tFQc4CA5Gj6EU4J2S6Ez94ZtD
 lhdm6KUw9j1K.t4nHyYqVTNSERrR8cniyJMezCja_JM7KKTlXbB4WKw--
X-Mailer: YahooMailClassic/11.0.8 YahooMailWebService/0.8.103.269680
Date: Wed, 19 May 2010 13:59:16 -0700 (PDT)
From: Rick Sherm <rick.sherm@yahoo.com>
Subject: Re: Unexpected splice "always copy" behavior observed
To: Steven Rostedt <rostedt@goodmis.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, arjan@infradead.org, linux-mm@kvack.org
In-Reply-To: <alpine.LFD.2.00.1005190758070.23538@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for deleting CC'd addresses. yahoo was whining...

--- On Wed, 5/19/10, Linus Torvalds <torvalds@linux-foundation.org> wrote:

> From: Linus Torvalds <torvalds@linux-foundation.org>
> Subject: Re: Unexpected splice "always copy" behavior observed
> To: "Steven Rostedt" <rostedt@goodmis.org>
> Cc: "Nick Piggin" <npiggin@suse.de>, "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>, "Peter Zijlstra" <peterz@infradead.org>, "Frederic Weisbecker" <fweisbec@gmail.com>, "Pierre Tardy" <tardyp@gmail.com>, "Ingo Molnar" <mingo@elte.hu>, "Arnaldo Carvalho de Melo" <acme@redhat.com>, "Tom Zanussi" <tzanussi@gmail.com>, "Paul Mackerras" <paulus@samba.org>, linux-kernel@vger.kernel.org, arjan@infradead.org, ziga.mahkovec@gmail.com, "davem" <davem@davemloft.net>, linux-mm@kvack.org, "Andrew Morton" <akpm@linux-foundation.org>, "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>, "Christoph Lameter" <cl@linux-foundation.org>, "Tejun Heo" <tj@kernel.org>, "Jens Axboe" <jens.axboe@oracle.com>
> Date: Wednesday, May 19, 2010, 2:59 PM
> 
> 
> On Wed, 19 May 2010, Steven Rostedt wrote:
> 
> > On Wed, 2010-05-19 at 07:39 -0700, Linus Torvalds
> wrote:
> > 
> > > The real limitation is likely always going to be
> the fact that it has to 
> > > be page-aligned and a full page. For a lot of
> splice inputs, that simply 
> > > won't be the case, and you'll end up copying for
> alignment reasons anyway.
> > 
> > That's understandable. For the use cases of splice I
> use, I work to make
> > it page aligned and full pages. Anyone else using
> splice for
> > optimizations, should do the same. It only makes
> sense.
> > 
> > The end of buffer may not be a full page, but then
> it's the end anyway,
> > and I'm not as interested in the speed.
> 
> Btw, since you apparently have a real case - is the "splice
> to file" 
> always just an append? IOW, if I'm not right in assuming
> that the only 
> sane thing people would reasonable care about is "append to
> a file", then 
> holler now.
> 

I've a similar 'append' use case:
http://marc.info/?l=linux-kernel&m=127143736527459&w=4

My mmapped buffers are pinned down.


      

