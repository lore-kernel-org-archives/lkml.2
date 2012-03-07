Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932755Ab2CGV0w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 16:26:52 -0500
Received: from usmamail.tilera.com ([206.83.70.75]:34123 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757034Ab2CGV0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 16:26:49 -0500
Message-ID: <4F57D296.8090608@tilera.com>
Date: Wed, 7 Mar 2012 16:26:46 -0500
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Jason Baron <jbaron@redhat.com>
CC: Roland McGrath <roland@hack.frob.com>, <akpm@linux-foundation.org>,
        <avi@redhat.com>, <linux-kernel@vger.kernel.org>,
        <qemu-devel@nongnu.org>
Subject: Re: [PATCH 1/2] core dump: drop VM_ALWAYSDUMP flag
References: <cover.1331137504.git.jbaron@redhat.com> <3290280b610108e3766e1f82b7d8c74cb688cba5.1331137504.git.jbaron@redhat.com> <CAB=4xhrVbjSiMOA=SyQ_SMROm6uWd3a-b4j987wYsJzMD7pm3g@mail.gmail.com> <20120307185035.GA2409@redhat.com> <20120307194302.7BD142C0C3@topped-with-meat.com> <20120307211909.GB2409@redhat.com>
In-Reply-To: <20120307211909.GB2409@redhat.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/7/2012 4:19 PM, Jason Baron wrote:
> On Wed, Mar 07, 2012 at 11:43:02AM -0800, Roland McGrath wrote:
>>> well, sure, we can provide an arch interface, for this check. I'm more
>>> concerned with the general idea. If it seems ok, I can re-do this bit
>>> with an arch interface.
>> Anything based on strcmp is dismal.  VM_ALWAYSDUMP was nice and clean.
>> A hook along the lines of arch_vma_name would be clean enough I suppose.
>> In fact, there is only one instance today (tile) where arch_vma_name()!=NULL
>> wouldn't do just what you need.
>>
> Yeah, so I think something like the following would work (adding Tile
> maintainer to 'cc list).

Thanks!

My instinct would be not to special-case it in always_dump_vma().  Since
it's just a one-page region anyway, and it is at least potentially
interesting, I'm happy to always dump it.  Alternately, we can just get rid
of the "[intrpt]" name, which I just put in to be cute (and since it was
easy to identify the mapping in question).  Regardless, since that region
doesn't exist on our current 64-bit architecture, I'm not too concerned
with how it's handled going forward, since I expect the 32-bit platform to
become less popular over time.  I'd vote for generic code cleanliness.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

