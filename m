Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753741Ab1DTXcn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 19:32:43 -0400
Received: from outbound.icp-osb-irony-out8.iinet.net.au ([203.59.1.134]:8624
	"EHLO outbound.icp-osb-irony-out8.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752670Ab1DTXcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 19:32:42 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApEBAJNsr03L2T1e/2dsb2JhbAANrx8bvlGFcQSSPA
X-IronPort-AV: E=Sophos;i="4.64,248,1301846400"; 
   d="scan'208";a="4245172"
Subject: Re: [PATCH 1/2] gpio: add pin biasing and drive mode to gpiolib
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Ben Nizette <bn@niasdigital.com>
In-Reply-To: <BANLkTi=W7jaVtW1FThvG_ca57q+yDz1kzQ@mail.gmail.com>
Date: Thu, 21 Apr 2011 09:32:26 +1000
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org
Content-Transfer-Encoding: 7bit
Message-Id: <E0A55C1E-9DA0-4FFE-90EE-575BB1E649CB@niasdigital.com>
References: <1303076273-8093-1-git-send-email-linus.walleij@stericsson.com> <3F5641E3-C443-4541-9FDA-24D215597C1F@niasdigital.com> <20110418091902.13345132@lxorguk.ukuu.org.uk> <92FFDB9F-37F1-4618-A53D-FEF4151A4953@niasdigital.com> <20110418132629.12d9a106@lxorguk.ukuu.org.uk> <6C3F739A-A157-4796-9572-C6B0FAC2565E@niasdigital.com> <BANLkTi=W7jaVtW1FThvG_ca57q+yDz1kzQ@mail.gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 20/04/2011, at 10:21 PM, Linus Walleij wrote:

> 2011/4/19 Ben Nizette <bn@niasdigital.com>:
>> On 18/04/2011, at 10:26 PM, Alan Cox wrote:
>> 
>>> The logical extension to that is to delete the gpio layer because the
>>> board code can do it ?
>> 
>> Well anything that is done once at startup, yes,
> 
> This patch is about biasing and drive modes. We need to alter
> these at runtime (from board code, indeed) due to the fact that
> when you go to sleep e.g. floating a pin yeilds better power
> characteristics.

This is actually an interesting case because floating pins yeild
/worse/ power characteristics (each transistor of the push-pull
is on a little bit and you get a path straight through) [1].  To
get good power performance you want to pull an input pin high or
low but which of those two directions depends on external
constraints, i.e. the board.  This is a case where the driver
should /not/ go playing with things it can't fully understand.

Perhaps one of the properties that a board can set in a gpio chip
driver is the suspend state and have suspend/resume hooks in the
gpio chip take care of setting things up on each side.

	--Ben.

[1] http://processors.wiki.ti.com/index.php/Optimizing_IO_Power_Consumption

> 
> Linus Walleij

