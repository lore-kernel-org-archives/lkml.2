Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757330Ab1AMUw2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 15:52:28 -0500
Received: from jester.euphonynet.be ([212.87.96.13]:49443 "EHLO
	mailpush2.euphonynet.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756717Ab1AMUwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 15:52:21 -0500
From: Bart Van Assche <bvanassche@acm.org>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kobject: Add missing format attribute specifications
Date: Thu, 13 Jan 2011 21:52:11 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-scst+; KDE/4.4.4; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>
References: <201101011351.52691.bvanassche@acm.org>
In-Reply-To: <201101011351.52691.bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101132152.11721.bvanassche@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 01 January 2011 13:51:52 Bart Van Assche wrote:
> Several functions in <linux/kobject.h> accept printf-style arguments.
> Some of these functions have been annotated with a format attribute
> declaration while others have not been annotated. Add a format attribute
> specification where it is missing.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> Cc: "Greg Kroah-Hartman" <gregkh@suse.de>
> 
> ---
>  include/linux/kobject.h |    7 +++++--
>  1 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/kobject.h b/include/linux/kobject.h
> index 8f6d121..15e82c1 100644
> --- a/include/linux/kobject.h
> +++ b/include/linux/kobject.h
> @@ -85,11 +85,13 @@ static inline const char *kobject_name(const struct kobject *kobj)
>  extern void kobject_init(struct kobject *kobj, struct kobj_type *ktype);
>  extern int __must_check kobject_add(struct kobject *kobj,
>  				    struct kobject *parent,
> -				    const char *fmt, ...);
> +				    const char *fmt, ...)
> +	__attribute__((format(printf, 3, 4)));
>  extern int __must_check kobject_init_and_add(struct kobject *kobj,
>  					     struct kobj_type *ktype,
>  					     struct kobject *parent,
> -					     const char *fmt, ...);
> +					     const char *fmt, ...)
> +	__attribute__((format(printf, 4, 5)));
>  
>  extern void kobject_del(struct kobject *kobj);
>  
> @@ -226,6 +228,7 @@ static inline int kobject_uevent_env(struct kobject *kobj,
>  
>  static inline int add_uevent_var(struct kobj_uevent_env *env,
>  				 const char *format, ...)
> +	__attribute__((format(printf, 2, 3)))
>  { return 0; }
>  
>  static inline int kobject_action_type(const char *buf, size_t count,

Hello Greg,

Have you already had the time to have a look at this patch and the two patches that can be found here: http://lkml.org/lkml/2010/12/21/97 ?

Thanks,

Bart.
