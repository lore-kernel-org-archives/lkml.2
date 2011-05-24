Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578Ab1EXPoi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 11:44:38 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47059 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862Ab1EXPog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 11:44:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=xR1Va1tJrPjdNhZN4cMDLDMnChRmc3e6bEOkAOV2VmWlF3pSiCak1ahPeaVsBTx4Jy
         toyl9ev8fy5Qvcp+d8y4EvTgwwTfaMnS/kUck6aWTnZfIGpjmvSsOBzGOiTtXCJHQS8c
         DdIHtNx2pE1DXwBzO6MXba17eBikwbQT3DFwQ=
Date: Tue, 24 May 2011 17:44:32 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com
Subject: Re: [PATCH 10/10] ptrace: implement group stop notification for
 ptracer
Message-ID: <20110524154432.GH10334@htj.dyndns.org>
References: <1305569849-10448-1-git-send-email-tj@kernel.org>
 <1305569849-10448-11-git-send-email-tj@kernel.org>
 <20110519163246.GF17265@redhat.com>
 <20110519165833.GA19418@redhat.com>
 <20110523114559.GA5279@redhat.com>
 <20110524134411.GE10334@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110524134411.GE10334@htj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Oleg.

On Tue, May 24, 2011 at 03:44:11PM +0200, Tejun Heo wrote:
> > 2. ptrace_trap_notify() always sets JOBCTL_TRAP_NOTIFY. Even if the caller
> > is prepare_signal(SIGCONT) and there were no SIGSTOP in the past. This looks
> > a bit strange to me. I mean, perhaps it would be better to provoke the trap
> > only if this SIGCONT is going to change the jobctl state.
> 
> Sure.  It doesn't really matter tho and might even be better for
> weeding out invalid assumptions.

Hmmm... tried to change this but I think it's better as-is.  As an
optimization, it isn't whole lot meaningful, and, if I do it, I would
probably end up moving SIGNAL_STOP_STOPPED and group_stop_count test
above actual wake up and then skipping wake up if none was true - it
would make SIGCONT handling more fragile without much benefit.

Thanks.

-- 
tejun
