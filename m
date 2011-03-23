Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174Ab1CWQ40 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 12:56:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27448 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752597Ab1CWQ4Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 12:56:24 -0400
Date: Wed, 23 Mar 2011 17:46:57 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: roland@redhat.com, jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Subject: Re: [PATCH 7/8] job control: Notify the real parent of job control
	events regardless of ptrace
Message-ID: <20110323164657.GB22527@redhat.com>
References: <1299614199-25142-1-git-send-email-tj@kernel.org> <1299614199-25142-8-git-send-email-tj@kernel.org> <20110321174306.GA29895@redhat.com> <20110322080444.GM12003@htj.dyndns.org> <20110322194416.GC28038@redhat.com> <20110323091736.GY12003@htj.dyndns.org> <20110323092455.GZ12003@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110323092455.GZ12003@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/23, Tejun Heo wrote:
>
> On Wed, Mar 23, 2011 at 10:17:36AM +0100, Tejun Heo wrote:
> > >
> > > child->real_parent must be equal to child->group_leader->real_parent.
> >
> > Okay.
>
> Ooh, on a related note, we probably want to change
> do_notify_parent_cldstop() too.  tsk->group_leader->real_parent is
> used as the delivery target when !@for_ptracer.  This is the same with
> tsk->real_parent and the code has been like this for a long time but
> is a bit confusing.

Yes, although in this case we do

		tsk = tsk->group_leader;
		parent = tsk->real_parent;

We need to change tsk to report the correct si_pid. But we could do

		parent = tsk->real_parent;
		tsk = tsk->group_leader;

not sure this looks less confusing.

Oleg.

