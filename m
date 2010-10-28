Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760893Ab0J1SOW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 14:14:22 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:62376 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755321Ab0J1SOQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 14:14:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=OP0x82kHXfdu894M5A3X589yd8C5CG/L3/CmApsZxb5PwPQeb2zZhsyPPRNAC9TkoR
         zWDExfIpWckIKrLujuCVf4YrcK89CVD9V9y/sg5pW7oiO+xNc4QlJQXWc3jTvc5npyf/
         T8g2y05OJUo7RPoRtF+5/8jsJGHexwLJ6kAzs=
MIME-Version: 1.0
In-Reply-To: <4CC9A03F.80401@ti.com>
References: <1288124308-14999-1-git-send-email-cyril@ti.com>
	<1288124308-14999-2-git-send-email-cyril@ti.com>
	<AANLkTi=rDep3jkp2QAjVsgjZ7JQ0ysnse4TARv29fyHm@mail.gmail.com>
	<4CC9A03F.80401@ti.com>
Date: Thu, 28 Oct 2010 14:14:14 -0400
Message-ID: <AANLkTinOROf6OqTjN0tZgoDr5ij3J18DHpC8wwArH3CO@mail.gmail.com>
Subject: Re: [PATCH v4 01/12] misc: add driver for sequencer serial port
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: cyril@ti.com
Cc: "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "lrg@slimlogic.co.uk" <lrg@slimlogic.co.uk>,
        "dbrownell@users.sourceforge.net" <dbrownell@users.sourceforge.net>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/10/28 Cyril Chemparathy <cyril@ti.com>:
> On 10/28/2010 11:49 AM, Linus Walleij wrote:
>> Why is this thing in drivers/misc?
>> drivers/mfd is IMHO the apropriate place for a driver like this, (...)
>
> Alan had raised the same concern earlier, and my response was:
>
>[Cyril]
>> Unlike MFDs, this device doesn't have cells with differing
>> functionality.  Instead it has functionally identical ports that can
>> operate in a variety of modes.  That said, does this still fit in with
>> other MFD drivers?  If so, I don't see a problem with moving it there.
>
> I don't see a problem with moving this into MFD, but this won't be able
> to use any of the functionality provided by mfd-core.

I think they do have differing functionality, though not in their
essence (hardware), they do get a clearly defined role at
run-time.

Sam will tell, but since you have subdrivers in other
subsystems MFD fits best IMHO.

What about the platform data passed into the MFD driver defines
what type of functionality will be assigned to each physical
block, from that you create the array of MFD cells to be spawn
and spawn it off. Then you have platform_driver:s in each
subsystem attaching to said cells. Shouldn't be too hard.

Yours,
Linus Walleij
