Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755824Ab2FYS4U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 14:56:20 -0400
Received: from mail-qc0-f170.google.com ([209.85.216.170]:56489 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753172Ab2FYS4S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 14:56:18 -0400
MIME-Version: 1.0
In-Reply-To: <CAD=FV=UpBG8gmPjWDF0M9EMSvs4pg7icocMXJ1r3Lmi8frZsrg@mail.gmail.com>
References: <1340409205-23606-1-git-send-email-bfreed@chromium.org>
	<CAOesGMgq5HRz+pDFQtED5GPN0RUrON=_k_y4YHHzKrMkHnVk4A@mail.gmail.com>
	<CAD=FV=UpBG8gmPjWDF0M9EMSvs4pg7icocMXJ1r3Lmi8frZsrg@mail.gmail.com>
Date: Tue, 26 Jun 2012 02:56:17 +0800
Message-ID: <CACRpkdbuiHmZP7HKuoaw1O0xyZJEDv6ja1Q=YqOtBViRYBufZQ@mail.gmail.com>
Subject: Re: [PATCH] spi: Unlock a spinlock before calling into the controller driver.
From: Linus Walleij <linus.walleij@linaro.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Olof Johansson <olof@lixom.net>, Bryan Freed <bfreed@chromium.org>,
        spi-devel-general@lists.sourceforge.net, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2012 at 1:07 AM, Doug Anderson <dianders@chromium.org> wrote:

> Specifically there should be only one instance of spi_pump_messages()
> running at a time per master.  That's because it's a kthread work
> function.  ...so we can't possibly get a prepare in the middle of the
> unprepare when prepare is called because the only caller to
> prepare/unprepare is spi_pump_messages().

Yes that's how the message pump is designed.

> I can't comment on whether it's better to do something like add a
> workqueue (which might be more obvious / less fragile) or just to add
> a comment.  I will let others comment on that.  :)

The message pump initially used a workqueue, but was converted
to a kthread because we needed to push the queue to run as
realtime for some important low-latency workloads across
SPI. The code is basically a tweaked workqueue if you dive down
in the implementation.

Yours,
Linus Walleij
