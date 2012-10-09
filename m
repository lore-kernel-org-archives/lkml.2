Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756559Ab2JIRtH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 13:49:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26927 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752195Ab2JIRtF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 13:49:05 -0400
Date: Tue, 9 Oct 2012 19:50:11 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrey Wagin <avagin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>
Subject: Re: [PATCH] [RFC] pidns: don't zap processes several times
Message-ID: <20121009175011.GA10492@redhat.com>
References: <1349603358-1085282-1-git-send-email-avagin@openvz.org> <20121007190118.GA16068@redhat.com> <CANaxB-w+KkhzTQVie=9PE8LJtazqvh+JducTcDmXvH+ZA4oO0A@mail.gmail.com> <20121009162925.GA6517@redhat.com> <CANaxB-xymHL8q8-yjCXQrL0fH7AKk0d4xV_AL77NFKYD=cAdMA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANaxB-xymHL8q8-yjCXQrL0fH7AKk0d4xV_AL77NFKYD=cAdMA@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/09, Andrey Wagin wrote:
>
> 2012/10/9 Oleg Nesterov <oleg@redhat.com>:
> > Hmm. This is off-topic, but...
> >
> >         create_pid_namespace:
> >
> >                 unsigned int level = parent_pid_ns->level + 1;
> >                 ns->pid_cachep = create_pid_cachep(level + 1);
>
> Yes, it's correct, because pid->numbers[ns->level] should be valid, so
>  a size of an array pid->numbers should be (level + 1).

Ah, yes. I missed that ns->level is "last index", not "array size".
Indeed, init_pid_ns.level = 0.

Thanks Andrey.

Oleg.

