Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451Ab0JERTT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 13:19:19 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:65263 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754425Ab0JERTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 13:19:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=BpwvEF5blxjIbbzP6ZGkpzAG/YGET3RGctmBtmh77/8OU0GNV7ZKsZv14HUSCEppxz
         VeOAQ+5i6Uwvr/yoowexhpk+xPt5o2sZ5bVAiDGoD3ruq0QEqtxH0lChfrHNmvCLq8+3
         WbzyV+ApPibsNfSofFDmt8URgOBoSCmK8QsGY=
Date: Tue, 5 Oct 2010 20:19:11 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: jovi zhang <bookjovi@gmail.com>
Cc: andre.goddard@gmail.com, hedi@sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pid: remove unused include
Message-ID: <20101005171911.GA6075@core2.telecom.by>
References: <AANLkTikcRppGD592yth-xaea961OczDhXX1Hj+qQ6fJH@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikcRppGD592yth-xaea961OczDhXX1Hj+qQ6fJH@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 05, 2010 at 07:20:26PM +0800, jovi zhang wrote:
> remove unused include of pid.c

> --- a/kernel/pid.c
> +++ b/kernel/pid.c
> @@ -27,15 +27,12 @@
>  */
> 
> #include <linux/mm.h>
> -#include <linux/module.h>

This one is needed for EXPORT_SYMBOL_GPL.

> -#include <linux/slab.h>


This one is for kzalloc()

> #include <linux/init.h>
> #include <linux/rculist.h>
> #include <linux/bootmem.h>
> #include <linux/hash.h>
> #include <linux/pid_namespace.h>
> #include <linux/init_task.h>
> -#include <linux/syscalls.h>

This one can go, sys_wait4() usage was removed.
Have you checked compilation?
