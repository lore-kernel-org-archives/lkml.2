Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932540Ab1ELT2T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 15:28:19 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46635 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755039Ab1ELT2R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 15:28:17 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Raffaele Recalcati <lamiaposta71@gmail.com>
Subject: Re: [PATCH 1/4] export bus_kset
Date: Thu, 12 May 2011 21:28:53 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc7+; KDE/4.6.0; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-kernel@vger.kernel.org, Davide Ciminaghi <ciminaghi@gnudd.com>
References: <1305220265-9020-1-git-send-email-lamiaposta71@gmail.com> <1305220265-9020-2-git-send-email-lamiaposta71@gmail.com>
In-Reply-To: <1305220265-9020-2-git-send-email-lamiaposta71@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201105122128.54172.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, May 12, 2011, Raffaele Recalcati wrote:
> From: Davide Ciminaghi <ciminaghi@gnudd.com>

Please explain why you need to export it, what the alternatives are and
why you think this approach is better than the alternatives.

Thanks,
Rafael


> Signed-off-by: Davide Ciminaghi <ciminaghi@gnudd.com>
> ---
>  drivers/base/bus.c      |    3 ++-
>  include/linux/kobject.h |    2 ++
>  2 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/base/bus.c b/drivers/base/bus.c
> index 000e7b2..2134248 100644
> --- a/drivers/base/bus.c
> +++ b/drivers/base/bus.c
> @@ -158,7 +158,8 @@ static const struct kset_uevent_ops bus_uevent_ops = {
>  	.filter = bus_uevent_filter,
>  };
>  
> -static struct kset *bus_kset;
> +struct kset *bus_kset;
> +EXPORT_SYMBOL(bus_kset);
>  
>  
>  #ifdef CONFIG_HOTPLUG
> diff --git a/include/linux/kobject.h b/include/linux/kobject.h
> index 8f6d121..456b20d 100644
> --- a/include/linux/kobject.h
> +++ b/include/linux/kobject.h
> @@ -205,6 +205,8 @@ extern struct kobject *power_kobj;
>  /* The global /sys/firmware/ kobject for people to chain off of */
>  extern struct kobject *firmware_kobj;
>  
> +extern struct kset *bus_kset ;
> +
>  #if defined(CONFIG_HOTPLUG)
>  int kobject_uevent(struct kobject *kobj, enum kobject_action action);
>  int kobject_uevent_env(struct kobject *kobj, enum kobject_action action,
> 

