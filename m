Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936Ab0K2E2y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 23:28:54 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:33041 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754730Ab0K2E2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 23:28:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=mEU4u5cqYCAOa8bRLvzj2hJ1IfuIfs6xNUcLkGZoSR1Vu66cPg6rcrBm/va9/kEQw6
         VKTj7xliecW/6HK2GEcK2uA/GM0SP/1TCXzuWYSyvjAFwK1igk1PGLsw/cmb6j6kR/u0
         ehsAdmgWviSQvwEV+UtH7n/ZOPxOHvTr+xGag=
Date: Sun, 28 Nov 2010 20:13:59 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Pavel Vasilyev <pavel@pavlinux.ru>
Cc: Ming Lei <tom.leiming@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Repalce strncmp by memcmp
Message-ID: <20101129041359.GA6991@core.coreip.homeip.net>
References: <4CF30B46.4000203@pavlinux.ru>
 <AANLkTikjDfyWY=Gy7VkdvEGNnYB9kb_iCqNDP7H9W5z4@mail.gmail.com>
 <4CF319D9.9060102@pavlinux.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CF319D9.9060102@pavlinux.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 29, 2010 at 06:11:21AM +0300, Pavel Vasilyev wrote:
> On 29.11.2010 05:29, Ming Lei wrote:
> > Hi,
> >
> > 2010/11/29 Pavel Vasilyev <pavel@pavlinux.ru>:
> >>    This patch replace all strncmp(a, b, c) by  memcmp(a, b, c).
> >>
> >> I test on x86_64 (AMD Opteron 285).
> > In fact, memcmp doesn't handle case of tail of string, so
> > it is not safe to replace strncmp with memcmp
> >
> #include <stdio.h>
> #include <errno.h>
> 
> int main() {
> 
>    char *STR = "XXXX\0";
>    char *XXX = "XXXX";

Try comparing:

"XXXX\0YYYY" and
"XXXX\0ZZZZ"

and observe the difference.

-- 
Dmitry
