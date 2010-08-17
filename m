Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463Ab0HQPOf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 11:14:35 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34815 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052Ab0HQPOe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 11:14:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=RA36lYunR4yArbQTAT7aKJixZTNS7ROkfZFMx6tVUe7NsJgrTTgfXXRJbmdbpYa3Yp
         ziLyeeWXW2FajGdZ4S1uWYAjw7BnbaCpZCTG6nZujRKgisFJXLblCipwrkvWACvvOKHr
         ThwGCbPY2TGgp6vY7eZBm5Q30/rbDn5JJ6aRI=
MIME-Version: 1.0
In-Reply-To: <20100817151142.GA11940@frolo.macqel>
References: <20100817151142.GA11940@frolo.macqel>
Date: Tue, 17 Aug 2010 11:14:32 -0400
X-Google-Sender-Auth: 7oZefNuCT71wZHusPmRwDTDj0Fk
Message-ID: <AANLkTim3FQ4eOJ2xJR5Kv4PWDbh=tDL0+-NzOaX+dhXo@mail.gmail.com>
Subject: Re: [uClinux-dev] [PATCH] m68knommu : Fix strace support for 68328/68360
From: Mike Frysinger <vapier@gentoo.org>
To: uClinux development list <uclinux-dev@uclinux.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 17, 2010 at 11:11 AM, Philippe De Muyter wrote:
>  do_trace:
> -       movel   #-ENOSYS,%sp@(PT_OFF_D0)        /* needed for strace*/
> +       movel   #-ENOSYS,%sp@(PT_OFF_D0) /* needed for strace*/
>        subql   #4,%sp
>
> -1:     movel   %d0,%sp@(PT_OFF_D0)             /* save the return value */
> +1:     movel   %d0,%sp@(PT_OFF_D0)     /* save the return value */
>        subql   #4,%sp                  /* dummy return address */
>        /* save top of frame*/
> -       pea     %sp@
> -       jbsr    set_esp0
> -       addql   #4,%sp
> +       pea     %sp@
> +       jbsr    set_esp0
> +       addql   #4,%sp
>        jbsr    %a0@
> -       movel   %d0,%sp@(PT_OFF_D0)             /* save the return value*/
> +       movel   %d0,%sp@(PT_OFF_D0)     /* save the return value*/
>
>  ret_from_exception:
> -       btst    #5,%sp@(PT_OFF_SR)              /* check if returning to kernel*/
> +       btst    #5,%sp@(PT_OFF_SR)      /* check if returning to kernel*/
>        jeq     Luser_return            /* if so, skip resched, signals*/

unless i'm missing something, you're only changing whitespace here.
and these account for more than half the patch.  please keep
whitespace changes separate from real changes.
-mike
