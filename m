Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752281Ab2G1GJo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2012 02:09:44 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:41401 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952Ab2G1GJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2012 02:09:06 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1207271550190.25434@router.home>
References: <1343411703-2720-1-git-send-email-js1304@gmail.com>
	<1343411703-2720-4-git-send-email-js1304@gmail.com>
	<alpine.DEB.2.00.1207271550190.25434@router.home>
Date: Sat, 28 Jul 2012 15:09:05 +0900
Message-ID: <CAAmzW4MdiJOaZW_b+fz1uYyj0asTCveN=24st4xKymKEvkzdgQ@mail.gmail.com>
Subject: Re: [RESEND PATCH 4/4 v3] mm: fix possible incorrect return value of
 move_pages() syscall
From: JoonSoo Kim <js1304@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Brice Goglin <brice@myri.com>,
        Minchan Kim <minchan@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/7/28 Christoph Lameter <cl@linux.com>:
> On Sat, 28 Jul 2012, Joonsoo Kim wrote:
>
>> move_pages() syscall may return success in case that
>> do_move_page_to_node_array return positive value which means migration failed.
>
> Nope. It only means that the migration for some pages has failed. This may
> still be considered successful for the app if it moves 10000 pages and one
> failed.
>
> This patch would break the move_pages() syscall because an error code
> return from do_move_pages_to_node_array() will cause the status byte for
> each page move to not be updated anymore. Application will not be able to
> tell anymore which pages were successfully moved and which are not.

In case of returning non-zero, valid status is not required according
to man page.
So, this patch would not break the move_pages() syscall.
But, I agree that returning positive value only means that the
migration for some pages has failed.
This is my mistake, so please drop this patch.
Thanks for review.
