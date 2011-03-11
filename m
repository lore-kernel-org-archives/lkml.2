Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755864Ab1CKPyw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 10:54:52 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48246 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754736Ab1CKPyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 10:54:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=rSP+RoBzt3bnqS32ztO3uMigSY80aNyZ8+A/YglgpmqyqO9MFb3HannbGykf87Mis0
         7xCq4R+VJ2SovbDmaGWXJgIlxRRijDuyc+003pUrhpmshxSGcVPPwtuLtanUt4NTERCT
         8lJy/U45saaAIqsVtBibzuQ2m9SYEtEem8WhI=
Date: Fri, 11 Mar 2011 16:54:46 +0100
From: Tejun Heo <tj@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@elte.hu>,
        tglx@linutronix.de, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH x86/mm UPDATED] x86-64, NUMA: Fix distance table
 handling
Message-ID: <20110311155446.GH13038@htj.dyndns.org>
References: <4D6E9541.2040201@kernel.org>
 <20110302191338.GE28266@mtj.dyndns.org>
 <4D6EA975.8070200@kernel.org>
 <20110302205704.GF28266@mtj.dyndns.org>
 <4D6EB335.8000306@kernel.org>
 <20110303061711.GG28266@mtj.dyndns.org>
 <4D791C9F.1010500@kernel.org>
 <20110311082938.GC13038@htj.dyndns.org>
 <20110311083351.GD13038@htj.dyndns.org>
 <4D7A4430.1030301@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D7A4430.1030301@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 11, 2011 at 07:48:00AM -0800, Yinghai Lu wrote:
> On 03/11/2011 12:33 AM, Tejun Heo wrote:
> > On Fri, Mar 11, 2011 at 09:29:38AM +0100, Tejun Heo wrote:
> >> Also, I don't think your patch is correct.  Even if there is phys_dist
> >                                                               ^
> > 							      no
> >> table, emu distance tables should be built because emulated nids don't
> >> map to physical nids one to one.  ie. Two different emulated nids can
> >> share a physical node and the distance table should explicitly reflect
> >> that.
> 
> ok, when original SLIT is not there, mean only one really node.
> so the new distance table should be filled with LOCAL_DISTANCE.

No, NUMA implementation can skip numa_set_distance() entirely if the
distance is LOCAL_DISTANCE if nids are equal, REMOTE_DISTANCE
otherwise.  In fact, any amdtopology configuraiton would behave this
way, so it's incorrect to fill the table with LOCAL_DISTANCE.  You
have to check the physnid mapping and build new table whether physical
table exists or not.  Lack of physical distance table doesn't mean all
nodes are LOCAL_DISTANCE.

-- 
tejun
