Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752811Ab1FJGk7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 02:40:59 -0400
Received: from smtp-out.google.com ([216.239.44.51]:17514 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027Ab1FJGk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 02:40:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=TrTcuAWTmEFlT+UpLnQpH8AVvRr/3iCLfgah/aQrdF2j0uCS0UQeVY0v/nUZZifaOq
         nTHKq/kuoH8VPR3ks+kw==
Date: Thu, 9 Jun 2011 23:40:38 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Shaohua Li <shaohua.li@intel.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        "Zhang, Yanmin" <yanmin.zhang@intel.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 5/7] tmpfs: simplify prealloc_page
In-Reply-To: <1307671323.15392.76.camel@sli10-conroe>
Message-ID: <alpine.LSU.2.00.1106092334440.12180@sister.anvils>
References: <alpine.LSU.2.00.1106091529060.2200@sister.anvils> <alpine.LSU.2.00.1106091535510.2200@sister.anvils> <1307671323.15392.76.camel@sli10-conroe>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Jun 2011, Shaohua Li wrote:
> On Fri, 2011-06-10 at 06:39 +0800, Hugh Dickins wrote:
> > @@ -1492,11 +1460,19 @@ repeat:
> >  		SetPageUptodate(filepage);
> >  		if (sgp == SGP_DIRTY)
> >  			set_page_dirty(filepage);
> > +	} else {
> Looks info->lock unlock is missed here.
> Otherwise looks good to me.

Many thanks for catching that!  Replacements for this patch,
and the next which then rejects, follow as replies.

Hugh
