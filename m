Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755882Ab1CKQEB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 11:04:01 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33608 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753617Ab1CKQEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 11:04:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=TNzRAouIm0/5vwKF/HlKIIt1Bl2+YBXTPV8Adfz4scBAFmoSe4ciVnHY366baO1U8M
         tPeVgqRWD+8MerDiSExgtrXnbMS7drMV0h7ecU6ZYvxbQ0afFWbil6LGGexPgg5RjOGD
         qSXTBCEAfT8xAoHKP/St1mLMb8gxs4jxbP2Mo=
Date: Fri, 11 Mar 2011 17:03:55 +0100
From: Tejun Heo <tj@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@elte.hu>,
        tglx@linutronix.de, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH x86/mm] x86-64, NUMA: Don't call numa_set_distanc() for
 all possible node combinations during emulation
Message-ID: <20110311160355.GI13038@htj.dyndns.org>
References: <4D6E9541.2040201@kernel.org>
 <20110302191338.GE28266@mtj.dyndns.org>
 <4D6EA975.8070200@kernel.org>
 <20110302205704.GF28266@mtj.dyndns.org>
 <4D6EB335.8000306@kernel.org>
 <20110303061711.GG28266@mtj.dyndns.org>
 <4D791C9F.1010500@kernel.org>
 <20110311082938.GC13038@htj.dyndns.org>
 <20110311093124.GE13038@htj.dyndns.org>
 <4D7A42E2.6070400@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D7A42E2.6070400@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Yinghai.

On Fri, Mar 11, 2011 at 07:42:26AM -0800, Yinghai Lu wrote:
> > @@ -393,14 +398,10 @@ void __init numa_emulation(struct numa_meminfo *numa_meminfo, int numa_dist_cnt)
> >  		if (emu_nid_to_phys[i] == NUMA_NO_NODE)
> >  			emu_nid_to_phys[i] = dfl_phys_nid;
> >  
> > -	/*
> > -	 * Transform distance table.  numa_set_distance() ignores all
> > -	 * out-of-bound distances.  Just call it for every possible node
> > -	 * combination.
> > -	 */
> > +	/* transform distance table */
> >  	numa_reset_distance();
> > -	for (i = 0; i < MAX_NUMNODES; i++) {
> > -		for (j = 0; j < MAX_NUMNODES; j++) {
> > +	for (i = 0; i < max_emu_nid + 1; i++) {
> > +		for (j = 0; j < max_emu_nid + 1; j++) {
> 
> using num_emu_nids would be better?

Well, this is mostly frivolous but I think max is better here.  We
don't really care about the number of emulated nodes.  The number
we're looking for is the number which allows the code to cover all
enabled configurations.  So, I think max reflects the logic better.

Thanks.

-- 
tejun
