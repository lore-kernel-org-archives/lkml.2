Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752290Ab2G1GQa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2012 02:16:30 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:43420 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719Ab2G1GQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2012 02:16:29 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1207271554480.25434@router.home>
References: <1343411703-2720-1-git-send-email-js1304@gmail.com>
	<1343411703-2720-2-git-send-email-js1304@gmail.com>
	<alpine.DEB.2.00.1207271554480.25434@router.home>
Date: Sat, 28 Jul 2012 15:16:28 +0900
Message-ID: <CAAmzW4O04LZim-DZQ5JYEEpBL89Tts_OjRqbRKB2AAdE17O7HQ@mail.gmail.com>
Subject: Re: [RESEND PATCH 2/4 v3] mm: fix possible incorrect return value of
 migrate_pages() syscall
From: JoonSoo Kim <js1304@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Sasha Levin <levinsasha928@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/7/28 Christoph Lameter <cl@linux.com>:
> On Sat, 28 Jul 2012, Joonsoo Kim wrote:
>
>> do_migrate_pages() can return the number of pages not migrated.
>> Because migrate_pages() syscall return this value directly,
>> migrate_pages() syscall may return the number of pages not migrated.
>> In fail case in migrate_pages() syscall, we should return error value.
>> So change err to -EBUSY
>
> Lets leave this alone. This would change the migrate_pages semantics
> because a successful move of N out of M pages would be marked as a
> total failure although pages were in fact moved.
>

Okay.
Then, do we need to fix man-page of migrate_pages() syscall?
According to man-page, only returning 0 or -1 is valid.
Without this patch, it can return positive value.
