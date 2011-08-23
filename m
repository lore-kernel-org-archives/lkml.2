Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460Ab1HWPqA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 11:46:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4622 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751997Ab1HWPpy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 11:45:54 -0400
Date: Tue, 23 Aug 2011 17:42:39 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: rjw@sisk.pl, menage@google.com, linux-kernel@vger.kernel.org,
        arnd@arndb.de, Jens Axboe <axboe@kernel.dk>,
        Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>
Subject: Re: [PATCH 04/16] freezer: implement and use
	kthread_freezable_should_stop()
Message-ID: <20110823154239.GA25808@redhat.com>
References: <1313763382-12341-1-git-send-email-tj@kernel.org> <1313763382-12341-5-git-send-email-tj@kernel.org> <20110821191421.GA9793@redhat.com> <20110822095357.GC24151@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110822095357.GC24151@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

On 08/22, Tejun Heo wrote:
>
> > OK, but then we do
> >
> > 	current->flags &= ~PF_FREEZING;
> >
> > since PF_FROZEN wasn't cleared this can race with
> >
> > 	p->flags &= ~PF_FROZEN;
> >
> > No?
>
> Indeed, I removed PF_FREEZING and moved PF_FROZEN to __refrigerator()
> in later patches, so it's already gone.

OK, thanks.

> Patches could have been
> sequenced better, I suppose.  But, sequencing fixes for different
> races was already pretty challenging.  :)

... and it also makes sense to try to read the whole seried before
asking the question.

although this is not simple. Especially because currently I can't
read it faster than one patch per day ;)

Oleg.

