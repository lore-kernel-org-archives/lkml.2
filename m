Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757033Ab0HDQn1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 12:43:27 -0400
Received: from smtp141.iad.emailsrvr.com ([207.97.245.141]:55921 "EHLO
	smtp141.iad.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756870Ab0HDQnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 12:43:25 -0400
X-Greylist: delayed 529 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Aug 2010 12:43:25 EDT
Message-ID: <4C5996B1.7060507@aljex.com>
Date: Wed, 04 Aug 2010 12:34:57 -0400
From: "Brian K. White" <brian@aljex.com>
Organization: Aljex Software Inc.
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.7) Gecko/20100713 Thunderbird/3.1.1
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: Ben Blum <bblum@andrew.cmu.edu>, Andrew Morton <akpm@linux-foundation.org>,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        oleg@redhat.com, ebiederm@xmission.com
Subject: Re: [PATCH v4 1/2] cgroups: read-write lock CLONE_THREAD forking
 per 	threadgroup
References: <20100730235649.GA22644@ghc17.ghc.andrew.cmu.edu>	<20100730235754.GB22644@ghc17.ghc.andrew.cmu.edu> <AANLkTikpNG2Y3S3AyxAbCkMynKu1u5yKPrw=bh+uy=9R@mail.gmail.com>
In-Reply-To: <AANLkTikpNG2Y3S3AyxAbCkMynKu1u5yKPrw=bh+uy=9R@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> As far as the #ifdef mess goes, it's true that some people don't have
> CONFIG_CGROUPS defined. I'd imagine that these are likely to be
> embedded systems with a fairly small number of processes and threads
> per process. Are there really any such platforms where the cost of a
> single extra rwsem per process is going to make a difference either in
> terms of memory or lock contention? I think you should consider making
> these additions unconditional.

openSUSE's default kernel* doesn't have CONFIG_CGROUPS

Personally I think it's a silly mistake also, since the argument was 
performance, and ubuntu's desktop kernel has it and actually outperforms 
openSUSE's, and the feature is perfectly likely to be needed by 
"desktop" users, but I wasn't and still aren't consulted on this and so 
it's a fact that must be lived with at least for a while. ;) (at least 
until the majority of 11.2 and 11.3 installations are replaced due to 
age, and that's if they reverted the decision today, which so far they 
haven't)

*("kernel-desktop" the one installed by default, not "kernel-default", 
which exists but is not installed by default since openSUSE 11.2)

-- 
bkw
