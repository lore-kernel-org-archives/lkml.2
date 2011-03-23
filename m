Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932275Ab1CWJZB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 05:25:01 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36129 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755974Ab1CWJZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 05:25:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ir3574JJyMHR0vwjLT//PX0aAtWOn81QcCTr2esWM4PAADqi5aDfmXdye7Cp0cAcvo
         6a2/T6JAobkbbejgsfYx/LA4rBmXYIbYfcN6VbZkzfl0lBCnYb0tVZG1WLDUfbSPkQ7A
         yyAlZZwC2zyHsgFs4X11uiWi30mN+IPZ4tMhc=
Date: Wed, 23 Mar 2011 10:24:55 +0100
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: roland@redhat.com, jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Subject: Re: [PATCH 7/8] job control: Notify the real parent of job control
 events regardless of ptrace
Message-ID: <20110323092455.GZ12003@htj.dyndns.org>
References: <1299614199-25142-1-git-send-email-tj@kernel.org>
 <1299614199-25142-8-git-send-email-tj@kernel.org>
 <20110321174306.GA29895@redhat.com>
 <20110322080444.GM12003@htj.dyndns.org>
 <20110322194416.GC28038@redhat.com>
 <20110323091736.GY12003@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110323091736.GY12003@htj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 23, 2011 at 10:17:36AM +0100, Tejun Heo wrote:
> Hey, Oleg.
> 
> On Tue, Mar 22, 2011 at 08:44:16PM +0100, Oleg Nesterov wrote:
> > On 03/22, Tejun Heo wrote:
> > >
> > > On Mon, Mar 21, 2011 at 06:43:06PM +0100, Oleg Nesterov wrote:
> > > > Hmm... in fact I can't convince myself we really need to look at
> > > > child->group_leader, will recheck... Anyway, this is minor too.
> > >
> > > Care to elaborate?
> > 
> > child->real_parent must be equal to child->group_leader->real_parent.
> 
> Okay.

Ooh, on a related note, we probably want to change
do_notify_parent_cldstop() too.  tsk->group_leader->real_parent is
used as the delivery target when !@for_ptracer.  This is the same with
tsk->real_parent and the code has been like this for a long time but
is a bit confusing.

Thanks.

-- 
tejun
