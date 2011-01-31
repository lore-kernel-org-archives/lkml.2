Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509Ab1AaKjB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 05:39:01 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59364 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683Ab1AaKjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 05:39:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=T8MZClBjme6LDoSenm0GuaM96ihhC1EsQwQirhF190AmxSaovNYNb8La9QhPdLUCvA
         p+ta9dN3GpWj3+gxDD9cRxK3pY9rPinzKcWOPU/FW696IgsnTy09AY+/nK6zvDkKE4vy
         Md+QSfbrnYA1DAtmGPmCmh0mvzQlegNa5V/U8=
Date: Mon, 31 Jan 2011 11:38:55 +0100
From: Tejun Heo <tj@kernel.org>
To: Roland McGrath <roland@redhat.com>
Cc: oleg@redhat.com, jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [PATCH 02/10] ptrace: remove the extra wake_up_process() from
 ptrace_detach()
Message-ID: <20110131103855.GD7459@htj.dyndns.org>
References: <1296227324-25295-1-git-send-email-tj@kernel.org>
 <1296227324-25295-3-git-send-email-tj@kernel.org>
 <20110128184601.CBF7C180996@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110128184601.CBF7C180996@magilla.sf.frob.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Jan 28, 2011 at 10:46:01AM -0800, Roland McGrath wrote:
> NAK.  Let's have the wake_up_state(task, TASK_TRACED|TASK_STOPPED) version
> go in first.  That one will be more appropriate for -stable.  Even if we
> shortly remove it entirely in mainline, having the more conservative
> intermediate state in the git history will make any future problems more
> susceptible to bisection.

Yeap, sounds reasonable.  So, you're saying it can go away but should
be converted to safer sleep first, right?  I'll resequence the patches.

Thank you.

-- 
tejun
