Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755721Ab1JNRRE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 13:17:04 -0400
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:45880 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752733Ab1JNRRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 13:17:01 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: .Onmi2EVM1nYWmaGs_PG9ljLeCAaOpKaIMnotrcoD2NR2W7
 P6wOc_6_uI30g7iKIMV6SvA5OgWVvQG5M97ZtduTvEJKKV47Q__GRWoR0IvS
 7YoKBjNazmi0jFaQyPb5Gjr8.NzPVADEH5W7JROPa9p8UPSGuFSZFQoQy1oP
 Htyle3O7yR1p4STwuESrsJSCJs9YERhMbP2v7FgEeNq6UBb.lp1FqVtcDVmr
 __bynyHLMkqMO1i55nXpTZAoqMjE0L.xaEzNv255z5tenriuZcSGS5WXZeJP
 PZt1Bu4PlR84zPb6UVd9.BZH0I84hsXm2dS2I_YWFn31iNA9aECsORs2XTeF
 aIoF3QUXmudOeUSHhoeQk2rPIJBTXwyx6yeQFYwzLGN.Ls7w-
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Fri, 14 Oct 2011 12:16:58 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
X-X-Sender: cl@router.home
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [slabinfo PATCH] Fix off-by-one after readlink() call
In-Reply-To: <4E9869B4.6080702@intra2net.com>
Message-ID: <alpine.DEB.2.00.1110141214270.6411@router.home>
References: <4E9869B4.6080702@intra2net.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Oct 2011, Thomas Jarosch wrote:

> index 868cc93..cc1a378 100644
> --- a/tools/slub/slabinfo.c
> +++ b/tools/slub/slabinfo.c
> @@ -1145,7 +1145,7 @@ static void read_slab_dir(void)
>  		switch (de->d_type) {
>  		   case DT_LNK:
>  			alias->name = strdup(de->d_name);
> -			count = readlink(de->d_name, buffer, sizeof(buffer));
> +			count = readlink(de->d_name, buffer, sizeof(buffer)-1);
>

readlink required that the buffer size be specified.

READLINK(2)                                              Linux Programmer's Manual                                              READLINK(2)

NAME
       readlink - read value of a symbolic link

SYNOPSIS
       #include <unistd.h>

       ssize_t readlink(const char *path, char *buf, size_t bufsiz);

   Feature Test Macro Requirements for glibc (see feature_test_macros(7)):

       readlink(): _BSD_SOURCE || _XOPEN_SOURCE >= 500 || _POSIX_C_SOURCE >= 200112L

DESCRIPTION
       readlink()  places  the  contents  of the symbolic link path in the buffer buf, which has size bufsiz.  readlink() does not append a
       null byte to buf.  It will truncate the contents (to a length of bufsiz characters), in case the buffer is too small to hold all  of
       the contents.


