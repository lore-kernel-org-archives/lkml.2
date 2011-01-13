Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757431Ab1AMWUm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 17:20:42 -0500
Received: from smtp-out.google.com ([74.125.121.67]:22917 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149Ab1AMWUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 17:20:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=NZOnuoqnYh4XLZ+6jNeT68E6OuvJC+fXdIwyMTBIK3CrOtMcs2Yj2gCJEztKXkViXm
         1HHjpCi0GnGes7l29M1A==
Date: Thu, 13 Jan 2011 14:20:29 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Satoru Moriya <satoru.moriya@hds.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mel@csn.ul.ie>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Randy Dunlap <rdunlap@xenotime.net>, dle-develop@lists.sourceforge.net,
        Seiji Aguchi <seiji.aguchi@hds.com>
Subject: RE: [RFC][PATCH 0/2] Tunable watermark
In-Reply-To: <65795E11DBF1E645A09CEC7EAEE94B9C3B8DF645@USINDEVS02.corp.hds.com>
Message-ID: <alpine.DEB.2.00.1101131414110.26770@chino.kir.corp.google.com>
References: <65795E11DBF1E645A09CEC7EAEE94B9C3A30A295@USINDEVS02.corp.hds.com> <alpine.DEB.2.00.1101071416450.23577@chino.kir.corp.google.com> <65795E11DBF1E645A09CEC7EAEE94B9C3B8DF645@USINDEVS02.corp.hds.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Jan 2011, Satoru Moriya wrote:

> > You didn't mention why it wouldn't be possible to modify 
> > setup_per_zone_wmarks() in some way for your configuration so this happens 
> > automatically.  If you can find a deterministic way to set these 
> > watermarks from userspace, you should be able to do it in the kernel as 
> > well based on the configuration.
> 
> Do you mean that we should introduce a mechanism into kernel that changes
> watermarks dynamically depending on its loads (such as cpu frequency control)
> or we should change the calculation method in setup_per_zone_wmarks()?
> 

The watermarks you're exposing through this patchset to userspace for the 
first time are meant to be internal to the VM.  Userspace is not intended 
to manipulate them in an effort to cover-up deficiencies within the memory 
manager itself.  If you have actual cases where tuning the watermarks from 
userspace is helpful, then it logically means:

 - the VM is acting incorrectly in response to situations where it 
   approaches the tunable min watermark (all watermarks are a function of 
   the min watermark) which shouldn't representative in just a handfull
   of cases, and

 - you can deterministically do the same calculation within the kernel
   itself.

I'm skeptical that any tuning is actually helpful to your workload that 
doesn't also indicate a problem internal to the VM itself.  I think what 
would be more helpful is if you would show how the watermarks currently 
don't trigger fast enough (or aggressive enough) and then address the 
issue in the kernel itself so everyone can benefit from your work, whether 
that's adjusting where the watermarks are based on external factors or 
whether the semantics of those watermarks are to slightly change.
