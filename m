Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974Ab0ICD3q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 23:29:46 -0400
Received: from dalsmrelay2.nai.com ([205.227.136.216]:16322 "HELO
	dalsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751656Ab0ICD3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 23:29:44 -0400
Message-ID: <4C806B94.5040409@snapgear.com>
Date: Fri, 3 Sep 2010 13:29:24 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: David Howells <dhowells@redhat.com>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] M68K: Use CONFIG_MMU not __uClinux__ to select	m68knommu
 contributions
References: <19747.1283422807@redhat.com> <20100902102158.19806.14133.stgit@warthog.procyon.org.uk> <20100902135438.GA23729@merkur.ravnborg.org>
In-Reply-To: <20100902135438.GA23729@merkur.ravnborg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Sep 2010 03:29:42.0435 (UTC) FILETIME=[3F59F730:01CB4B18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> On Thu, Sep 02, 2010 at 11:21:58AM +0100, David Howells wrote:
>> Use CONFIG_MMU not __uClinux__ to select m68knommu contributions as nothing in
>> the arch defines __uClinux__ for the build.
>>
>> This patch was achieved by running the following three commands:
>>
>> perl -pi -e 's/ifdef __uClinux__/ifndef CONFIG_MMU/' `find arch/m68k -name "*.[ch]"`
>> perl -pi -e 's/ifndef __uClinux__/ifdef CONFIG_MMU/' `find arch/m68k -name "*.[ch]"`
>> perl -pi -e 's!endif /[*] __uClinux__ [*]/!endif /* CONFIG_MMU */!' `find arch/m68k -name "*.[ch]"
> 
> Have you verified that this does not leak out
> to the userspace headers?
> We cannot use the CONFIG_ symbol to distingush between
> the two variants in userspace.
> 
> This was exactly the reason why __uClinux__ was used
> in the first place. But I hope Geert/Greg has fixed
> it up so all exported headers are the same so that
> this patch is OK.

Well, I don't quite have them all fixed yet. I have been working
through them, merging the separate files, and getting rid of the
use of __uClinux__ where ever I can. Most of the cases in David's
patch are the files I still have out-standing to merge back
together. The exceptions are param.h and sigcontext.h - and
they are a bit more tricky. They are user exported, and they
actually change data structures.

> At first look I think it is OK - but your changelog
> does not address this so wanted you to confirm this.

I don't have any problem with David's patch if we take out param.h
and sigcontext.h. But over time most will go away as I merge them
anyway.

Regards
Greg


------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
8 Gardner Close                             FAX:         +61 7 3217 5323
Milton, QLD, 4064, Australia                WEB: http://www.SnapGear.com
