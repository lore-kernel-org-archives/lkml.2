Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353Ab1CWRQu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 13:16:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36982 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752320Ab1CWRQt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 13:16:49 -0400
Date: Wed, 23 Mar 2011 18:07:08 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: roland@redhat.com, jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Subject: Re: [PATCH 7/8] job control: Notify the real parent of job control
	events regardless of ptrace
Message-ID: <20110323170708.GA24304@redhat.com>
References: <1299614199-25142-1-git-send-email-tj@kernel.org> <1299614199-25142-8-git-send-email-tj@kernel.org> <20110321174306.GA29895@redhat.com> <20110322080444.GM12003@htj.dyndns.org> <20110322194416.GC28038@redhat.com> <20110323091736.GY12003@htj.dyndns.org> <20110323092455.GZ12003@htj.dyndns.org> <20110323164657.GB22527@redhat.com> <20110323165907.GE12003@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110323165907.GE12003@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/23, Tejun Heo wrote:
>
> Hello,
>
> On Wed, Mar 23, 2011 at 05:46:57PM +0100, Oleg Nesterov wrote:
> > > Ooh, on a related note, we probably want to change
> > > do_notify_parent_cldstop() too.  tsk->group_leader->real_parent is
> > > used as the delivery target when !@for_ptracer.  This is the same with
> > > tsk->real_parent and the code has been like this for a long time but
> > > is a bit confusing.
> >
> > Yes, although in this case we do
> >
> > 		tsk = tsk->group_leader;
> > 		parent = tsk->real_parent;
> >
> > We need to change tsk to report the correct si_pid. But we could do
> >
> > 		parent = tsk->real_parent;
> > 		tsk = tsk->group_leader;
> >
> > not sure this looks less confusing.
>
> They themselves are about the same but the inconsistency with the
> is_real_parent() test is a bit confusing, I think.  If we're testing
> for duplicates by testing ->real_parent against ->parent then the
> actual delivery should be also be using ->real_parent and ->parent,
> so...

Hmm. So I misunderstood you. And still can't understand...

Could you explain how should we change do_notify_parent_cldstop()?
I am just curious.

Oleg.

