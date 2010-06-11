Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760236Ab0FKMqS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 08:46:18 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:54882 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754326Ab0FKMqR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 08:46:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=A3sNPL45xnUu5lgD/Bg6L3K/2hk5B9lpYAJkUFK6kPKVY0FNBgigEHHCN4fj9Obmhk
         CnI02uQ0a4GDJSIT/DsNuEoR80RPYZUD5uw32IiFTJCioPzOApf1OsRA8ZB3+jkNALpn
         aZfkYGCH5UwSZIJUWiQYzkRVciOqx/JbNqUP0=
MIME-Version: 1.0
In-Reply-To: <1276238502.1556.512.camel@Joe-Laptop.home>
References: <1276238148.22216.30.camel@lenovo> <1276238502.1556.512.camel@Joe-Laptop.home>
From: Javier Martinez Canillas <martinez.javier@gmail.com>
Date: Fri, 11 Jun 2010 08:46:01 -0400
Message-ID: <AANLkTikH_CAVo7sblakUfhI-ysIXk2z1KZz0YkjCDL3m@mail.gmail.com>
Subject: Re: [PATCH] staging/wlags49_hs: Fix build error when CONFIG_SYSFS is 
	not set
To: Joe Perches <joe@perches.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Henk de Groot <pe1dnn@amsat.org>,
       linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
       kernel-janitors <kernel-janitors@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>  extern void register_wlags_sysfs(struct net_device *);
>>  extern void unregister_wlags_sysfs(struct net_device *);
>>  #else
>> -static void register_wlags_sysfs(struct net_device *) { return; };
>> -static void unregister_wlags_sysfs(struct net_device *) { return; };
>> +#define register_wlags_sysfs(net_device) { }
>> +#define unregister_wlags_sysfs(net_device) { }
>>  #endif
>
> Yes, that works, but a better fix would be to remove the
> semicolons after the function close braces.
> ---

Why would it be better? With a macro you avoid the overhead of a
function call that does nothing.
I personally think a macro fit better in this case.

Best regards,

-----------------------------------------
Javier Martínez Canillas
+595 981 88 66 58
