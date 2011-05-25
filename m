Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933077Ab1EYPEJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 11:04:09 -0400
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:31718 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932994Ab1EYPEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 11:04:08 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: k0jixvgVM1kvQE.GgE8OqrGbsrdRGh5lQDSnIDkcyx8.x_S
 4oDkvwOQH43BcJ9rHTrhZTFDpjPc6OWNCgk81tdTz5dbtmfnWbuJp6gYHWre
 utYTsHiIF_AQMHK2h3WGvxI4BVROCrRCg7eGEj8is4d.DX1JZSPm6ilONyuZ
 NVc25JfEVxSBYa_.AoYOAp1wlQ4yMD5WCX9EZyGLrmrvWOFaO.kvHqSj.P3B
 h4cXOHLi6fCy..o1oZOW3Qxn3nDl3pa69ixOXP7_WNMNX8nnd11uLtZUZNJl
 ghseLIV5u3LPj4O3xlyyFzlTZiAZGjmoA1ubR6_CcuorChQaiK2Dxgj_BLjo
 Gr89KfsyogHl8h.xXyKfAQnl2
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 25 May 2011 10:04:05 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: James Morris <jmorris@namei.org>, Pekka Enberg <penberg@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: SLUB regression in current Linus
In-Reply-To: <BANLkTiksf8NJ40twt1nxp6oRAqNv45QeCQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1105251003150.23309@router.home>
References: <alpine.LRH.2.00.1105242146240.12134@tundra.namei.org> <alpine.LRH.2.00.1105242204100.12283@tundra.namei.org> <alpine.DEB.2.00.1105240908100.25760@router.home> <alpine.LRH.2.00.1105250813290.16922@tundra.namei.org> <alpine.DEB.2.00.1105250945240.23309@router.home>
 <BANLkTiksf8NJ40twt1nxp6oRAqNv45QeCQ@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 May 2011, Linus Torvalds wrote:

> On Wed, May 25, 2011 at 7:47 AM, Christoph Lameter <cl@linux.com> wrote:
> >
> > So simply return the object. In the debug case we do not need all the other
> > processing that unlock_out: does.
>
> So that patch looks like it should explain things.
>
> But exactly why don't we need the ->tid update and the ALLOC_SLOWPATH
> stats? Both of them would seem to be equally valid for the debug case.

We always fall back to the slow path in the debug case. So the tid update
is useless.

ALLOC_SLOWPATH would just be incremented for all allocations. Also a
pretty useless thing.

