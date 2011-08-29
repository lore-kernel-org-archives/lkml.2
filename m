Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938Ab1H2QV0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 12:21:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46895 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753410Ab1H2QVW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 12:21:22 -0400
Date: Mon, 29 Aug 2011 18:17:50 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: rjw@sisk.pl, paul@paulmenage.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de
Subject: Re: [PATCH 14/16] freezer: make freezing() test freeze conditions
	in effect instead of TIF_FREEZE
Message-ID: <20110829161750.GA9411@redhat.com>
References: <1313763382-12341-1-git-send-email-tj@kernel.org> <1313763382-12341-15-git-send-email-tj@kernel.org> <20110829154944.GA7531@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110829154944.GA7531@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29, Oleg Nesterov wrote:
>
> > @@ -120,13 +120,18 @@ int freeze_processes(void)
> >  {
> >  	int error;
> >
> > +	if (!pm_freezing)
> > +		atomic_inc(&system_freezing_cnt);
> > +
> >  	printk("Freezing user space processes ... ");
> > +	pm_freezing = true;
>
> and
>
> > @@ -146,6 +151,11 @@ void thaw_processes(void)
> >  {
> >  	struct task_struct *g, *p;
> >
> > +	if (pm_freezing)
> > +		atomic_dec(&system_freezing_cnt);
> > +	pm_freezing = false;
>
> I simply can't understand this... Why freeze_processes/thaw_processes
> check pm_freezing?

Ah, wait, I seem to understand.

> IIUC, the calls to freeze/thaw should be serialized anyway

Yes, and that is why this should actually work, I think.

Sorry for noise...

Oleg.

