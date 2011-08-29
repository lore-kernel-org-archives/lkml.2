Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690Ab1H2SmG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 14:42:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12199 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754323Ab1H2SmC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 14:42:02 -0400
Date: Mon, 29 Aug 2011 20:37:43 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: rientjes@google.com, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, roland@hack.frob.com, tj@kernel.org,
        dvlasenk@redhat.com, matt.fleming@linux.intel.com,
        linux-kernel@vger.kernel.org, avagin@openvz.org, fhrbata@redhat.com,
        yinghan@google.com
Subject: Re: mm->oom_disable_count is broken
Message-ID: <20110829183743.GA15216@redhat.com>
References: <20110727163159.GA23785@redhat.com> <20110727163610.GJ23793@redhat.com> <20110727175624.GA3950@redhat.com> <20110728154324.GA22864@redhat.com> <alpine.DEB.2.00.1107281341060.16093@chino.kir.corp.google.com> <20110729141431.GA3501@redhat.com> <20110730143426.GA6061@redhat.com> <20110730152238.GA17424@redhat.com> <4E369372.80105@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E369372.80105@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01, KOSAKI Motohiro wrote:
>
> > And this reminds me. mm->oom_disable_count looks absolutely broken.
> > IIRC, I already complained but nobody replied.
> >
> > [...snip...]
>
> IIRC, I did pointed out this issue. But nobody replied.
> I think ->oom_disable_count is currently broken. but now I have no time to
> audit this stuff. So, I'd suggest to revert this code if nobody don't fix it.

I tend to agree, of course we can fix oom_disable_count but I don't
really understand why do we want it.

David, could you please explain? I mean, CLONE_VM (without CLONE_THREAD)
is not that common, I think. Does this counter really help in practice?


And. personally I dislike it because ->oom_disable_count is just another
proof that ->oom_score_adj should be in ->mm, not per-process. IIRC,
you already explained me why we can't do this, but - sorry - I forgot.
May be something with vfork... Could you explain this again?

Oleg.

