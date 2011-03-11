Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753085Ab1CKSWI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 13:22:08 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58259 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752912Ab1CKSWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 13:22:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=XQSeYp+9ecVUKkGiVDvwb4BSDY5FIUvlxJmuehaLIpAUv9Rr0BT7XGBnfd4MaToFg2
         t2EWf6yTOvA70h1iYSwJ1mO0UoSVqCLYDTl5jv6+0vQQlZQOj8JX+wHbX3dYEn3t6OtD
         KabcjOhMqD/JgSMnvHZBeYDdCvHT2Wk0289nw=
Date: Fri, 11 Mar 2011 19:19:58 +0100
From: Tejun Heo <tj@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@elte.hu>,
        tglx@linutronix.de, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH x86/mm UPDATED] x86-64, NUMA: Fix distance table
 handling
Message-ID: <20110311181958.GJ13038@htj.dyndns.org>
References: <4D6EA975.8070200@kernel.org>
 <20110302205704.GF28266@mtj.dyndns.org>
 <4D6EB335.8000306@kernel.org>
 <20110303061711.GG28266@mtj.dyndns.org>
 <4D791C9F.1010500@kernel.org>
 <20110311082938.GC13038@htj.dyndns.org>
 <20110311083351.GD13038@htj.dyndns.org>
 <4D7A4430.1030301@kernel.org>
 <20110311155446.GH13038@htj.dyndns.org>
 <AANLkTim31ZDBRtBFL2J5HD8j8__tzkSF_HdD-HVt6V49@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTim31ZDBRtBFL2J5HD8j8__tzkSF_HdD-HVt6V49@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Mar 11, 2011 at 10:02:41AM -0800, Yinghai Lu wrote:
> > No, NUMA implementation can skip numa_set_distance() entirely if the
> > distance is LOCAL_DISTANCE if nids are equal, REMOTE_DISTANCE
> > otherwise.  In fact, any amdtopology configuraiton would behave this
> > way, so it's incorrect to fill the table with LOCAL_DISTANCE.  You
> > have to check the physnid mapping and build new table whether physical
> > table exists or not.  Lack of physical distance table doesn't mean all
> > nodes are LOCAL_DISTANCE.
> 
> too bad. We should call numa_alloc_distance in amdtopology to set
> default value in that array.

I'm not following.  If there's no distance table, the distance is
assumed to be LOCAL between the same node and REMOTE if the nodes are
different, which is exactly the way it should be for those machines.
Why is this bad and why would you allocate distance table for such
configurations?

-- 
tejun
