Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751400Ab1AEIpu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 03:45:50 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:59032 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814Ab1AEIpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 03:45:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=HEejplXJiejA6es8bwAubd54E9EnFvznO06t76VlzzYfzYWyEZkv1Gj9+T8721vFrY
         brG1m6ECdvRGG93UY0fEjVoFAiymrETEjUyhfdHhL6fljU77z821RmUjX7DWV1myG/ZH
         Zd3IdWAbwbACRbkC5j8G9x1fVVQ2tls4+XsEQ=
Date: Wed, 5 Jan 2011 10:45:43 +0200
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] proc: make proc entry's len "unsigned int"
Message-ID: <20110105084543.GA4598@p183.telecom.by>
References: <20101126211033.GA14339@core2.telecom.by>
 <20110104165159.49c257b7.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110104165159.49c257b7.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 04, 2011 at 04:51:59PM -0800, Andrew Morton wrote:
> On Fri, 26 Nov 2010 23:10:33 +0200
> Alexey Dobriyan <adobriyan@gmail.com> wrote:

> >  struct proc_dir_entry {
> >  	unsigned int low_ino;
> > -	unsigned short namelen;
> > +	unsigned int namelen;
> >  	const char *name;
> >  	mode_t mode;
> >  	nlink_t nlink;
> 
> Well, if we _can_ save some space here then the returns would be
> appreciable.
> 
> akpm:/home/akpm# find /proc | wc -l
> 95543
> 
> (wtf?)
> 
> akpm:/home/akpm# find /proc/[0-9]* | wc -l
> 94212
> 
> (oh.)

Different number of processes?

> Do all of those things have a proc_dir_entry?

No!

> IIRC we changed things so they're somewhat allocate-on-demand.

Only /proc/$PID and /proc/sys/* are on-demand allocated.
The rest has struct proc_dir_entry associated.
