Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751199Ab2BHJE7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 04:04:59 -0500
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:50323 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049Ab2BHJEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 04:04:54 -0500
Date: Wed, 8 Feb 2012 10:04:45 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, <linux390@de.ibm.com>
Subject: Re: [PATCH 16/21] s390: Use generic posix_types.h
Message-ID: <20120208100445.2e527a4e@de.ibm.com>
In-Reply-To: <1328677745-20121-17-git-send-email-hpa@zytor.com>
References: <1328677745-20121-1-git-send-email-hpa@zytor.com>
	<1328677745-20121-17-git-send-email-hpa@zytor.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
x-cbid: 12020809-2966-0000-0000-0000032873AE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  7 Feb 2012 21:09:00 -0800
"H. Peter Anvin" <hpa@zytor.com> wrote:

> From: "H. Peter Anvin" <hpa@zytor.com>
> 
> Change the s390 architecture to use <asm-generic/posix_types.h>.
> 
> Signed-off-by: H. Peter Anvin <hpa@zytor.com>
> Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
> Cc: <linux390@de.ibm.com>
> ---
>  arch/s390/include/asm/posix_types.h |   70 +++++------------------------------
>  1 files changed, 10 insertions(+), 60 deletions(-)

I carefully checked the conversion and came to the conclusion that the new type
definitions are equivalent to the old ones. The code compiles fine with the
patches applied and the kernel boots.
What I don't like is the conversion of __FD_ZERO. The new definition creates
this code sequence:

   0:   a7 19 00 00             lghi    %r1,0
   4:   e3 10 20 00 00 24       stg     %r1,0(%r2)
   a:   e3 10 20 08 00 24       stg     %r1,8(%r2)
  10:   e3 10 20 10 00 24       stg     %r1,16(%r2)
  16:   e3 10 20 18 00 24       stg     %r1,24(%r2)
  1c:   e3 10 20 20 00 24       stg     %r1,32(%r2)
  22:   e3 10 20 28 00 24       stg     %r1,40(%r2)
  28:   e3 10 20 30 00 24       stg     %r1,48(%r2)
  2e:   e3 10 20 38 00 24       stg     %r1,56(%r2)
  34:   e3 10 20 40 00 24       stg     %r1,64(%r2)
  3a:   e3 10 20 48 00 24       stg     %r1,72(%r2)
  40:   e3 10 20 50 00 24       stg     %r1,80(%r2)
  46:   e3 10 20 58 00 24       stg     %r1,88(%r2)
  4c:   e3 10 20 60 00 24       stg     %r1,96(%r2)
  52:   e3 10 20 68 00 24       stg     %r1,104(%r2)
  58:   e3 10 20 70 00 24       stg     %r1,112(%r2)
  5e:   e3 10 20 78 00 24       stg     %r1,120(%r2)

the old code used to be just a single instruction:

   0:   d7 7f 20 00 20 00       xc      0(128,%r2),0(%r2)

That is quite a difference in code length. The execution speed should be almost
the same though.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

