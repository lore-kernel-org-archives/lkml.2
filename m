Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756794Ab2EXMI5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 08:08:57 -0400
Received: from mx2.parallels.com ([64.131.90.16]:44840 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756685Ab2EXMIa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 08:08:30 -0400
Message-ID: <4FBE243F.3080002@parallels.com>
Date: Thu, 24 May 2012 16:06:23 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: Christoph Lameter <cl@linux.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        David Rientjes <rientjes@google.com>, <linux-kernel@vger.kernel.org>,
        <cgroups@vger.kernel.org>, <linux-mm@kvack.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH] slab+slob: dup name string
References: <alpine.DEB.2.00.1205212018230.13522@chino.kir.corp.google.com> <alpine.DEB.2.00.1205220855470.17600@router.home> <4FBBAE95.6080608@parallels.com> <alpine.DEB.2.00.1205221216050.17721@router.home> <alpine.DEB.2.00.1205221529340.18325@chino.kir.corp.google.com> <1337773595.3013.15.camel@dabdike.int.hansenpartnership.com> <4FBCD328.6060406@parallels.com> <1337775878.3013.16.camel@dabdike.int.hansenpartnership.com> <alpine.DEB.2.00.1205230947490.30940@router.home> <4FBCF951.3040105@parallels.com> <20120524001831.GQ25351@dastard>
In-Reply-To: <20120524001831.GQ25351@dastard>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/24/2012 04:18 AM, Dave Chinner wrote:
>> Of course reasoning about why it was added helps (so let's try to
>> >  determine that), but so far the only reasonably strong argument in
>> >  favor of keeping it was robustness.
> I'm pretty sure it was added because there are slab names
> constructed by snprintf on a stack buffer, so the name doesn't exist
> beyond the slab initialisation function call...
>
> Cheers,
>
> Dave.
If that was the reason, we'd be seeing slab failing miserably where slub 
succeeds, since slab keeps no copy.


