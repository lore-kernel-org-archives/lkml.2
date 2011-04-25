Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758660Ab1DYRLL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 13:11:11 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:62322 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755070Ab1DYRLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 13:11:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=wEQujAeJhpQ4oYrel+OkZ/G/Aya7mwF4VZJRmA+vtyr/e+DFG1gTbDjg2IAM8xGaH+
         AQonfBvn6owyr/CTBcwPgwq1zC8j27cD5+5hautD4AphBne36ErK/P9itWX6BuSnhp6I
         G9A87C5jl2VFgfNuNfzUrvWdsEjHKaGkgWtbY=
MIME-Version: 1.0
In-Reply-To: <20110425170200.GA18363@redhat.com>
References: <20110418134421.GA15951@redhat.com>
	<20110418134501.GC15951@redhat.com>
	<20110425105229.GE17734@mtj.dyndns.org>
	<20110425152040.GA14934@redhat.com>
	<20110425161951.GA30828@mtj.dyndns.org>
	<20110425170200.GA18363@redhat.com>
Date: Mon, 25 Apr 2011 19:11:08 +0200
X-Google-Sender-Auth: s-5zrz0EsOHWBChFbsY1DNToVpo
Message-ID: <BANLkTi=oksQFYtyS1+RA5c_4E22yjik90g@mail.gmail.com>
Subject: Re: [PATCH v2 2/7] signal: retarget_shared_pending: consider
 shared/unblocked signals only
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikita V. Youshchenko" <nyoushchenko@mvista.com>,
        Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Mon, Apr 25, 2011 at 7:02 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> I did these changes against the Linus's tree to simplify the review, and
> because there are completely orthogonal to ptrace changes. Also, I like
> very much the fact -mm has users/testers.
>
> In fact, there are trivial conflicts with the ptrace branch. I think
> ptrace should be flushed first, so I'll rebase this "sigprocmask" branch
> when I address all comments.
>
> Or do you think I should merge these changes into ptrace branch? I'd like
> to keep them separate, but I am not sure if I should...

I don't know.  Signal/ptrace is closely coupled and you would be
reviewing/acking anyway, and linux-next has some test coverage (I
don't know how much but...), so I think it would be least painful to
route these together.  You can create separate topic branches for
signal and ptrace but I don't think that's required.  Anyways, yeah,
if there's no objection, I think it would be best to route these
together with the ptrace changes.  The conflicts wouldn't be trivial
and for a reason.

Thanks.

-- 
tejun
