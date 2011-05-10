Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397Ab1EJXSK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 19:18:10 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:47899 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752142Ab1EJXSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 19:18:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=FyoDz9bI4JNhd5ZQ4B6+Bor3TEeDLgYiJ99ucv3iMOGmL8iT+DV61EjXSeoBt9DJk1
         S16e0HSueDUTreG019uo3qmzOC1+q+1fRlhg9j7q9KBzWFxRCugLAUGPxA9VOUeOTVvw
         Y4KfnHsKeXulv7Ud/u3mD2txLdmCtKHD/50r4=
MIME-Version: 1.0
In-Reply-To: <20110510224602.73b24d0a@lxorguk.ukuu.org.uk>
References: <20110510212038.GA3279@patrik-macbook>
	<20110510224602.73b24d0a@lxorguk.ukuu.org.uk>
Date: Wed, 11 May 2011 01:18:07 +0200
Message-ID: <BANLkTikz+PrQY2egkPTiacDSH5-Gkqkbww@mail.gmail.com>
Subject: Re: [PATCH] gma500: Add option to disable LVDS
From: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: alan@linux.intel.com, greg@kroah.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 10, 2011 at 11:46 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> On Tue, 10 May 2011 23:20:38 +0200
> Patrik Jakobsson <patrik.r.jakobsson@gmail.com> wrote:
>
>> This patch adds the option to load the driver without LVDS support. Some platforms with the gma500 have nothing hooked up to LVDS but only uses SDVO. LVDS is still detected and added as an encoder which causes SDVO mode-setting to fail.
>>
>> Signed-off-by: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
>
> What platform is this - I'd really like to keep such things automatic and
> also if possible make the code handle the case not blow up. The user
> shouldn't have to deal with such funnies.
>
> Alan
>

This is for the FIT-PC2.

I agree, it's not a good way to handle it, but since I haven't been
able to pinpoint the problem (and this is staging) it's something that
works for now. Perhaps a nicer way to get around it is by checking
against the dmi system id. That way it would be transparent to the
user. But you might prefer we fix the real problem instead of hacking
around it.

When both LVDS and SDVO is enabled the driver tries to set up both
pipes and LVDS only finds a bogus mode of 0x0 pixels. Not sure why
LVDS takes over instead of SDVO since it has valid modes, but my
screen just goes into powersave when no proper PLL can be set for the
bogus mode.

I'll do some more debugging tomorrow.
