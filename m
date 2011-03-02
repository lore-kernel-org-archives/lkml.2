Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756320Ab1CBKPz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 05:15:55 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58272 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755820Ab1CBKPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 05:15:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=SgJzxxuA6xC/LdOMKSlyDq75CatjJ38SENisaOSB2vAHCV1Hj3zgumxeGzP1rthrW2
         AmDAiPBev71fTeer9XJMsODnc+lNL9/GrBOqivMNKahykyE9H2niGq+MOIvhRgN0F845
         9bKOIfMdLuXt0gHIxWUuP+7j8mHMdpMwbbVsM=
Date: Wed, 2 Mar 2011 11:15:47 +0100
From: Tejun Heo <tj@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: David Rientjes <rientjes@google.com>, Yinghai Lu <yinghai@kernel.org>,
        tglx@linutronix.de, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH x86/mm] x86-64, NUMA: Fix distance table handling
Message-ID: <20110302101547.GA3319@htj.dyndns.org>
References: <20110224145128.GM7840@htj.dyndns.org>
 <4D66AC9C.6080500@kernel.org>
 <20110224192305.GB15498@elte.hu>
 <4D66B176.9030300@kernel.org>
 <alpine.DEB.2.00.1103010844430.19743@chino.kir.corp.google.com>
 <20110302100400.GK19669@htj.dyndns.org>
 <20110302100727.GA24692@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110302100727.GA24692@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 02, 2011 at 11:07:27AM +0100, Ingo Molnar wrote:
> 
> * Tejun Heo <tj@kernel.org> wrote:
> 
> > +	size_t size = numa_distance_cnt * numa_distance_cnt *
> > +		      sizeof(numa_distance[0]);
> 
> > +		memblock_x86_reserve_range(phys, phys + phys_size,
> > +					   "TMP NUMA DIST");
> 
> > +		memblock_x86_free_range(__pa(phys_dist),
> > +					__pa(phys_dist) + phys_size);
> 
> These silly linebreaks are really annoying. Please ignore checkpatch when the 
> solution makes the result so much uglier. Having line width up to 90-95 is still 
> fine.

I'm letting all the printks format strings go over the limit (whatever
that may be) but all these files already mostly conform to 80-column
limit so I'm a bit hesitant to break it for codes.  Hey, but it's
ultimately your call.

FWIW, I'm not really decided about 80 vs. whatever column issue.
Having a common limit definitely helps a lot but it seems almost
impossible to agree on one - is it 90, 95, 100 or 120?  Given that, it
almost seems just sticking to 80 might be the only doable solution.

Thanks.

-- 
tejun
