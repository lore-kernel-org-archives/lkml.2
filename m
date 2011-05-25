Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933052Ab1EYPCs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 11:02:48 -0400
Received: from smtp104.prem.mail.ac4.yahoo.com ([76.13.13.43]:32203 "HELO
	smtp104.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932994Ab1EYPCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 11:02:47 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: XCLA_1oVM1lgbNcwIOHn7q_yEYGJhNvRtUA7Sv1qWvhYt6E
 75mGaKbhhNmQAW5tTiKrpiuq5AK0wn32KpdkIrv3jx3gxMxJXIIVSiPnlAfi
 oGKAPtEjqjCWV9XySSqH1yyUv1KgB85rkK1uzSsMktYopXEbkW6jlK2UZXH9
 pbqsfYpdc72Ir0.bLbTIJhLp8e_6yyM6oXk4N_taG_OcIL9D0LNqOJjn6D3a
 LkzXkG4yThqSqonyxZn.jHXhQTbRM3ffM_AKk2DUXovh51XYFP9p5WcwRP9r
 0DUjYT2xFgB4IhZ_bIAlft2RBJEV.zjoRZNt97XNuRUz.emNs
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 25 May 2011 10:02:45 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Heiko Carstens <heiko.carstens@de.ibm.com>
cc: David Rientjes <rientjes@google.com>, Pekka Enberg <penberg@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 6/6] slab: only define SLAB_CACHE_DMA for
 CONFIG_ZONE_DMA
In-Reply-To: <20110525104952.GD2498@osiris.boeblingen.de.ibm.com>
Message-ID: <alpine.DEB.2.00.1105251001130.23309@router.home>
References: <alpine.DEB.2.00.1105241650230.29780@chino.kir.corp.google.com> <alpine.DEB.2.00.1105241653180.29780@chino.kir.corp.google.com> <20110525104952.GD2498@osiris.boeblingen.de.ibm.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 May 2011, Heiko Carstens wrote:

> Ok, now I see what you want. But please let's don't add an
> #ifdef CONFIG_ZONE_DMA
> to the dasd driver. Instead just re-add ZONE_DMA to 31-bit s390. Everything
> would be in ZONE_DMA again and ZONE_NORMAL would be empty. Doesn't matter
> if we have an additional zone, since 31-bit support isn't important anymore.

ZONE_NORMAL is normal memory. ZONE_DMA is a zone for memory restricted
to a certain range. If you remove a zone then it should be ZONE_DMA. The
core creates additional (and useless logic in you case) if you enable
ZONE_DMA.

