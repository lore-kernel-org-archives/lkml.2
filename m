Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757622Ab2IKHAd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 03:00:33 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:55637 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756674Ab2IKHAc convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Tue, 11 Sep 2012 03:00:32 -0400
Message-Id: <504EFDAA020000780009A68C@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Tue, 11 Sep 2012 08:00:26 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Ryan Mallon" <rmallon@gmail.com>
Cc: <linus.walleij@linaro.org>, <grant.likely@secretlab.ca>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] allow gpiolib to be a module
References: <504DF63A020000780009A30B@nat28.tlf.novell.com>
 <504ED77D.90008@gmail.com>
In-Reply-To: <504ED77D.90008@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 11.09.12 at 08:17, Ryan Mallon <rmallon@gmail.com> wrote:
> On 10/09/12 22:16, Jan Beulich wrote:
>> +#ifdef MODULE
>> +int __init gpiolib_init(void)
> 
> Should be static.

Oh, yes, of course.

>> +{
>> +	return gpiolib_sysfs_init() ?: gpiolib_debugfs_init();
> 
> I thought this was going to call gpiolib_sysfs_init() twice until I
> looked at gcc's documentation. Maybe the less obtuse, and far more common:
> 
>   int err;
> 
>   err = gpiolib_sysfs_init();
>   if (err)
>           return err;
> 
>   return gpiolib_debugfs_init();

That construct is being used in many other places throughout
the kernel (including in gpiolib itself), so I don't see why it can't
be used here - the more that it is precisely available to have a
way to avoid the double evaluation.

Jan

