Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755605Ab0IPR4L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 13:56:11 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:57375 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754202Ab0IPR4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 13:56:10 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 04/12] BKL: Remove BKL from autofs4
Date: Thu, 16 Sep 2010 19:55:48 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc3-next-20100910+; KDE/4.5.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Ian Kent <raven@themaw.net>,
        autofs@linux.kernel.org
References: <1284659185-8942-1-git-send-email-arnd@arndb.de> <1284659185-8942-5-git-send-email-arnd@arndb.de> <4C9258C1.3060906@zytor.com>
In-Reply-To: <4C9258C1.3060906@zytor.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201009161955.48854.arnd@arndb.de>
X-Provags-ID: V02:K0:QDHS6XA4OaEqXWW0FwfQ65ZYcBJyUqeFyDM6okFymPE
 VvqPoJpiW28OcbOfXKHdn0BaUDTYLiIlaRKImr8f2HOmsn0/oS
 WFhIv8miKqF6BpuOhUqDIimANQ9flnTflh6JdmAjk6xwEulspe
 mrUkAU12ZWzR7hOcU/0Rm/1FXCO8NPxDi9aFhC2eaLeKirC2l9
 tskHSfjlw0rFh9mMbIGLg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 16 September 2010 19:49:53 H. Peter Anvin wrote:
> On 09/16/2010 10:46 AM, Arnd Bergmann wrote:
> > autofs4 uses the BKL only to guard its ioctl operations.
> > This can be trivially converted to use a mutex, as we have
> > done with most device drivers before.
> > 
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > Cc: "H. Peter Anvin" <hpa@zytor.com>
> > ---
> >  fs/autofs4/root.c |   12 +++++++-----
> >  1 files changed, 7 insertions(+), 5 deletions(-)
> 
> You may want to Cc: the maintainer, Ian Kent.

Ah, sorry about this. I looked at the wrong MAINTAINERS entry.

I also forgot to Cc you about autofs3, adding more to the confusion. ;)

Do you think the time has come to move autofs3 to drivers/staging
as we deprecate the BKL?

	Arnd
