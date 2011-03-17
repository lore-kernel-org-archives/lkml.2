Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670Ab1CQPST (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 11:18:19 -0400
Received: from smtp104.prem.mail.ac4.yahoo.com ([76.13.13.43]:47778 "HELO
	smtp104.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752955Ab1CQPSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 11:18:18 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: aM.k.IQVM1m0rm_vHKy4sbiQWXddJTh6ap1NlEhBVkN_TMB
 2Cspx4IUrxTtqoWBQBOinkrmDap17KFWjrruUuurziHSx0hYCWLnAH7Cxj3s
 ZRB6zNktI12._DylAj68Er47GOqTwGmDVVmO2CSCngDWP0CMD4S4o3839Pva
 Rvuka14LyEKyyiWqRPYDKfsIpTZFUGjGKop_r_zS_AoETe19i.oz.aJZWDLV
 ppnV05euD2FJHP3WlQHnUxRZRyMNzXy1uc134488hl4oDbB_2kTYyvLVpP9m
 oQQoNe52I3cm2wm5eMh5SZEVyT5RwciRJsUKX16_5TOzSMsOM
X-Yahoo-Newman-Property: ymail-3
Date: Thu, 17 Mar 2011 10:18:15 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: David Miller <davem@davemloft.net>
cc: eric.dumazet@gmail.com, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Subject: Re: Poll about irqsafe_cpu_add and others
In-Reply-To: <20110317.081420.71114992.davem@davemloft.net>
Message-ID: <alpine.DEB.2.00.1103171016270.12540@router.home>
References: <1300371834.6315.93.camel@edumazet-laptop> <20110317.081420.71114992.davem@davemloft.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Mar 2011, David Miller wrote:

>
> I had been meaning to bring this up from another perspective.
>
> In networking, we often only ever access objects in base or
> BH context.  Therefore in BH context cases we can do just
> normal counter bumps without any of the special atomic or
> IRQ disabling code at all.

We have the __ functions for that purpose. __this_cpu_inc f.e. falls back
to a simply ++ operation if the arch cannot provide something better.
irqsafe_xx are only used if the context does not provide any protection
and if there is the potential of the counter being incremented from an
interrupt context.

