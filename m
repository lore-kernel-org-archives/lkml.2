Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755637Ab1GMPj4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 11:39:56 -0400
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:20255 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755432Ab1GMPjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 11:39:55 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: F__qHMMVM1l5gAUwoicwiRRw019EwVhduVDD1A5JMxusNSB
 WaSTZX6.YKcxWHdS05YydyTaIez___J_CIi38R75_rmqc3MfywesvrKhHZI4
 XyQIZDNlfYFAZgDg.LRijdJHDps7s81oB2GLlnm_Rc8YJCCgKFRPpV_0qpkW
 v4WLwK1_2TSGvzmFiGZsqXBC2sJXvykK6QmAMQRP24T4AmOO9dJ3pxxscPo9
 D7weCP4famkmKnESPkPAaj7NFN.KY1CFhm00LeD7FJ6ewuHOnAA3grfLdA_n
 hrZk2DaFCewTiHIyDq1g2fZV6y1TzfVr_qnofhOr8kbQncu.tOZbz6OQJHmT
 4JD2F2kLqArC3RTp6_X9QhrYm
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 13 Jul 2011 10:39:52 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Hugh Dickins <hughd@google.com>
cc: Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH next/mmotm] slab: fix DEBUG_SLAB build
In-Reply-To: <alpine.LSU.2.00.1107121349590.1951@sister.anvils>
Message-ID: <alpine.DEB.2.00.1107131037480.29034@router.home>
References: <alpine.LSU.2.00.1107111152290.13035@sister.anvils> <alpine.DEB.2.00.1107121045050.2530@router.home> <alpine.LSU.2.00.1107121349590.1951@sister.anvils>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Jul 2011, Hugh Dickins wrote:

> On Tue, 12 Jul 2011, Christoph Lameter wrote:
> > On Mon, 11 Jul 2011, Hugh Dickins wrote:
> >
> > > -#if ARCH_SLAB_MINALIGN
> > > -	if ((u32)objp & (ARCH_SLAB_MINALIGN-1)) {
> > > +	if ((unsigned long)objp & (ARCH_SLAB_MINALIGN-1)) {
> > >  		printk(KERN_ERR "0x%p: not aligned to ARCH_SLAB_MINALIGN=%d\n",
> >
> > Change %d to %ul for consistencies sake and drop the cast of
> > ARCH_SLAB_MINALIGN?
>
> I don't think we can drop the cast of ARCH_SLAB_MINALIGN, or not without
> a wander through all the architectures: it could well be defined as a bare
> integer in some of them, even if the default definition as __alignof__
> comes out as an unsigned long (which itself surprised me).

A bare integer can be handled by a %lu in a printk without the need for a
cast.

