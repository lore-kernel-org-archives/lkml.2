Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756867Ab0IIBtT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 21:49:19 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39819 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755266Ab0IIBtK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 21:49:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=FQoSclJrUuQ8VlOUHGpM/KeGuWBlZAQvY3Sm6mZjeDpXYLDDpe2FiU1M1x3Sijpvtp
         mm97zKEMYwPrcRCYmEcUQksicL5PFCNWS+yFyHqNP0j6xmKiulCA1QirvDoPoUEAnO2q
         J3QxOnG/Vk4zwijQMMqkLlUV6aWv3MtER0tXQ=
MIME-Version: 1.0
In-Reply-To: <AANLkTimwMiOfvCpUfeXPSF8zh3t3YsM_8nDZbuWFcKM4@mail.gmail.com>
References: <AANLkTinnHiCodvHrSxiMCAQXAETczRiZ+sDu2aQXSeG0@mail.gmail.com>
	<AANLkTiksb1AudCzs8-TWdXb11T-QcPx1G_qu6eUtJ74C@mail.gmail.com>
	<AANLkTin7eVyosgK4XhuB_yqR2ao=YJGVidHB1x2802cr@mail.gmail.com>
	<AANLkTinrecJXH+uDxtBsskFLpBCz0VSZMtSiWGFW9YCr@mail.gmail.com>
	<AANLkTinkhY-y6Qv6HJnGbggksdEmULgQ9DTOrNmu1tLp@mail.gmail.com>
	<AANLkTikZK=8HCtXDR_2dSBce1E10xNfBtyXGOJqykV83@mail.gmail.com>
	<AANLkTin8bXvPqdkYQq++wf0iCK=ZAfZ2jnqbgL=xj8yq@mail.gmail.com>
	<AANLkTimwMiOfvCpUfeXPSF8zh3t3YsM_8nDZbuWFcKM4@mail.gmail.com>
Date: Thu, 9 Sep 2010 09:49:08 +0800
Message-ID: <AANLkTimBBRC7-kg_L7FpS1E5i63NPMi08g9rrG=jtWeD@mail.gmail.com>
Subject: Re: [PATCH] USB: otg: twl4030: fix phy initialization(v1)
From: Ming Lei <tom.leiming@gmail.com>
To: venki kaps <venkiece2005@gmail.com>
Cc: greg@kroah.com, linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        David Brownell <dbrownell@users.sourceforge.net>,
        Felipe Balbi <me@felipebalbi.com>, Anand Gadiyar <gadiyar@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/9/8 venki kaps <venkiece2005@gmail.com>:

>  To resolve the above issue, we have made "PHY power on" in battery
> adc on function
>  and "PHY power down" in battery adc off function.

Good news, the temperature is bad value from battery adc if otg phy is power
down. Maybe you only need to power on otg phy before reading battery adc, then
power down otg phy after the reading if no usb calbe is connected with musb
for decreasing power consumption. (I am not familiar with battery adc, just
for your refrerence)

Anyway, your issue(reading mistaken temperature) is nothing to do with
twl_4030 otg driver and the patch, we does need to power down otg phy
if no vbus or ID event detected.

-- 
Lei Ming
