Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755105Ab2G3T3V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 15:29:21 -0400
Received: from smtp104.prem.mail.ac4.yahoo.com ([76.13.13.43]:33054 "HELO
	smtp104.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754992Ab2G3T3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 15:29:09 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: vhVEctwVM1mGPtHy2Eehos5WHERnBFoHy3WkpZrBmRkNE7Y
 djmmAaTzFA1PDXe09CkOM4GF9Lq6Hj0KEvyN6_D8zcU4Idf4.7y8EliBhgou
 GsKCH2TWcviahsuZb6ieaqYSIYwkRVGtnuJFqzZQ7pnVzX.nT4zKnbmHtxoS
 vc.2.9DFCUdgEMmWRIU9LQtISqzIQ0A5Kaf1dNMrvqssl6ndkGTf9Ao226S8
 .aClMxYUOZtLCUpGPZ8oPBSugPTZ8BY_D4wrOKxjRkLwXhSUX6cCNWFC77Mq
 FpL8Mlmv_qkVgk8l.vnpFiZTmDTqxWOJ6kSbDdkU_xi9OVRIMzVuufbTtlPi
 bEJ.YFpuRx61oZzKBG0RrDWE4JpoeYcKarWsSD8YBae67PgGjpxnXTWjQbZV
 lP.rf.80rWvk2vcz5wYUjIRbGPBrg9HoGvFPdevCb.RqNjMWzPaQ-
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Mon, 30 Jul 2012 14:29:05 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: JoonSoo Kim <js1304@gmail.com>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Brice Goglin <brice@myri.com>,
        Minchan Kim <minchan@kernel.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [RESEND PATCH 4/4 v3] mm: fix possible incorrect return value
 of move_pages() syscall
In-Reply-To: <CAAmzW4MdiJOaZW_b+fz1uYyj0asTCveN=24st4xKymKEvkzdgQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1207301425410.28838@router.home>
References: <1343411703-2720-1-git-send-email-js1304@gmail.com> <1343411703-2720-4-git-send-email-js1304@gmail.com> <alpine.DEB.2.00.1207271550190.25434@router.home> <CAAmzW4MdiJOaZW_b+fz1uYyj0asTCveN=24st4xKymKEvkzdgQ@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Jul 2012, JoonSoo Kim wrote:

> 2012/7/28 Christoph Lameter <cl@linux.com>:
> > On Sat, 28 Jul 2012, Joonsoo Kim wrote:
> >
> >> move_pages() syscall may return success in case that
> >> do_move_page_to_node_array return positive value which means migration failed.
> >
> > Nope. It only means that the migration for some pages has failed. This may
> > still be considered successful for the app if it moves 10000 pages and one
> > failed.
> >
> > This patch would break the move_pages() syscall because an error code
> > return from do_move_pages_to_node_array() will cause the status byte for
> > each page move to not be updated anymore. Application will not be able to
> > tell anymore which pages were successfully moved and which are not.
>
> In case of returning non-zero, valid status is not required according
> to man page.

Cannot find a statement like that in the man page. The return code
description is incorrect. It should that that is returns the number of
pages not moved otherwise an error code (Michael please fix the manpage).

> So, this patch would not break the move_pages() syscall.

It changes the way the system call is behaving right now.

