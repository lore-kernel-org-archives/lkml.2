Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755758Ab0E2JQA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 May 2010 05:16:00 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:34658 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255Ab0E2JP5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 May 2010 05:15:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:from:date:message-id
         :subject:to:cc:content-type:content-transfer-encoding;
        b=RWDSM8xx07zExHPKtyCSbot9Du7RaM4ms86BS5u0oEKIb6jB90E+RThIPbE+wxt6Vh
         rMrJDtMdz7BCJp4JOn0G/PG68s5V9bker8jnBL0ldcQwBWiY8VKYsT8pMvQ6gVtrCa7+
         Yis1IzRrqMpmTF0WUjwdjYey4wclZ2cmor6uU=
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <201005280745.06299.oneukum@suse.de>
References: <1275017311.11371.2.camel@mola> <201005280745.06299.oneukum@suse.de>
From: Axel Lin <axel.lin@gmail.com>
Date: Sat, 29 May 2010 17:15:37 +0800
Message-ID: <AANLkTin9wWWz_P9coqeIwux1js4-2YYjtTvRQktCfZCc@mail.gmail.com>
Subject: Re: [PATCH] cdc-acm: fix resource reclaim in error path of acm_probe
To: Oliver Neukum <oneukum@suse.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Oliver Neukum <oliver@neukum.name>, Greg Kroah-Hartman <gregkh@suse.de>,
       Alan Cox <alan@linux.intel.com>,
       Francesco Lavra <francescolavra@interfree.it>,
       Julian Calaby <julian.calaby@gmail.com>, linux-usb@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/5/28 Oliver Neukum <oneukum@suse.de>:
> Am Freitag, 28. Mai 2010 05:28:31 schrieb Axel Lin:
>> This patch fixes resource reclaim in error path of acm_probe:
>> 1. In the case of "out of memory (write urbs usb_alloc_urb)",
>> usb_alloc_urb may fail in any iteration of the for loop.
>> Current implementation does not properly free allocated snd->urb.
>
> Yes.
>
>> 2. In the case of device_create_file(&intf->dev,&dev_attr_iCountryCodeRelDate)
>> fail, acm->country_codes is kfreed. As a result, device_remove_file for
>> dev_attr_wCountryCodes will not be executed in acm_disconnect.
>
> Yes.
>
>> 3. This patch also improves the error handling by only reclaim successfully
>> allocated resources instead of iterate over all entries in the for loop.
>
> Please don't do that. Simplicity and correctness are the only goals designing
> error handling.

OK. I will send a revised version for bug fixes only.
Thanks for the review.

Axel

>
>        Regards
>                Oliver
>
