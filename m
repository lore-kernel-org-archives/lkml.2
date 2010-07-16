Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751398Ab0GPEeM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 00:34:12 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:41691 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074Ab0GPEeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 00:34:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=iMbrQds7z7bTvCvrcwz7pMZN818//4pb7yEPDj8paETRGDcWleFpHyUPdWAJ2hNQpv
         Yq2s1EzoOw8SPDw3elolGEUurEE+vCdVAE4Bstn+vnfRTZQpnQp2ALFQtKZw5/aCc06V
         jli1O0IC+wyU0f6Cn3hmoUxxSyNNi4N0hl130=
MIME-Version: 1.0
In-Reply-To: <20100716095126.e084dde0.sfr@canb.auug.org.au>
References: <20100716095126.e084dde0.sfr@canb.auug.org.au>
Date: Thu, 15 Jul 2010 23:34:06 -0500
Message-ID: <AANLkTinZwjJDO7DendPYE6-AuysleKIuKgpkysYRTIzE@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the cifs tree
From: Steve French <smfrench@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-cifs-client@lists.samba.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Suresh Jayaraman <sjayaraman@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 15, 2010 at 6:51 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Steve,
>
> After merging the cifs tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
>
> In file included from fs/cifs/cifsfs.c:50:
> fs/cifs/fscache.h:49: error: expected identifier or '(' before '{' token
>
> Caused by commit 07be494ba2f46852ec6d1faab8111f5179cc7bb4 ("cifs: define
> server-level cache index objects and register them").
> CONFIG_CIFS_FSCACHE is not defined in this build.
>
> I have used the cifs tree from next-20100715 for today.

Thx.  I have fixed this in cifs-2.6.git

There were three places where Suresh's fscache patch set for cifs
forgot ifdefs or misdefined the stub function (when fscache support is
turned off).

-- 
Thanks,

Steve
