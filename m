Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933436Ab2EWOxC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 10:53:02 -0400
Received: from mx2.parallels.com ([64.131.90.16]:55296 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754119Ab2EWOxA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 10:53:00 -0400
Message-ID: <4FBCF951.3040105@parallels.com>
Date: Wed, 23 May 2012 18:50:57 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
        David Rientjes <rientjes@google.com>, <linux-kernel@vger.kernel.org>,
        <cgroups@vger.kernel.org>, <linux-mm@kvack.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH] slab+slob: dup name string
References: <1337613539-29108-1-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1205212018230.13522@chino.kir.corp.google.com> <alpine.DEB.2.00.1205220855470.17600@router.home> <4FBBAE95.6080608@parallels.com> <alpine.DEB.2.00.1205221216050.17721@router.home> <alpine.DEB.2.00.1205221529340.18325@chino.kir.corp.google.com> <1337773595.3013.15.camel@dabdike.int.hansenpartnership.com> <4FBCD328.6060406@parallels.com> <1337775878.3013.16.camel@dabdike.int.hansenpartnership.com> <alpine.DEB.2.00.1205230947490.30940@router.home>
In-Reply-To: <alpine.DEB.2.00.1205230947490.30940@router.home>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2012 06:48 PM, Christoph Lameter wrote:
> On Wed, 23 May 2012, James Bottomley wrote:
>
>>>> So, why not simply patch slab to rely on the string lifetime being the
>>>> cache lifetime (or beyond) and therefore not having it take a copy?
>
> Well thats they way it was for a long time. There must be some reason that
> someone started to add this copying business....  Pekka?
>
The question is less why we added, but rather why we're keeping.

Of course reasoning about why it was added helps (so let's try to 
determine that), but so far the only reasonably strong argument in favor 
of keeping it was robustness.

But given that a lot of systems still uses SLAB, and we have no record 
of bugs due to dangling name pointers, this might very well be 
overzealousness on our part.
