Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754105Ab1BJNTA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 08:19:00 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:57176 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147Ab1BJNS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 08:18:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=SNPkZ556eOiqj5p1FN//nOBLavcN6rZbNz1uiYGv1AyozxHXlL6Ztbx8SD/gMlffKt
         BpYeLuJ6cVwaoj3KFkMUPPk3dpDIYbLcBs04rl6HuGpi36qTH9ezlZO1rnBJwbVcU6hS
         YUX7CQZwY+W3xZXxZ3sL+Er+ThJh9KEeEK+no=
Subject: Re: [RFC PATCH] mm: handle simple case in free_pcppages_bulk()
From: Namhyung Kim <namhyung@gmail.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <AANLkTikEigbPsNMqqkmixYbCfD7Dz12YMcW2+GZbhUQq@mail.gmail.com>
References: <1297338408-3590-1-git-send-email-namhyung@gmail.com>
	 <AANLkTikEigbPsNMqqkmixYbCfD7Dz12YMcW2+GZbhUQq@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 10 Feb 2011 22:18:49 +0900
Message-ID: <1297343929.1449.3.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011-02-10 (목), 22:10 +0900, Minchan Kim:
> Hello Namhyung,
> 

Hi Minchan,


> On Thu, Feb 10, 2011 at 8:46 PM, Namhyung Kim <namhyung@gmail.com> wrote:
> > Now I'm seeing that there are some cases to free all pages in a
> > pcp lists. In that case, just frees all pages in the lists instead
> > of being bothered with round-robin lists traversal.
> 
> I though about that but I didn't send the patch.
> That's because many cases which calls free_pcppages_bulk(,
> pcp->count,..) are slow path so it adds comparison overhead on fast
> path while it loses the effectiveness in slow path.
> 

Hmm.. How about adding unlikely() then? Doesn't it help much here?


-- 
Regards,
Namhyung Kim


