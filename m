Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755693Ab1H3QVo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 12:21:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39260 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752453Ab1H3QVn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 12:21:43 -0400
Date: Tue, 30 Aug 2011 18:17:43 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: David Rientjes <rientjes@google.com>
Cc: Ying Han <yinghan@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>, roland@hack.frob.com,
        tj@kernel.org, dvlasenk@redhat.com, matt.fleming@linux.intel.com,
        linux-kernel@vger.kernel.org, avagin@openvz.org, fhrbata@redhat.com
Subject: Re: mm->oom_disable_count is broken
Message-ID: <20110830161743.GC22754@redhat.com>
References: <20110727163610.GJ23793@redhat.com> <20110727175624.GA3950@redhat.com> <20110728154324.GA22864@redhat.com> <alpine.DEB.2.00.1107281341060.16093@chino.kir.corp.google.com> <20110729141431.GA3501@redhat.com> <20110730143426.GA6061@redhat.com> <20110730152238.GA17424@redhat.com> <4E369372.80105@jp.fujitsu.com> <20110829183743.GA15216@redhat.com> <alpine.DEB.2.00.1108291611070.32495@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1108291611070.32495@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29, David Rientjes wrote:
>
> On Mon, 29 Aug 2011, Oleg Nesterov wrote:
>
> > And. personally I dislike it because ->oom_disable_count is just another
> > proof that ->oom_score_adj should be in ->mm, not per-process. IIRC,
> > you already explained me why we can't do this, but - sorry - I forgot.
> > May be something with vfork... Could you explain this again?
>
> I actually really wanted oom_score_adj to be in the ->mm, it would
> simplify a lot of the code :)  The problem was the inheritance property:
> we expect a job scheduler that is OOM_DISABLE to be able to vfork, change
> the oom_score_adj of the child, and then exec so that it is not oom
> disabled before starting to allocate memory.

Ah, I see. Thanks.

And yes, now I recall this is what you already explained ;)

Damn.

Oleg.

