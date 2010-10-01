Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756418Ab0JALSg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 07:18:36 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:33261 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756358Ab0JALSf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 07:18:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:from:date:message-id
         :subject:to:cc:content-type:content-transfer-encoding;
        b=RDmFRtzisEWEUvISvEntmGkW+Jxw5/dQTHrLANZOyglMIGunmNr5Qnb+fW8VzE5tVj
         pCUs2G8D0V8WaF3e/i+DNcCBSOktvpUNrogOS9+BOp3OgJQ4BaMwHkxytbFO+frc8kga
         gQ30JxF6mJzD9n+l47fxDMNLMwfkZzMVB8iI4=
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <20101001071906.GC20529@opensource.wolfsonmicro.com>
References: <1285912587.12422.2.camel@mola> <20101001071906.GC20529@opensource.wolfsonmicro.com>
From: Axel Lin <axel.lin@gmail.com>
Date: Fri, 1 Oct 2010 19:18:14 +0800
Message-ID: <AANLkTi=4Bv72d56XU+4jXZ8wHp+R_1VfaKOrvp_PtG4M@mail.gmail.com>
Subject: Re: [PATCH] regulator: max8649 - fix setting extclk_freq
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/10/1 Mark Brown <broonie@opensource.wolfsonmicro.com>:
> On Fri, Oct 01, 2010 at 01:56:27PM +0800, Axel Lin wrote:
>> The SYNC bits are BIT6 and BIT7 of MAX8649_SYNC register.
>> pdata->extclk_freq could be [0|1|2].
>> (MAX8649_EXTCLK_26MHZ|MAX8649_EXTCLK_13MHZ|MAX8649_EXTCLK_19MHZ)
>> It requires to left shift 6 bits to properly set extclk_freq.
>>
>> Signed-off-by: Axel Lin <axel.lin@gmail.com>
>
> Are there existing users of the driver?  It's not always 100% clear if
> people are expecting bitfield values that will be shifted in or values
> that can be ored directly in.  I don't really mind either way but I'd
> rather be careful.
>
I think I should explain this way:

In max8649.h , we have
enum {
        MAX8649_EXTCLK_26MHZ = 0,
        MAX8649_EXTCLK_13MHZ,
        MAX8649_EXTCLK_19MHZ,   /* 19.2MHz */
};

Thus, I think users will set
extclk_freq = MAX8649_EXTCLK_26MHZ;
but not
extclk_freq = (MAX8649_EXTCLK_26MHZ << 6);

Regards,
Axel
