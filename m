Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757955Ab1EYQbq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 12:31:46 -0400
Received: from smtp105.prem.mail.ac4.yahoo.com ([76.13.13.44]:37495 "HELO
	smtp105.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756630Ab1EYQbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 12:31:45 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: 3MLe8yAVM1lSxdukAX4_.oxCibQu8xsoQwWs3fACB1jnQoj
 zsz3PrwEPSkW3TU7bXSCoMKs39J8QBBu16lW.uK7amTDnKnjPwWucef_b4Rh
 xjRAF6xL2Z5WpsmuyXlwCaEyDnO.ss87kEaUR.3icWYa.4xsZHhscf_QWWnH
 pEIFbp4Q0CQXzz8FS4GkSqgNkmfccPnXhr84kFqVoIaigkwyW_6pOYyHgXkm
 LSmfarvIPb77dngV1YwesleNZVjIApCax7axOhq5JRHx.qY9V5pFGBGMIrzu
 y9GgEn4_UwGU0g9AzAC6.4HPv0UtP6P_8xj5MHEiujyrkZI_f
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 25 May 2011 11:31:42 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        James Morris <jmorris@namei.org>, Pekka Enberg <penberg@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: SLUB regression in current Linus
In-Reply-To: <1306338341.2820.28.camel@edumazet-laptop>
Message-ID: <alpine.DEB.2.00.1105251130200.26118@router.home>
References: <alpine.LRH.2.00.1105242146240.12134@tundra.namei.org>  <alpine.LRH.2.00.1105242204100.12283@tundra.namei.org>  <alpine.DEB.2.00.1105240908100.25760@router.home>  <alpine.LRH.2.00.1105250813290.16922@tundra.namei.org>  <alpine.DEB.2.00.1105250945240.23309@router.home>
  <BANLkTiksf8NJ40twt1nxp6oRAqNv45QeCQ@mail.gmail.com>  <alpine.DEB.2.00.1105251003150.23309@router.home> <1306338341.2820.28.camel@edumazet-laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 May 2011, Eric Dumazet wrote:

> > We always fall back to the slow path in the debug case. So the tid update
> > is useless.
>
> tid change is updated anyway at the end of deactivate_slab()

That too is useless in the debug case since we already disable
interrupts and do not need tid based synchronization.

