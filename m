Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532Ab1I0RQ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 13:16:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39058 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751572Ab1I0RQZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 13:16:25 -0400
Date: Tue, 27 Sep 2011 19:12:19 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Serge Hallyn <serge.hallyn@canonical.com>
Cc: lkml <linux-kernel@vger.kernel.org>, richard@nod.at,
        Andrew Morton <akpm@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, Tejun Heo <tj@kernel.org>,
        serge@hallyn.com
Subject: Re: [PATCH] user namespace: make signal.c respect user namespaces
Message-ID: <20110927171219.GA15981@redhat.com>
References: <20110921175357.GA25590@redhat.com> <20110923163113.GA3820@sergelap> <20110923173656.GA5233@redhat.com> <20110923212025.GA21330@sergelap> <20110924163709.GA6776@redhat.com> <20110925201723.GA5288@sergelap> <20110926160619.GA13736@redhat.com> <20110927142833.GA4876@peqn> <20110927143835.GA8450@redhat.com> <20110927152711.GB2952@peqn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110927152711.GB2952@peqn>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/27, Serge Hallyn wrote:
>
> Quoting Oleg Nesterov (oleg@redhat.com):
> >
> > ptrace_signal() simply fills *info with some "random" data before
> > processing the signal. It doesn't pass this info to send_signal().
>
> Oh, well not always, but it does in the case where
> 	sigismember(&current->blocked, signr);

Ah, thanks, now I see what you mean.

> But I suppose that's not a common path :)

Yes. And, in this case the task "sends" a signal to itself. This means,
whatever we do with  __send_signal() it shouldn't change info->si_uid.
(At least with fixup_uid() I suggested).

I am glad we finally understand each other, most probably I didn't read
your previous emails carefully ;)

Oleg.

