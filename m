Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284Ab0EZVEG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 17:04:06 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:16791 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752838Ab0EZVED convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 17:04:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=HC390V2qTdXqcvvzs8YSDx+fdwtsjHbwhYYLDChZX+S2h0D7+nLwF3GGCCjNrg0lJB
         I88ee1iwyJEODXBy4Jcfy+HK1Hi3ErKsZoRXGlF/hFz4uEfhoRJOsYjhFrd28mjIOv9e
         DbtKYU1Ctq59TowEspwULOt4Xu+b8VpSL4JMo=
MIME-Version: 1.0
In-Reply-To: <AANLkTikzDvWakd7JW3DzTHinjS3dAlqzPx6K8V2qMDG7@mail.gmail.com>
References: <AANLkTikzDvWakd7JW3DzTHinjS3dAlqzPx6K8V2qMDG7@mail.gmail.com>
Date: Wed, 26 May 2010 23:04:01 +0200
Message-ID: <AANLkTinkY8JYh44UOEPflBUDyQ2wat_AKShRjA3HPxrf@mail.gmail.com>
Subject: Re: Controlling Driver Load Order
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Robert Emanuele <rob@emanuele.us>
Cc: linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/5/26 Robert Emanuele <rob@emanuele.us>:

> On my at91sam9g45 platform I need my i2c drivers to load before the
> framebuffer driver.  The i2c drivers control a power management IC
> which is needed to enable the graphics controller.
>
> Is there a way to set up that order?

The usual trick (which you can find in a lot of other I2C busses) is to use
a core_initcall() instead of module_init().

You find the different init levels in include/linux/init.h

Yours,
Linus Walleij
