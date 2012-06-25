Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757471Ab2FYROF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 13:14:05 -0400
Received: from mail-qc0-f170.google.com ([209.85.216.170]:38073 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753128Ab2FYROD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 13:14:03 -0400
X-Greylist: delayed 374 seconds by postgrey-1.27 at vger.kernel.org; Mon, 25 Jun 2012 13:14:03 EDT
MIME-Version: 1.0
In-Reply-To: <CAOesGMgq5HRz+pDFQtED5GPN0RUrON=_k_y4YHHzKrMkHnVk4A@mail.gmail.com>
References: <1340409205-23606-1-git-send-email-bfreed@chromium.org>
	<CAOesGMgq5HRz+pDFQtED5GPN0RUrON=_k_y4YHHzKrMkHnVk4A@mail.gmail.com>
Date: Mon, 25 Jun 2012 10:07:35 -0700
X-Google-Sender-Auth: QQHW48S1AZJuOZzPfSRJRJoRQ3w
Message-ID: <CAD=FV=UpBG8gmPjWDF0M9EMSvs4pg7icocMXJ1r3Lmi8frZsrg@mail.gmail.com>
Subject: Re: [PATCH] spi: Unlock a spinlock before calling into the controller driver.
From: Doug Anderson <dianders@chromium.org>
To: Olof Johansson <olof@lixom.net>
Cc: Bryan Freed <bfreed@chromium.org>, spi-devel-general@lists.sourceforge.net,
        grant.likely@secretlab.ca, linux-kernel@vger.kernel.org,
        LinusW <linus.walleij@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Olof,


On Sun, Jun 24, 2012 at 4:54 PM, Olof Johansson <olof@lixom.net> wrote:

> I'm not sure this is safe to do. The lock is dropped for the prepare
> side, but in that case we can be sure that the above code can't come
> in and unprepare at the same time since there is per definition a
> request on the queue at that time.


I spent a bunch of time staring at the code and I'm pretty sure that
there's no race and that the code is safe (if not super obvious).

Specifically there should be only one instance of spi_pump_messages()
running at a time per master.  That's because it's a kthread work
function.  ...so we can't possibly get a prepare in the middle of the
unprepare when prepare is called because the only caller to
prepare/unprepare is spi_pump_messages().


I can't comment on whether it's better to do something like add a
workqueue (which might be more obvious / less fragile) or just to add
a comment.  I will let others comment on that.  :)

-Doug
