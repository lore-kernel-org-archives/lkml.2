Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756147Ab2JIPdM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 11:33:12 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:16172 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089Ab2JIPdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 11:33:07 -0400
Date: Tue, 9 Oct 2012 17:32:37 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>, ben-linux@fluff.org,
        w.sang@pengutronix.de, linux-i2c@vger.kernel.org,
        kernel-janitors@vger.kernel.org, rmallon@gmail.com,
        shubhrajyoti@ti.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/11] introduce macros for i2c_msg initialization
Message-ID: <20121009173237.7c1a49e9@endymion.delvare>
In-Reply-To: <1349624323-15584-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1349624323-15584-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Julia,

On Sun,  7 Oct 2012 17:38:30 +0200, Julia Lawall wrote:
> This patch set introduces some macros for describing how an i2c_msg is
> being initialized.  There are three macros: I2C_MSG_READ, for a read
> message, I2C_MSG_WRITE, for a write message, and I2C_MSG_OP, for some other
> kind of message, which is expected to be very rarely used.

"Some other kind of message" is actually messages which need extra
flags. They are still read or write messages.

OK, I've read the whole series now and grepped the kernel tree so I
have a better overview. There are a lot more occurrences than what you
converted. I presume the conversions were just an example and you leave
the rest up to the relevant maintainers (e.g. me) if they are
interested?

Given the huge number of affected drivers (a quick grep suggests 230
drivers and more than 300 occurrences), we'd better think twice before
going on as it will be intrusive and hard to change afterward.

So my first question will be: what is your goal with this change? Are
you only trying to save a few lines of source code? Or do you expect to
actually fix/prevent bugs by introducing these macros? Or something
else?

I admit I am not completely convinced by the benefit at the moment. A
number of these drivers should be using i2c_smbus_*() functions instead
of i2c_transfer() for improved compatibility, or i2c_master_send/recv()
for single message transfers (383 occurrences!), so making
i2c_transfer() easier to use isn't at the top of my priority list. And
I see the extra work for the pre-processor, so we need a good reason
for doing that.

-- 
Jean Delvare
