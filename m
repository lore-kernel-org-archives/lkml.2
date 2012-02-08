Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756980Ab2BHSBY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 13:01:24 -0500
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:33578 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754231Ab2BHSBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 13:01:23 -0500
Date: Wed, 8 Feb 2012 19:01:17 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com
Subject: Re: [PATCH 16/21] s390: Use generic posix_types.h
Message-ID: <20120208190117.430f157b@de.ibm.com>
In-Reply-To: <4F32A8F1.1080001@zytor.com>
References: <1328677745-20121-1-git-send-email-hpa@zytor.com>
	<1328677745-20121-17-git-send-email-hpa@zytor.com>
	<20120208100445.2e527a4e@de.ibm.com>
	<4F32A8F1.1080001@zytor.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
x-cbid: 12020818-3548-0000-0000-000000FC4997
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 08 Feb 2012 08:55:13 -0800
"H. Peter Anvin" <hpa@zytor.com> wrote:

> On 02/08/2012 01:04 AM, Martin Schwidefsky wrote:
> > On Tue,  7 Feb 2012 21:09:00 -0800
> > "H. Peter Anvin" <hpa@zytor.com> wrote:
> > 
> >> From: "H. Peter Anvin" <hpa@zytor.com>
> >>
> >> Change the s390 architecture to use <asm-generic/posix_types.h>.
> >>
> >> Signed-off-by: H. Peter Anvin <hpa@zytor.com>
> >> Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> >> Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
> >> Cc: <linux390@de.ibm.com>
> >> ---
> >>  arch/s390/include/asm/posix_types.h |   70 +++++------------------------------
> >>  1 files changed, 10 insertions(+), 60 deletions(-)
> > 
> > I carefully checked the conversion and came to the conclusion that the new type
> > definitions are equivalent to the old ones. The code compiles fine with the
> > patches applied and the kernel boots.
> > What I don't like is the conversion of __FD_ZERO. The new definition creates
> > this code sequence:
> > 
> 
> It shouldn't matter:
> 
> a. __FD_ZERO seems to actually be unused in the current kernel.
> b. The last patch in the series deletes the generic __FD_ZERO and
>    replaces it with memset().  If there are any magic optimizations an
>    architecture wants to do, they belong in memset().

Ah, cool. In this case:
Acked-by: Martin Schwidefsky <schwidefsky@de.ibm.com>

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

