Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693Ab2L1AeH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 19:34:07 -0500
Received: from mail-bk0-f44.google.com ([209.85.214.44]:37505 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236Ab2L1AeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 19:34:05 -0500
MIME-Version: 1.0
In-Reply-To: <20121227185126.GA10207@x1.alien8.de>
References: <20121227185126.GA10207@x1.alien8.de>
Date: Thu, 27 Dec 2012 16:34:03 -0800
X-Google-Sender-Auth: uJBXbIaGO9CKbB57jsru4FgLOuw
Message-ID: <CAE9FiQWekAOMedzr8Pj3d2O1g3KrN_Fd4F_D4SGz=gOTBZF8sA@mail.gmail.com>
Subject: Re: [PATCH] x86, mm: add generic kernel/ident mapping helper
From: Yinghai Lu <yinghai@kernel.org>
To: Borislav Petkov <bp@alien8.de>, Yinghai Lu <yinghai@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 27, 2012 at 10:51 AM, Borislav Petkov <bp@alien8.de> wrote:
>> +struct mapping_info {
>> +     void *(*alloc)(void *);
>
>                 alloc_page

alloc_page make me feel that it will return struct page *.

>
>> +     void *data;
>> +     unsigned long flag;
>
>                 page_flags;

will change to pmd_flags

>
>> +     bool kernel;
>
>         kernel_space?

that is used to tell: if it is kernel mapping or ident mapping.

will change to is_kernel_mapping or kernel_mapping instead

>
> In general, all those members could use more meaningful names and some
> commenting explaining what they are, instead of people having to deduce
> what they mean from their usage in the code.
>
> Also, struct name 'mapping_info' is too generic. Maybe
> ident_mapping_info?

do you like to name it with kernel_ident_mapping_info ?

looks too long.
