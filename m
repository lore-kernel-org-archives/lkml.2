Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759879Ab0ENUJk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 16:09:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64516 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757667Ab0ENUJi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 16:09:38 -0400
Subject: Re: [PATCH 7/10] security/selinux/ss: Use kstrdup
From: Eric Paris <eparis@redhat.com>
To: Julia Lawall <julia@diku.dk>
Cc: Stephen Smalley <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
       Eric Paris <eparis@parisplace.org>,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.1005142130140.28935@ask.diku.dk>
References: <Pine.LNX.4.64.1005142130140.28935@ask.diku.dk>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 May 2010 16:09:28 -0400
Message-ID: <1273867768.2826.30.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-05-14 at 21:30 +0200, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> Use kstrdup when the goal of an allocation is copy a string into the
> allocated region.
> 
> The semantic patch that makes this change is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> expression from,to;
> expression flag,E1,E2;
> statement S;
> @@
> 
> -  to = kmalloc(strlen(from) + 1,flag);
> +  to = kstrdup(from, flag);
>    ... when != \(from = E1 \| to = E1 \)
>    if (to==NULL || ...) S
>    ... when != \(from = E2 \| to = E2 \)
> -  strcpy(to, from);
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>

Acked-by: Eric Paris <eparis@redhat.com>


