Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978Ab0GIHFD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 03:05:03 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:55750 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333Ab0GIHFA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 03:05:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=yFACyay+uMtnWWIQuRAFyge8pcJjyocYL+GdSRjcoy4oV3bMVGUKMCcT0mZJS10FbA
         rKoK0KEONigYEBB10TBjBEAXOTR0v06yvv6h5gbcMHF7lkECWwf3VAlI7iJTN3GIhRZl
         a0C6XH3kdcezlKg7pCWddGZ9/UCuUXQKm7BfQ=
MIME-Version: 1.0
In-Reply-To: <20100708224837.6a18995b@infradead.org>
References: <20100708224837.6a18995b@infradead.org>
Date: Fri, 9 Jul 2010 15:04:59 +0800
Message-ID: <AANLkTinJSHiDbAZJ6ga3AGNoZEFzyVPSrHkEocxa8M6N@mail.gmail.com>
Subject: Re: [PATCH] pm: Add runtime PM statistics to sysfs
From: Ming Lei <tom.leiming@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/7/9 Arjan van de Ven <arjan@infradead.org>:
> From: Arjan van de Ven <arjan@linux.intel.com>
> diff --git a/include/linux/pm.h b/include/linux/pm.h
> index 8e258c7..dca597f 100644
> --- a/include/linux/pm.h
> +++ b/include/linux/pm.h
> @@ -476,9 +476,15 @@ struct dev_pm_info {
>        enum rpm_request        request;
>        enum rpm_status         runtime_status;
>        int                     runtime_error;
> +       unsigned long           active_jiffies;
> +       unsigned long           suspended_jiffies;
> +       unsigned long           accounting_timestamp;
>  #endif
>  };

USB subsystem has implemented the function already, and only two variables
are enough to do the statistics. Suggest you to make a reference to usb
implementation, maybe sizeof(unsigned long) bytes per device can be saved.

-- 
Lei Ming
