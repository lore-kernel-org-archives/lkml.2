Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760059Ab1D0V7I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 17:59:08 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41627 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753394Ab1D0V7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 17:59:05 -0400
Date: Wed, 27 Apr 2011 22:58:46 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Kyungmin Park <kmpark@infradead.org>, linux-kernel@vger.kernel.org,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Ben Nizette <bn@niasdigital.com>, Lee Jones <lee.jones@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] gpio: add pin biasing and drive mode to gpiolib
Message-ID: <20110427215846.GF17290@n2100.arm.linux.org.uk>
References: <92FFDB9F-37F1-4618-A53D-FEF4151A4953@niasdigital.com> <20110418132629.12d9a106@lxorguk.ukuu.org.uk> <6C3F739A-A157-4796-9572-C6B0FAC2565E@niasdigital.com> <20110419093855.36910400@lxorguk.ukuu.org.uk> <BANLkTimqpP2k1tBvRL0BXs9E-Q=3bh0C7Q@mail.gmail.com> <BANLkTint6DGgosVkjK-sveyA9SL9WVS4Mg@mail.gmail.com> <BANLkTinaOk4Qq+uwdZQtapncwjpdTg9wmQ@mail.gmail.com> <20110420162958.09286aa7@lxorguk.ukuu.org.uk> <BANLkTi=QGoaNvJNM6SNsEduVa958bcLC1A@mail.gmail.com> <20110420164315.6cdbcbf0@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110420164315.6cdbcbf0@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 20, 2011 at 04:43:15PM +0100, Alan Cox wrote:
> > Then of course the GPIO driver can in turn call the padmux
> > subsystem to request its pins or fail/bail out if they are taken.
> 
> Yes that makes a lot more sense. It preserves the abstraction in the
> simple cases but handles the complex stuff right.

If one GPIO can be routed to multiple pads, it is not possible for
the GPIO driver to request the padmux code to route the GPIO to the
outside world - the GPIO layer doesn't have the information to tell
the padmux code which pad to route the GPIO to.
