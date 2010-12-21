Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752164Ab0LUREW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 12:04:22 -0500
Received: from mail-bw0-f45.google.com ([209.85.214.45]:60760 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240Ab0LUREV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 12:04:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=cyiKvAdv3l2MXtA7KWXchjDz3v2XJzMeNSNxWbvvGqhFNc3opNY3HTHy43r/0W6IrT
         /CHk5ddcsyH/m6glyIToU6ZLNDKgV74E3Pb+GReY/qohr8ttPiMicq0TVmwo7BIHJ77x
         OXANFb5A2duPW89ZXoR4kLeByJN74DjQ5i0Hk=
Date: Tue, 21 Dec 2010 18:04:16 +0100
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: roland@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, rjw@sisk.pl,
        jan.kratochvil@redhat.com
Subject: Re: [PATCH 06/16] signal: fix premature completion of group stop
 when interfered by ptrace
Message-ID: <20101221170414.GD13285@htj.dyndns.org>
References: <1291654624-6230-1-git-send-email-tj@kernel.org>
 <1291654624-6230-7-git-send-email-tj@kernel.org>
 <20101220150018.GD11583@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101220150018.GD11583@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 20, 2010 at 04:00:18PM +0100, Oleg Nesterov wrote:
> On 12/06, Tejun Heo wrote:
> >
> > +static bool task_participate_group_stop(struct task_struct *task)
> > +{
> > +	struct signal_struct *sig = task->signal;
> > +	bool consume = task->group_stop & GROUP_STOP_CONSUME;
> > +
> > +	task_clear_group_stop(task);
> > +
> > +	if (!consume)
> > +		return false;
> > +
> > +	task->group_stop &= ~GROUP_STOP_CONSUME;
> 
> Minor nit, GROUP_STOP_CONSUME was already cleared by task_clear_group_stop().

Thanks.  Dropped.

-- 
tejun
