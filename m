Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751855Ab0KWEc3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 23:32:29 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:50411 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725Ab0KWEc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 23:32:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=JoMFCLuwE9nAW+ULWkrX4mxz0Q4LPKh0IYLwZKRDTzkBDqxrv6C1fTXqQ8QTDDSGoM
         xj+NGrCcR0dhPpLyf1WhVPE0miS/FNUazYBfcATbOuW0vzAamOTjcIO3hLb2vZNRAhQb
         X7hxyXChVqI0vKnqAZNyLQf3fQriPsCJNyXLY=
Date: Tue, 23 Nov 2010 12:37:10 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Namhyung Kim <namhyung@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scripts: Fix gfp-translate for recent changes to gfp.h
Message-ID: <20101123043710.GA5187@cr0.nay.redhat.com>
References: <20101122120002.GB1890@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101122120002.GB1890@csn.ul.ie>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 22, 2010 at 12:00:02PM +0000, Mel Gorman wrote:
>The recent changes to gfp.h to satisfy sparse broke
>scripts/gfp-translate. This patch fixes it up to work with old and new
>versions of gfp.h .
>
>Signed-off-by: Mel Gorman <mel@csn.ul.ie>
>---
> scripts/gfp-translate |    7 ++++++-
> 1 files changed, 6 insertions(+), 1 deletions(-)
>
>diff --git a/scripts/gfp-translate b/scripts/gfp-translate
>index d81b968..128937e 100644
>--- a/scripts/gfp-translate
>+++ b/scripts/gfp-translate
>@@ -63,7 +63,12 @@ fi
> 
> # Extract GFP flags from the kernel source
> TMPFILE=`mktemp -t gfptranslate-XXXXXX` || exit 1
>-grep "^#define __GFP" $SOURCE/include/linux/gfp.h | sed -e 's/(__force gfp_t)//' | sed -e 's/u)/)/' | grep -v GFP_BITS | sed -e 's/)\//) \//' > $TMPFILE
>+grep ___GFP $SOURCE/include/linux/gfp.h > /dev/null

You might want 'grep -q'. :)


>+if [ $? -eq 0 ]; then
>+	grep "^#define ___GFP" $SOURCE/include/linux/gfp.h | sed -e 's/u$//' | grep -v GFP_BITS > $TMPFILE
>+else
>+	grep "^#define __GFP" $SOURCE/include/linux/gfp.h | sed -e 's/(__force gfp_t)//' | sed -e 's/u)/)/' | grep -v GFP_BITS | sed -e 's/)\//) \//' > $TMPFILE
>+fi
> 
> # Parse the flags
> IFS="

Other than that, this patch looks fine for me.

Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>

Thanks.
