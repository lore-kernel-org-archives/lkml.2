Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750857Ab1DMEAV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 00:00:21 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:55305 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707Ab1DMEAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 00:00:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=QNlUYKAuc0vrHg4vGeAG7brV2/+Y36NuvgssOfFSZ7WKYnGRjEo89qD0NMcJQvwt/O
         uHgui7hHzWyzFi7ddZHNn33nkrqBVVhS1qTe2xmsZcH++dANakdNkdMRh7KcCmu4tMl8
         uoZlsBsRBBWkbg1J/Z3vBphFcdPQln1/Htl74=
Date: Wed, 13 Apr 2011 13:00:13 +0900
From: "tj@kernel.org" <tj@kernel.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Shaohua Li <shaohua.li@intel.com>, lkml <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "cl@linux.com" <cl@linux.com>
Subject: Re: [PATCH 3/4]percpu_counter: fix code for 32bit systems
Message-ID: <20110413040013.GB24161@mtj.dyndns.org>
References: <1302595444.3981.129.camel@sli10-conroe>
 <1302599035.3233.27.camel@edumazet-laptop>
 <1302656465.3981.133.camel@sli10-conroe>
 <1302661927.2811.18.camel@edumazet-laptop>
 <1302662517.3981.161.camel@sli10-conroe>
 <1302662853.2811.41.camel@edumazet-laptop>
 <1302663781.3981.169.camel@sli10-conroe>
 <1302666820.2811.115.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1302666820.2811.115.camel@edumazet-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Apr 13, 2011 at 05:53:40AM +0200, Eric Dumazet wrote:
> Le mercredi 13 avril 2011 à 11:03 +0800, Shaohua Li a écrit :
> > I can do this, but please give a reason. If network code is the only
> > place requiring disable irq, why not network code do it?
> 
> Lot of percpu_counter users dont use full s64 range, but "unsigned long"
> or "unsigned int". Adding a lock on 32bit arches to get the s64, then
> truncate it is not needed.

Yeah, it might hurt 32bit archs a bit but if 64bit becomes better I'll
take that any day.  Also, atomic64_t implementation on x86-32 seems
pretty good and doesn't depend on irq spinlocks (which is quite
expensive), so it shouldn't be too bad.

Thanks.

-- 
tejun
