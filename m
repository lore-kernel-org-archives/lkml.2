Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724Ab0GYVYL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jul 2010 17:24:11 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:46837 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103Ab0GYVYK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jul 2010 17:24:10 -0400
MIME-Version: 1.0
In-Reply-To: <20100725133430.4c1d38a3.sfr@canb.auug.org.au>
References: <20100724160111.7072.68144.stgit@angua> <20100725133430.4c1d38a3.sfr@canb.auug.org.au>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Sun, 25 Jul 2010 15:23:49 -0600
X-Google-Sender-Auth: Lj30QqXu0d_omFhfzjyTIFaFlS0
Message-ID: <AANLkTin3RF+Va-b5ejT-6EJpybMKFE+myLR7Y40e0mha@mail.gmail.com>
Subject: Re: [PATCH] of/device: Make of_device_make_bus_id() usable by other 
	code.
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 24, 2010 at 9:34 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Grant,
>
> On Sat, 24 Jul 2010 10:01:11 -0600 Grant Likely <grant.likely@secretlab.ca> wrote:
>>
>> diff --git a/include/linux/of_device.h b/include/linux/of_device.h
>> index e11a0be..249bc11 100644
>> --- a/include/linux/of_device.h
>> +++ b/include/linux/of_device.h
>> @@ -27,6 +27,9 @@
>>
>>  extern const struct of_device_id *of_match_device(
>>       const struct of_device_id *matches, const struct device *dev);
>> +#if !defined(CONFIG_SPARC)
>> +extern void of_device_make_bus_id(struct device *dev);
>> +#endif
>
> You don't really need the protection here - it does not clash with
> anything on SPARC, right?

No, it doesn't conflict with anything.  I'll drop the if !defined() wrapper.

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
