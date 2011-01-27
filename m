Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834Ab1A0MZq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 07:25:46 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:58313 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140Ab1A0MZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 07:25:45 -0500
Date: Thu, 27 Jan 2011 12:25:44 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Murali K. Vemuri" <vemuri.muralikrishna@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: i2c send inside ISR
Message-ID: <20110127122542.GA11937@sirena.org.uk>
Mail-Followup-To: "Murali K. Vemuri" <vemuri.muralikrishna@gmail.com>,
	linux-kernel@vger.kernel.org
References: <AANLkTikJfWHOeakbVU_CXSeOOz=sCuJoyv6dZ431WjWB@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikJfWHOeakbVU_CXSeOOz=sCuJoyv6dZ431WjWB@mail.gmail.com>
X-Cookie: To err is humor.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 27, 2011 at 09:22:27PM +0900, Murali K. Vemuri wrote:

> I am working on a driver, and I reached a problem.
> problem: My driver is supposed to send I2C message whenever it
> receives an interrupt. the interrupt is generated when a GPIO  is
> detected to be FALLING EDGE of input voltage.
> Now, when I am sending the i2c message, I am getting the error and
> dump like the following:
> Any suggestions???

Use a threaded IRQ handler registered with request_threaded_irq() -
if you grep for that within the kernel you'll find quite a few examples
of handling interrupts from I2C connected devices.  You can't use I2C or
other buses that need to sleep from within hard interrupt context.
