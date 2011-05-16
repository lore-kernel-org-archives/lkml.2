Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756744Ab1EPQJy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 12:09:54 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:32893 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756589Ab1EPQJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 12:09:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=uYI+IPbBVjYitBjUDZTmmA3JXrZSfbfMT/szCL8NDs2gr7JE3IS08zqsURBd5J9ZIP
         RWjF5PK9PtOyia5AuW0noSADvYbIsc86d8Lh+MoTwnW2T70nsjy9hfomExCsLaRkxwTc
         ZqjzB9niCRQTVqFxzaJYL3WRSU6hpyYslcBFs=
Date: Mon, 16 May 2011 18:09:47 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com
Subject: Re: [PATCH 6/9] job control: make task_clear_jobctl_pending()
 clear TRAPPING automatically
Message-ID: <20110516160947.GC20624@htj.dyndns.org>
References: <1305301580-9924-1-git-send-email-tj@kernel.org>
 <1305301580-9924-7-git-send-email-tj@kernel.org>
 <20110516122535.GD4898@redhat.com>
 <20110516132400.GY23665@htj.dyndns.org>
 <20110516160019.GB15918@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110516160019.GB15918@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, May 16, 2011 at 06:00:19PM +0200, Oleg Nesterov wrote:
> > It's a safety mechanism.  We shouldn't have TRAPPING set when no
> > stop/trap is pending and the above establishes that invariant
> 
> Hmm. I thought that SIGCONT should add the new TRAPPING... My head spins.

So, it's two-fold, but we better talk about this with actual patches.

* SIGCONT always clears pending group stop - ie. JOBCTL_STOP_PENDING.
  If clearing of that flag leaves no group stop / trap condition
  pending (group stop pending was the only condition), it
  automatically clears TRAPPING.

* SIGCONT schedules JOBCTL_TRAP_STOP (STOP trap site for ptracer) and
  schedules TRAPPING, if tracee is already in TRAP_STOP for
  notification.  Note that this condition doesn't interact with the
  above action.

> My only point, I still think that it is better to not apply these
> preparations right now, without the next SEIZE/etc changes.

Sure thing.  As long as you don't see anything obviously wrong in the
prep patches, the rest of the series should be easier to review.

Anyways, will post soon.

Thanks.

-- 
tejun
