Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751847Ab1GUOca (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 10:32:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32510 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751569Ab1GUOc1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 10:32:27 -0400
Date: Thu, 21 Jul 2011 16:29:20 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Balbir Singh <bsingharora@gmail.com>,
        Jerome Marchand <jmarchan@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] taskstats: add_del_listener() should ignore !valid
	listener's
Message-ID: <20110721142920.GA5580@redhat.com>
References: <20110720185959.GA21749@redhat.com> <20110720190036.GB21753@redhat.com> <20110720194603.GA3385@albatros> <20110720210146.GA6273@redhat.com> <20110721125051.GA5443@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110721125051.GA5443@albatros>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/21, Vasiliy Kulikov wrote:
>
> On Wed, Jul 20, 2011 at 23:01 +0200, Oleg Nesterov wrote:
> >
> > Not sure I understand... This is not optimizing, the patch tries to
> > fix the unlikely (in fact mostly theoretical) and minor problem.
>
> Ah, I see the problem here.  Yes, then it surely makes sense.

Yes, agreed.

Just in case... please note that "s->pid can be reused" doesn't
necessarily mean this pid was reused by kernel. For example, a
task can close the socket without DEREGISTER, then create another
one and do REGISTER which can race with send_cpu_listeners().
Afaics.

All this register/deregister logic doesn't look very right, imho.

> Reviewed-by: Vasiliy Kulikov <segoon@openwall.com>

Thanks,

Oleg.

