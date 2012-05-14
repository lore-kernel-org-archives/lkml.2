Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757586Ab2ENSxc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 14:53:32 -0400
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:45977 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757449Ab2ENSxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 14:53:31 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: k731qJEVM1kXoDFXrS1kyq_62ePK9JtdQqv1b1iXl9z2tQO
 fYNrSnzT0vkKp9ikDGm7LrTxL_GdLbFExhLfsvcqnCZBILFzlQnx7VgHTELC
 Xvc299iC0RsBwY4eRFRDpXyID6eh4Nu1VOb.wLytP6n0hFBHko7wigLvWHDs
 7wfQEhbjGbyX0x6DNYSDp4hYlhF6x4yv0oplQI7IMIAFbQCkC6eiynjbvuYz
 tYsOG.XtCPcMVhVW8M0WQ2TYPF5hICUp2GMzfY7agqFwVjaub4KH1eUSmGHZ
 TKFAvszDpHpVm1KCxD2roeXwUsVhmeKbh4i.TyUPM2lWX9hMvGEx7hz3hC_E
 3sVvjGXsA3liEaCG7jrTwhfzmWNenNqsZz.QByQ8AFg.sxdlpS4Q7CEiyl6f
 8NdwVXu4aAQPc4J_0aSokJ.Z1ACqsmAoEMlOI
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Mon, 14 May 2012 13:53:27 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Pravin B Shelar <pshelar@nicira.com>
cc: penberg@kernel.org, mpm@selenic.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, jesse@nicira.com, abhide@nicira.com
Subject: Re: [PATCH 1/2] mm: Fix slab->page flags corruption.
In-Reply-To: <1337020877-20087-1-git-send-email-pshelar@nicira.com>
Message-ID: <alpine.DEB.2.00.1205141352440.26304@router.home>
References: <1337020877-20087-1-git-send-email-pshelar@nicira.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 May 2012, Pravin B Shelar wrote:

> Transparent huge pages can change page->flags (PG_compound_lock)
> without taking Slab lock. Since THP can not break slab pages we can
> safely access compound page without taking compound lock.
>
> Specificly this patch fixes race between compound_unlock and slab
> functions which does page-flags update. This can occur when
> get_page/put_page is called on page from slab object.

You need to also get this revbiewed by the THP folks like Andrea &
friends.

Reviewed-by: Christoph Lameter <cl@linux.com>
