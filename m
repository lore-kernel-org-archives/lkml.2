Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454Ab1BBK4i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 05:56:38 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52268 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753321Ab1BBK4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 05:56:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=UPx5AjIQA86+lOX6EkUNSPUCP86HaJKNqf+kTVuQNtgu7vOhnIEtjG8IuqmsZbSL++
         wnYGBuedxjzqCpgGF2Dq7/I7OnjDfirs+KqpVEU4iCdmLgwID87Lwe5FpxjCO39llgBy
         4VgKcHU5j4eTqWNJJvRGB+SroDCHlh2lh2AM0=
Date: Wed, 2 Feb 2011 11:56:31 +0100
From: Tejun Heo <tj@kernel.org>
To: Roland McGrath <roland@redhat.com>
Cc: oleg@redhat.com, jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [PATCH 06/10] signal: fix premature completion of group stop
 when interfered by ptrace
Message-ID: <20110202105631.GE24115@htj.dyndns.org>
References: <1296227324-25295-1-git-send-email-tj@kernel.org>
 <1296227324-25295-7-git-send-email-tj@kernel.org>
 <20110128212257.9C18B183C1E@magilla.sf.frob.com>
 <20110131110007.GF7459@htj.dyndns.org>
 <20110202054405.D78AE183D88@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110202054405.D78AE183D88@magilla.sf.frob.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Feb 01, 2011 at 09:44:05PM -0800, Roland McGrath wrote:
> > I have plans on separate out ptrace related stuff from task_struct so
> > that they're allocate iff they're used which will save some tens of
> > bytes on the task struct, so there at least is a plan to compensate
> > for the added cruft.
> 
> My, that sounds familiar.  Oleg and I have pursued that before, though
> not in exactly the same context.  It sure gets complicated quickly in
> the corners.  But we would still like to see it get done one way or
> another.

Yeap, I have mostly working code.  It was necessary to allow nesting,
so...

> > > But I'm not entirely convinced that we'll really need them when we
> > > conclude on fully cleaning up the whole picture.
> > 
> > I really don't know at this point.  I tried to make it share one of
> > the related fields but there needs to be a per-task field which is
> > protected by siglock and there currently isn't any, so...
> 
> My point was that I am not yet convinced we'll need any new bookkeeping of
> that sort once we fully work out the group-stop interactions.  We're still
> discussing that in the other threads.  So we'll see where that goes.

Yeah, sure.

Thanks.

-- 
tejun
