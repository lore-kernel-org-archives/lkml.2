Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758090Ab2EOOEH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 10:04:07 -0400
Received: from smtp104.prem.mail.ac4.yahoo.com ([76.13.13.43]:32148 "HELO
	smtp104.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755969Ab2EOOEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 10:04:05 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: bdIJqRQVM1kRp9BYEfZKXzGIBIZvxJkDiyBbySku09ZE6T2
 OW6bC3Qe.MCd2dq7G9T3Iw2a8nCpOdaOJDOLq7hU1lxUwk1_RLTzWJqbG3Oq
 JJfS7r5tt0zwbsbdCJOPWNEddkeCFLE7lgtYLfKsfBKOSUvcL53rMoLMTxdJ
 IKm_5TiWy5RLKWOmAXlAInqCBj8DGyrMf3BXBQvJBZ96IgKQOk3pVNgyXC9d
 NvsLhPQJB1Zu7c2Xp7piwmbPfb4rkW.LpRKjbJ7IlW9RNH_7QgBeeASZQ1yu
 kaEq9M0fFs9ymxsh5SiMZhqVIrz7MyivGgSEapIonM2Dta3q7Nn_Vu7SrdDJ
 BSbAfUOcL8RPrW3AkipMGxK0YvDb3RNYJ1NtpZ6am8JHqavVGW4EKYuwX4IX
 zLWnTU8srbC870oWAD_gsNAcB5szs1dp2TG7c
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 15 May 2012 09:04:01 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: Pravin B Shelar <pshelar@nicira.com>, penberg@kernel.org, mpm@selenic.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, jesse@nicira.com,
        abhide@nicira.com
Subject: Re: [PATCH v2] mm: Fix slab->page _count corruption.
In-Reply-To: <1337034892.8512.652.camel@edumazet-glaptop>
Message-ID: <alpine.DEB.2.00.1205150903320.6488@router.home>
References: <1337034597-1826-1-git-send-email-pshelar@nicira.com> <1337034892.8512.652.camel@edumazet-glaptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 May 2012, Eric Dumazet wrote:

> > Following patch fixes it by moving page->_count out of cmpxchg_double
> > data. So that slub does no change it while updating slub meta-data in
> > struct page.
>
> I say again : Page is owned by slub, so get_page() or put_page() is not
> allowed ?

It is allowed since slab memory can be used for DMA.

> How is put_page() going to work with order-1 or order-2 allocations ?

It is always incrementing the page count of the head page.
