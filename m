Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752869Ab1COD1h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 23:27:37 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:61748 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721Ab1COD1g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 23:27:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=td5CKbjOhgMdHvxOSXJa4gWQ81YuZ8y+sqWM17Gu1qLpiRaT9WfDim5is/o+a5oSJv
         azuJxL2ai+PudjA9e73CttiQ4CruKq4Aj75RycNSGJ8sp3/wIkDUCG9Ui0dUOYmGDuhe
         /93/0HnMfOBmChTF3YHu/M7edmvGQMWokplGc=
MIME-Version: 1.0
In-Reply-To: <20110314153413.a8ec2093.akpm@linux-foundation.org>
References: <AANLkTim-U1nyuQ3cVxLHv63LmQUvOJd5GmR5wF90xG==@mail.gmail.com>
	<20110314153413.a8ec2093.akpm@linux-foundation.org>
Date: Tue, 15 Mar 2011 09:27:35 +0600
Message-ID: <AANLkTik3BGzgO2UB-Yu5Qg+eVj=76cOQoG6g2UBJLjFe@mail.gmail.com>
Subject: Re: [PATCH] fs, coda: Fix compile warning when CONFIG_SYSCTL=n.
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Harkes <jaharkes@cs.cmu.edu>, LKML <linux-kernel@vger.kernel.org>,
        coda@cs.cmu.edu, codalist@telemann.coda.cs.cmu.edu
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 15, 2011 at 4:34 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Sun, 13 Mar 2011 21:48:23 +0600
> Rakib Mullick <rakib.mullick@gmail.com> wrote:
>
> These do/while stubs should not have the trailing ";" - adding them
> will cause breakage in some calling scenarios.
>
I missed that, these stubs are not used by anything. I wasn't sure,
who knows, some random config might  trigger some more warning. So I
kept it.

> It is much better to implement such stubs in C rather than as macros.
>
I'll remember.

> But these stubs can't be doing anything useful anyway: they appear at
> the end of a .c file which wasn't #included by anything.  Therefore:
>
> --- a/fs/coda/sysctl.c~fs-coda-fix-compile-warning-when-config_sysctl=n-fix
> +++ a/fs/coda/sysctl.c
> @@ -61,9 +61,4 @@ void coda_sysctl_clean(void)
>                fs_table_header = NULL;
>        }
>  }
> -#else
> -
> -#define        coda_sysctl_init()              do { }  while (0);
> -#define        coda_sysctl_clean()             do { }  while (0);
> -
>  #endif
> _
>
>
