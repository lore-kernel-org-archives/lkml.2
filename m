Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752495Ab0FCFbv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 01:31:51 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33308 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924Ab0FCFbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 01:31:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=OBqXQjV5k36VGEkHCsGhTNsw7FMyDHB6p8nUXJinrb/tISoydQoq2/Bi4NJFhI7rhS
         36XyySZpZ96V34Bio26mGRukNR+L0etwvaHOtAcivSLoetlfwxxw0NwdHoxJhi7+BH0O
         qwcnTaOfzU4jynEp0GN+CwaH5NHo/erOj1EOI=
Subject: Re: [PATCH] kobject: Suppress compiler warning with gcc 3.x
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: ebiederm@aristanetworks.com, randy.dunlap@oracle.com, gregkh@suse.de,
       linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
In-Reply-To: <201006030523.o535NA16029042@www262.sakura.ne.jp>
References: <201006030523.o535NA16029042@www262.sakura.ne.jp>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Jun 2010 07:31:41 +0200
Message-ID: <1275543101.29413.76.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 03 juin 2010 à 14:23 +0900, Tetsuo Handa a écrit :
> Gcc 3.x generates a warning
> 
>   include/linux/sysfs.h:183: warning: parameter has incomplete type
> 
> on each file.
> Suppress the warning by moving the definition of "enum kobj_ns_type"
> to before "#include <linux/sysfs.h>".
> 
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>


I was about to submit same patch, but I was also reverting 27eabc7cb4b3
(sysfs: Don't use enums in inline function declaration.)

So that sysfs_exit_ns() prototype is consistent regardless of
CONFIG_SYSFS

What do you think ?


> ---
>  include/linux/kobject.h |   20 ++++++++++----------
>  1 file changed, 10 insertions(+), 10 deletions(-)
> 
> --- linux-2.6.35-rc1.orig/include/linux/kobject.h
> +++ linux-2.6.35-rc1/include/linux/kobject.h
> @@ -16,6 +16,16 @@
>  #ifndef _KOBJECT_H_
>  #define _KOBJECT_H_
>  
> +/*
> + * Namespace types which are used to tag kobjects and sysfs entries.
> + * Network namespace will likely be the first.
> + */
> +enum kobj_ns_type {
> +	KOBJ_NS_TYPE_NONE = 0,
> +	KOBJ_NS_TYPE_NET,
> +	KOBJ_NS_TYPES
> +};
> +
>  #include <linux/types.h>
>  #include <linux/list.h>
>  #include <linux/sysfs.h>
> @@ -136,16 +146,6 @@ struct kobj_attribute {
>  
>  extern const struct sysfs_ops kobj_sysfs_ops;
>  
> -/*
> - * Namespace types which are used to tag kobjects and sysfs entries.
> - * Network namespace will likely be the first.
> - */
> -enum kobj_ns_type {
> -	KOBJ_NS_TYPE_NONE = 0,
> -	KOBJ_NS_TYPE_NET,
> -	KOBJ_NS_TYPES
> -};
> -
>  struct sock;
>  
>  /*


