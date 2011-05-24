Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508Ab1EXQ7f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 12:59:35 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:52910 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222Ab1EXQ7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 12:59:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=IVosRS+PL5dR7f9pEXXECnUyG3OdXN3VU5zZ7LnhG9RHTWYc1SziMzlvnLQlOs9LDL
         /YaUkDRj6uRYFzz53l7e9D3StZrlyxDdma4bb2STTWV09dYV9n2Je9MXi4MAcWqtjwWn
         LMg1c1ytTB/tudIwB7pJ3zWd67m5qzqdlp67E=
MIME-Version: 1.0
In-Reply-To: <1306173085.8687.38.camel@Joe-Laptop>
References: <1306172407.8198.3.camel@localhost.localdomain>
	<1306173085.8687.38.camel@Joe-Laptop>
Date: Tue, 24 May 2011 22:59:33 +0600
Message-ID: <BANLkTikQjH5pdenTNRxyBwegbkRj0vGHLg@mail.gmail.com>
Subject: Re: [PATCH] drivers: Use kzalloc instead of 'kmalloc+memset', where possible.
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/23/11, Joe Perches <joe@perches.com> wrote:
> On Mon, 2011-05-23 at 23:40 +0600, Rakib Mullick wrote:
>> Following patch removes the uses of 'kmalloc+memset' from various
>> drivers subsystems, which is replaced by kzalloc. kzalloc take care of
>> setting allocated memory with null, so it helps to get rid from using
>> memset.
>> diff --git a/drivers/gpu/drm/drm_scatter.c b/drivers/gpu/drm/drm_scatter.c
> []
>> -	entry->pagelist = kmalloc(pages * sizeof(*entry->pagelist), GFP_KERNEL);
>> +	entry->pagelist = kzalloc(pages * sizeof(*entry->pagelist), GFP_KERNEL);
>
> Perhaps it's better to use:
>
> 	entry->pagelist =  kcalloc(pages, sizeof(*entry->pagelist), GFP_KERNEL);
>
>> -	entry->busaddr = kmalloc(pages * sizeof(*entry->busaddr), GFP_KERNEL);
>> +	entry->busaddr = kzalloc(pages * sizeof(*entry->busaddr), GFP_KERNEL);
>
> here too.
>
Is there any significant benefit of using kcalloc here?


Thanks,
Rakib
>
