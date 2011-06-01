Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932132Ab1FASvj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 14:51:39 -0400
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:43543 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755702Ab1FASvi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 14:51:38 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=B6H7B9H5UQZmCzx3o8+YyuG5DPUsjC25QhivSrAnOejvN7P2+NV8o+eln1c3ch3s27ent6UJNw4OcwX81CCTjJrBXC7Byxl/uUZ6sxYn8mFwwGvaS6xvmEo24Y4ynTT8;
Date: Wed, 1 Jun 2011 11:51:15 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: =?ISO-8859-1?B?TultZXRoIE3hcnRvbg==?= <nm127@freemail.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Bjorn Helgaas <bjorn.helgaas@hp.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Julia Lawall <julia@diku.dk>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86 pci acpi: fix type mismatch
Message-ID: <20110601115115.214427ca@jbarnes-desktop>
In-Reply-To: <4DCEBB85.8040709@freemail.hu>
References: <4DCEBB85.8040709@freemail.hu>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 14 May 2011 19:27:33 +0200
Németh Márton <nm127@freemail.hu> wrote:

> From: Márton Németh <nm127@freemail.hu>
> 
> The flags field of struct resource from linux/ioport.h is "unsigned long". Change
> the "type" parameter of coalesce_windows() function to match that field. This fixes
> the following warning messages when compiling with "make C=1 W=1 bzImage modules":
> 
> arch/x86/pci/acpi.c: In function ‘coalesce_windows’:
> arch/x86/pci/acpi.c:198: warning: conversion to ‘long unsigned int’ from ‘int’ may change the sign of the result
> arch/x86/pci/acpi.c:203: warning: conversion to ‘long unsigned int’ from ‘int’ may change the sign of the result
> 
> Signed-off-by: Márton Németh <nm127@freemail.hu>
> ---
> --- linux-2.6.39-rc6/arch/x86/pci/acpi.c.orig	2011-05-04 04:59:13.000000000 +0200
> +++ linux-2.6.39-rc6/arch/x86/pci/acpi.c	2011-05-14 19:12:42.000000000 +0200
> @@ -188,7 +188,7 @@ static bool resource_contains(struct res
>  	return false;
>  }
> 
> -static void coalesce_windows(struct pci_root_info *info, int type)
> +static void coalesce_windows(struct pci_root_info *info, unsigned long type)
>  {
>  	int i, j;
>  	struct resource *res1, *res2;

Applied to my for-linus tree, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
