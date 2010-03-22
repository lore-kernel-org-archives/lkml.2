Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197Ab0CVUgu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 16:36:50 -0400
Received: from bamako.nerim.net ([62.4.17.28]:60205 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755613Ab0CVUgs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 16:36:48 -0400
Date: Mon, 22 Mar 2010 21:36:45 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, kernel-janitors@vger.kernel.org,
       linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-media@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH 12/24] media/video: fix dangling pointers
Message-ID: <20100322213645.34257722@hyperion.delvare>
In-Reply-To: <20100321144655.4747fd2a@hyperion.delvare>
References: <1269094385-16114-1-git-send-email-w.sang@pengutronix.de>
	<1269094385-16114-13-git-send-email-w.sang@pengutronix.de>
	<201003202302.49526.hverkuil@xs4all.nl>
	<20100321144655.4747fd2a@hyperion.delvare>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replying to myself...

On Sun, 21 Mar 2010 14:46:55 +0100, Jean Delvare wrote:
> I get the feeling that this would be a job for managed resources as
> some drivers already do for I/O ports and IRQs. Managed resources don't
> care about symmetry of allocation and freeing, by design (so it can
> violate point 1 above.) Aha! Isn't it exactly what devm_kzalloc() is
> all about?

Thinking about it again, this really only addresses the calls to
kfree(), not the calls to i2c_set_clientdata(), so apparently I'm quite
off-topic for this discussion. I still think that moving drivers to
managed resources is the way to go, but that's a different issue.

-- 
Jean Delvare
