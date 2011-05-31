Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756637Ab1EaOaa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 10:30:30 -0400
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:34706 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754134Ab1EaOaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 10:30:24 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: OlcIi4EVM1mtblSWc5M0e4Ho8nGS2XFKlPA54LZh8F..G0P
 ccMHEg82d48C.Pu_n3ttzH.Tg1DPqFsSZyECQPoxNkHmuNmrRGPGoRuawO6S
 oFEz9J3mKjjsg.htQmlL7HVyjHzJxnBUPe7CMA6unz2BfoFjbuGNVrq9TlkT
 kijTLyEWgfnR5Qu.NLSsw9J8ln0vxCD_nGpsOVjRnVz9_W_4BtRk6nnI3LNh
 Dtg3WjddkWdMsKH50y2vH7oD_fGPOE0QzgLAYy3bf7qLB5luzix4b1Uxxtrd
 0Ff2_VI.Gy9R7Omwfdgio2QEk4yz17KSmYGuEaSM_XXyvK6ycAZB2_Dnj6_h
 H_eiMXVt_kSvTZ0SP1bR6vvvs
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 31 May 2011 09:30:21 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Richard Weinberger <richard@nod.at>
cc: linux-kernel@vger.kernel.org, penberg@kernel.org
Subject: Re: slub: UML and CONFIG_CMPXCHG_LOCAL
In-Reply-To: <201105292225.46544.richard@nod.at>
Message-ID: <alpine.DEB.2.00.1105310929230.18004@router.home>
References: <201105292225.46544.richard@nod.at>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 May 2011, Richard Weinberger wrote:

> With commit 1759415e you've removed all #ifdef CONFIG_CMPXCHG_LOCAL's from slub.
> This change breaks slub (again) on UML.
> UML does not implement this_cpu_cmpxchg16b_emu().

It does not have to implement it. The this_cpu_ops can fall back to
generic implementations.

> Is there anything I can do to have slub on UML?

Yes, rely on the generic implementation of this_cpu_cmpxchg.
