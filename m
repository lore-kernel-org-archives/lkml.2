Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880Ab1BAKYW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 05:24:22 -0500
Received: from a.mx.secunet.com ([195.81.216.161]:40007 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750951Ab1BAKYU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 05:24:20 -0500
Date: Tue, 1 Feb 2011 11:24:18 +0100
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Eric Paris <eparis@redhat.com>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH] flex_array: Change behaviour on zero size allocations
Message-ID: <20110201102417.GL3070@secunet.com>
References: <20110131085213.GK3070@secunet.com>
 <1296491497.7797.3792.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296491497.7797.3792.camel@nimitz>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 01 Feb 2011 10:24:18.0715 (UTC) FILETIME=[2F254EB0:01CBC1FA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 31, 2011 at 08:31:37AM -0800, Dave Hansen wrote:
> 
> I think this still has some of the issues of the earlier patch.  The
> zero-size check needs to be moved after the ->total_nr_elements check.
> Otherwise, this won't produce any errors:
> 
> 	fa = flex_array_alloc(0, 100, GFP_KERNEL);
> 	flex_array_put(fa, 1001, ptr, GFP_KERNEL);
> 
> > @@ -284,6 +297,8 @@ void *flex_array_get(struct flex_array *fa, unsigned int element_nr)
> >         int part_nr = fa_element_to_part_nr(fa, element_nr);
> >         struct flex_array_part *part;
> > 
> > +       if (!fa->total_nr_elements || !fa->element_size)
> > +               return NULL;
> >         if (element_nr >= fa->total_nr_elements)
> >                 return NULL;
> >         if (elements_fit_in_base(fa))
> 
> Do you really need to check fa->total_nr_elements both for zero and
> against element_nr?  Seems a but superfluous to me.
> 

Both objections are correct, I'll send an updated patch.

Steffen
