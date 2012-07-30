Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755128Ab2G3Tak (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 15:30:40 -0400
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:36869 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754553Ab2G3Tai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 15:30:38 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: ah9AV4kVM1ng04lJlR7ZqXpPd0OH70vdAVMeIZJnIhrxylf
 nfECj_wFdcEd5rH5wKv9igiJFfRWOmEf_Bq2zNYfPfMP9UUJ8YXSPjx0wbdg
 yYfaCIlZ1duaDgmWn4q1WGtCxq8VlBjKSUw_dhzf.WIZnXLvr8Cd5IFjl_o_
 ffE1Dedz9xCtxw2DzkCSR8B9Gu.baaGdk3Pt0WSrSCsqqMimtif5ZvArwG4k
 NF0ZAFpjj5CrqsFEvQeIZdvsj1g7iBeRI8w6Y2SR2KCTQnHUk3S.hDna1rsA
 zTGWFAFhoi2Pjl2n50Wig_fhfBzlCpFvCngGoePutg8iE6Vfu0Q2hoe.7QcH
 0C_WORsWUPiCHxCmq2Lz9Ck_KUBh41gdPKvynoemM4bMYMxOd7zAVQDXMp9H
 dRLbFo89hoMaB0NtCB8Xii74I2AbS7SrqYsidbM7ORFU07I68UV8-
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Mon, 30 Jul 2012 14:30:35 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: JoonSoo Kim <js1304@gmail.com>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Sasha Levin <levinsasha928@gmail.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [RESEND PATCH 2/4 v3] mm: fix possible incorrect return value
 of migrate_pages() syscall
In-Reply-To: <CAAmzW4O04LZim-DZQ5JYEEpBL89Tts_OjRqbRKB2AAdE17O7HQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1207301429500.28838@router.home>
References: <1343411703-2720-1-git-send-email-js1304@gmail.com> <1343411703-2720-2-git-send-email-js1304@gmail.com> <alpine.DEB.2.00.1207271554480.25434@router.home> <CAAmzW4O04LZim-DZQ5JYEEpBL89Tts_OjRqbRKB2AAdE17O7HQ@mail.gmail.com>
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
> >> do_migrate_pages() can return the number of pages not migrated.
> >> Because migrate_pages() syscall return this value directly,
> >> migrate_pages() syscall may return the number of pages not migrated.
> >> In fail case in migrate_pages() syscall, we should return error value.
> >> So change err to -EBUSY
> >
> > Lets leave this alone. This would change the migrate_pages semantics
> > because a successful move of N out of M pages would be marked as a
> > total failure although pages were in fact moved.
> >
>
> Okay.
> Then, do we need to fix man-page of migrate_pages() syscall?
> According to man-page, only returning 0 or -1 is valid.
> Without this patch, it can return positive value.

Yes the manpage needs updating to say that it can return the number of
pages not migrated.

