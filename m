Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754500Ab0HIS7i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 14:59:38 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:52854 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547Ab0HIS7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 14:59:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=n/qGu8vHwV3i2h7L+0dtmLuV3D3YF3pFhDK+XSBdPJGaB5HQ7DbTQEOduP1k1dnkwx
         6kh1gNoYaZRpU7ygll2d3AyXARpltGKYgi0ftpIFZk6s1fL2WOgvdhPLh6ygWbqZqv+y
         MBK28kRComMSjTggq2PS89XRxya9jNjwf19J8=
MIME-Version: 1.0
In-Reply-To: <1281374816-904-6-git-send-email-ngupta@vflare.org>
References: <1281374816-904-1-git-send-email-ngupta@vflare.org>
	<1281374816-904-6-git-send-email-ngupta@vflare.org>
Date: Mon, 9 Aug 2010 21:59:30 +0300
X-Google-Sender-Auth: QLKk92QxhJbqF0HXTIyoOPHTvag
Message-ID: <AANLkTikERp9DOpK=1R_UdjuNrS6dbAkX+Q5kysgVcv0k@mail.gmail.com>
Subject: Re: [PATCH 05/10] Reduce per table entry overhead by 4 bytes
From: Pekka Enberg <penberg@kernel.org>
To: Nitin Gupta <ngupta@vflare.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Minchan Kim <minchan.kim@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Linux Driver Project <devel@driverdev.osuosl.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 9, 2010 at 8:26 PM, Nitin Gupta <ngupta@vflare.org> wrote:
> Each zram device maintains an array (table) that maps
> index within the device to the location of corresponding
> compressed chunk. Currently we store 'struct page' pointer,
> offset with page and various flags separately which takes
> 12 bytes per table entry. Now all these are encoded in a
> single 'phys_add_t' value which results in savings of 4 bytes
> per entry (except on PAE systems).
>
> Unfortunately, cleanups related to some variable renames
> were mixed in this patch. So, please bear some additional
> noise.

The noise makes this patch pretty difficult to review properly. Care
to spilt the patch into two pieces?
