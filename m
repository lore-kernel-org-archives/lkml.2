Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751480Ab0HVWlA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Aug 2010 18:41:00 -0400
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:33647 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751324Ab0HVWk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Aug 2010 18:40:58 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: nyl21nsVM1mqf2zYpLbl8omJk9qMAmKwradcLQWm2jpLEph
 DeJJi79YNCLS4lhV0jgfahZZtA_qaQbVhoNk60oKwCLVeG.28AsbhpoC19xV
 Ts448m_N455Fx851zj1CVxg6Li81MoZgs5imLKve5eUZILuD6L6YWa3HGo8l
 j7KTbW2buuLw5Or6WXt6iC10EfioLq032qTbSsftILNqF1nsMuNCjKf89lA0
 VVJHJoCdSa6DVfp6JvyS1AhBarGr9
X-Yahoo-Newman-Property: ymail-3
Date: Sun, 22 Aug 2010 17:40:51 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Pekka Enberg <penberg@kernel.org>
cc: Mikael Abrahamsson <swmike@swm.pp.se>,
        Stan Hoeppner <stan@hardwarefreak.com>,
        Linux Kernel List <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Mel Gorman <mel@csn.ul.ie>
Subject: Re: 2.6.34.1 page allocation failure
In-Reply-To: <AANLkTin48SJ58HvFqjrOnQBMqLcbECtqXokweV00dNgv@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1008221734410.21916@router.home>
References: <4C70BFF3.8030507@hardwarefreak.com> <alpine.DEB.1.10.1008220842400.8562@uplift.swm.pp.se> <AANLkTin48SJ58HvFqjrOnQBMqLcbECtqXokweV00dNgv@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Aug 2010, Pekka Enberg wrote:

> In Stan's case, it's a order-1 GFP_ATOMIC allocation but there are
> only order-0 pages available. Mel, any recent page allocator fixes in
> 2.6.35 or 2.6.36-rc1 that Stan/Mikael should test?

This is the TCP slab? Best fix would be in the page allocator. However,
in this particular case the slub allocator would be able to fall back to
an order 0 allocation and still satisfy the request.


