Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448Ab2GPR0s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 13:26:48 -0400
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:43957 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752051Ab2GPR0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 13:26:46 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: dxObRB4VM1maYnfb94PFypxKkfu1Ug6CLkIpzjC8dm5662o
 NalBtW4OP7k1Z3brsccSpRRirs7iCW6cAX2PjXyhWlGPl2Vcd1Jgg2qJIZ2e
 NRczX_l2sPnZvzT4xLh.ZK_OxXIGF.lVk0QXA9PuAkPxZrgzUbeinbuR5mqR
 YMCpSn6uaDxjLcEMEhVuLLFHioSQL3yndQhMWYEbmgDD81T1f0A7BpjrLWdn
 o1g.qt7iC8eqXcvJHnezaxco6VwBsfccYX_NkISOYTvpBpujuMeK0nR3.Ezy
 eWaGXb1DjNpPN0UWO.g97o7w_rvcK5h3LCQLnmheJ2Da6tMy8mJBaGgIOUca
 9mcvM.lIRsOtzZsw_miYExevHtLSKE_akb0iqRqwjeuhf_Rn8._cFM3hdJrr
 l
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Mon, 16 Jul 2012 12:26:41 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Joonsoo Kim <js1304@gmail.com>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Sasha Levin <levinsasha928@gmail.com>
Subject: Re: [PATCH 2/3] mm: fix possible incorrect return value of
 migrate_pages() syscall
In-Reply-To: <1342455272-32703-2-git-send-email-js1304@gmail.com>
Message-ID: <alpine.DEB.2.00.1207161226000.32319@router.home>
References: <Yes> <1342455272-32703-1-git-send-email-js1304@gmail.com> <1342455272-32703-2-git-send-email-js1304@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jul 2012, Joonsoo Kim wrote

> do_migrate_pages() can return the number of pages not migrated.
> Because migrate_pages() syscall return this value directly,
> migrate_pages() syscall may return the number of pages not migrated.
> In fail case in migrate_pages() syscall, we should return error value.
> So change err to -EIO

Pages are not migrated because they are busy not because there is an
error. So lets return EBUSY.
