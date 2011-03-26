Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753761Ab1CZHtc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 03:49:32 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:50686 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752666Ab1CZHtb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 03:49:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=kMgdnQgD0EuzVUFyhAntQOhTvWNrBW9D5L+6YvzX3qn9/FRKVhWOWPkOFoP1DdN7lu
         J8m4OmetotSwjLPu1XtORvYpgI7cMVNQIEFCuBzX0t46m/xyqGJj26rAc0/+MbydwS/A
         xWiXBAN8UcR/vOlZJCiLRwcfUq4fxM5UleYeE=
MIME-Version: 1.0
In-Reply-To: <1300884347-3225-1-git-send-email-tailai.ly@taobao.com>
References: <1300884347-3225-1-git-send-email-tailai.ly@taobao.com>
Date: Sat, 26 Mar 2011 15:49:30 +0800
Message-ID: <AANLkTimaF-MLHpG6JsmR+-EW-hDsVVWFZ2NWFrFHkE5d@mail.gmail.com>
Subject: Re: [PATCH] drivers: Initialize ret to fix build warning in memory_probe_store
From: Liu Yuan <namei.unix@gmail.com>
To: linux-kernel@vger.kernel.org, greg@kroah.com, nfont@austin.ibm.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Nathan Fontenot <nfont@austin.ibm.com>

On Wed, Mar 23, 2011 at 8:45 PM, Liu Yuan  <namei.unix@gmail.com> wrote:
> From: Liu Yuan <tailai.ly@taobao.com>
>
> This fix a build warning in drivers/base/memory.c.
>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Signed-off-by: Liu Yuan <tailai.ly@taobao.com>
> ---
>  drivers/base/memory.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/base/memory.c b/drivers/base/memory.c
> index 3da6a43..f2ac71f 100644
> --- a/drivers/base/memory.c
> +++ b/drivers/base/memory.c
> @@ -387,7 +387,7 @@ memory_probe_store(struct class *class, struct class_attribute *attr,
>  {
>        u64 phys_addr;
>        int nid;
> -       int i, ret;
> +       int i, ret = 0;
>
>        phys_addr = simple_strtoull(buf, NULL, 0);
>
> --
> 1.7.0.4
>
>
