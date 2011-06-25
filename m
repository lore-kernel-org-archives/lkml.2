Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751902Ab1FYOX7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jun 2011 10:23:59 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:62624 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452Ab1FYOX5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jun 2011 10:23:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=XrgHEg9YUyd+GDcZ12pQCpjShScAuL8jRVCbjBDMzr1XTGIAZg7RxZvSDgSGZZTWFo
         ZXrwvKIDn0GFytIzSYFtFyNn2xQtMytEULwRfg7CGsfJRoZ4ueWEmvIzgteXmnCgl9ho
         a2CZLAknvGHA0D2Nz5nUPNtKgLw8X6C2Sul8I=
MIME-Version: 1.0
In-Reply-To: <1308926697-22475-1-git-send-email-mgorman@suse.de>
References: <1308926697-22475-1-git-send-email-mgorman@suse.de>
From: Andrew Lutomirski <luto@mit.edu>
Date: Sat, 25 Jun 2011 08:23:37 -0600
X-Google-Sender-Auth: QrzDJ1fXfdgbjlpG6zPx4kIZt2E
Message-ID: <BANLkTintLEcJvNzzspYRUV8fCx9=9dGDnA@mail.gmail.com>
Subject: Re: [PATCH 0/4] Stop kswapd consuming 100% CPU when highest zone is small
To: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigbrady.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Colin King <colin.king@canonical.com>,
        Minchan Kim <minchan.kim@gmail.com>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 24, 2011 at 8:44 AM, Mel Gorman <mgorman@suse.de> wrote:
> (Built this time and passed a basic sniff-test.)
>
> During allocator-intensive workloads, kswapd will be woken frequently
> causing free memory to oscillate between the high and min watermark.
> This is expected behaviour.  Unfortunately, if the highest zone is
> small, a problem occurs.
>

[...]

I've been running these for a couple days with no problems, although I
haven't been trying to reproduce the problem.  (Well, no problems
related to memory management.)

I suspect that my pet unnecessary-OOM-kill bug is still around, but
that's probably not related, especially since I can trigger it if I
stick 8 GB of RAM in this laptop.

Thanks,
Andy
