Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932612Ab0FUVut (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 17:50:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57485 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932340Ab0FUVus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 17:50:48 -0400
Date: Mon, 21 Jun 2010 14:49:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Mair <christoph.mair@gmail.com>
Cc: Jonathan Cameron <kernel@jic23.retrosnub.co.uk>,
       linux-kernel@vger.kernel.org,
       Stefan Schmidt <stefan@datenfreihafen.org>,
       Datta Shubhrajyoti <shubhrajyoti@ti.com>
Subject: Re: [PATCH] Support for the pressure sensor BMP085 from Bosch
 Sensortec.
Message-Id: <20100621144958.d5fc694e.akpm@linux-foundation.org>
In-Reply-To: <1277067058-6929-1-git-send-email-christoph.mair@gmail.com>
References: <4C1DF4DE.5090403@jic23.retrosnub.co.uk>
	<1277067058-6929-1-git-send-email-christoph.mair@gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Jun 2010 22:50:58 +0200
Christoph Mair <christoph.mair@gmail.com> wrote:

> This driver adds support for the BMP085 digital pressure sensor
> from Bosch Sensortec.

If there's a datasheet available, it would be nice to provide a
reference to that in the driver.

> It exposes a sysfs api to userspace where
> pressure and temperature measurement results can be read from the
> pressure0_input and temp0_input file. The chip is able to calculate
> the average of up to eight samples to increase the accuracy.
> This feature can be controlled by writing to the oversampling file.
> 

You didn't adequately (IMO) describe the most important thing: the
userspace interface.

Please do send a full description of the proposed API so we can review
that.  What are the contents of these files?  What are the units of
those contents, etc?

Are there any similar drivers in the tree (I don't think so) and if so
does this new driver offer the same interface?

Bear in mind that if new drivers for similar devices _do_ come along
then we'd prefer that those drivers implement the same interface as
this one.  So is this driver's interface well-designed from that point
of view?

Also, we're supposed to docuemnt these things formally in
Documentation/ABI/.

>
> ...
>
> + * The chip will use 2^oversampling samples for interlan averaging.

I assumed that was supposed to read "internal".
