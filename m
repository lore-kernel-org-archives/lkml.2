Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752410Ab2G0U5h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 16:57:37 -0400
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:32335 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751882Ab2G0U5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 16:57:35 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: a9eKEtcVM1mK2KLgiQFR.SRmeegXhngOw5GPh5ytYu66xnw
 29ddtSq3ns_NYeVcMKU8N_V4YfxYmoROzQ.Ql5fU6EG7hcPMwUBFlgiRGgOi
 9xg7rOqNxY3iFnT3_ZfRwrFY9t_2_U7_WRm_MS_4Wz.IobwQNn8RbM9xJu8N
 coteXGsNMvDQihA4vmacUicLI5ZwYBs3tHFYcUgFD_dU3yjZmyW9mWSiOGmz
 mS27MGcIujV4DcFJ_X1_dZmzByE7se3bhWmAmdbgTGkl6x8e3oYx1siqR9FV
 6SBXnjZ5dPZRn8M7dHwz_ZsiO50lRDBwUh9ftLJykSnwCV05p_SC97u9cQLs
 5SX3LyZFxQGwI8jdh08DFtoG1fa_G_Gnj8rCJnDCEGzZEVA2QapHRsi3z9sG
 mpxdUrFElMHHjYW5FXZZafWb8aqHNLyEXP8MBqlRZT89KDOA2HvQ-
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Fri, 27 Jul 2012 15:57:33 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Joonsoo Kim <js1304@gmail.com>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Sasha Levin <levinsasha928@gmail.com>
Subject: Re: [RESEND PATCH 2/4 v3] mm: fix possible incorrect return value
 of migrate_pages() syscall
In-Reply-To: <1343411703-2720-2-git-send-email-js1304@gmail.com>
Message-ID: <alpine.DEB.2.00.1207271554480.25434@router.home>
References: <Yes> <1343411703-2720-1-git-send-email-js1304@gmail.com> <1343411703-2720-2-git-send-email-js1304@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Jul 2012, Joonsoo Kim wrote:

> do_migrate_pages() can return the number of pages not migrated.
> Because migrate_pages() syscall return this value directly,
> migrate_pages() syscall may return the number of pages not migrated.
> In fail case in migrate_pages() syscall, we should return error value.
> So change err to -EBUSY

Lets leave this alone. This would change the migrate_pages semantics
because a successful move of N out of M pages would be marked as a
total failure although pages were in fact moved.

