Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755374Ab1KQX54 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 18:57:56 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53994 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755313Ab1KQX5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 18:57:53 -0500
Date: Thu, 17 Nov 2011 15:57:50 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: David Daney <ddaney.cavm@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        "ralf@linux-mips.org" <ralf@linux-mips.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Daney <david.daney@cavium.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Robin Holt <holt@sgi.com>
Subject: Re: [patch] hugetlb: remove dummy definitions of HPAGE_MASK and
 HPAGE_SIZE
In-Reply-To: <4EC59E3C.5070204@gmail.com>
Message-ID: <alpine.DEB.2.00.1111171553440.13555@chino.kir.corp.google.com>
References: <1321567050-13197-1-git-send-email-ddaney.cavm@gmail.com> <alpine.DEB.2.00.1111171520130.20133@chino.kir.corp.google.com> <alpine.DEB.2.00.1111171522131.20133@chino.kir.corp.google.com> <20111117153526.f90ee248.akpm@linux-foundation.org>
 <alpine.DEB.2.00.1111171538540.13555@chino.kir.corp.google.com> <4EC59E3C.5070204@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Nov 2011, David Daney wrote:

> A counter argument would be:
> 
> There are hundreds of places in the kernel where dummy definitions are
> selected by !CONFIG_* so that we can do:
> 
>    if (test_something()) {
>       do_one_thing();
>    } else {
>       do_the_other_thing();
>    }
> 
> 
> Rather than:
> 
> #ifdef CONFIG_SOMETHING
>    if (test_something()) {
>       do_one_thing();
>    } else
> #else
>    {
>       do_the_other_thing();
>    }
> 
> 
> 
> We even do this all over the place with dummy definitions selected by
> CONFIG_HUGETLB_PAGE, What exactly makes HPAGE_MASK special and not the
> hundreds of other similar situations?
> 

Dummy functions that return 0 when a feature isn't enabled isn't the 
problem, that's very convenient.  Definitions of constants are a 
completely separate story because they can be easily used outside the 
required context and cause brekage.  What happens if you reference a 
variable in a function that is declarated in a different function?  Does 
the compiler put a BUG() in there and let you explode at runtime?  This is 
just absurd, every other arch has done the necessary declarations in their 
own header files and everything works fine because there's a clear config 
dependency on using HPAGE_*.  Adding dummy definitions to panic at runtime 
is irresponsibly to an extreme.
