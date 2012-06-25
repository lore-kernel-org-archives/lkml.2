Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755517Ab2FYTCA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 15:02:00 -0400
Received: from mail-qc0-f170.google.com ([209.85.216.170]:62973 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088Ab2FYTB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 15:01:59 -0400
MIME-Version: 1.0
In-Reply-To: <1340409205-23606-1-git-send-email-bfreed@chromium.org>
References: <1340409205-23606-1-git-send-email-bfreed@chromium.org>
Date: Tue, 26 Jun 2012 03:01:58 +0800
Message-ID: <CACRpkda5-6Lp74eqG1mw=VCeMx1GXN=24mw+oavFPMypz3TpEQ@mail.gmail.com>
Subject: Re: [PATCH] spi: Unlock a spinlock before calling into the controller driver.
From: Linus Walleij <linus.walleij@linaro.org>
To: Bryan Freed <bfreed@chromium.org>
Cc: spi-devel-general@lists.sourceforge.net, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 23, 2012 at 7:53 AM, Bryan Freed <bfreed@chromium.org> wrote:

> spi_pump_messages() calls into a controller driver with
> unprepare_transfer_hardware() which is documented as "This may sleep".
> As in the prepare_transfer_hardware() call below, we should release the
> queue_lock spinlock before making the call.
> Rework the logic a bit to hold queue_lock to protect the 'busy' flag,
> then release it to call unprepare_transfer_hardware().
>
> Signed-off-by: Bryan Freed <bfreed@chromium.org>

Yes, this looks correct to me! Good catch.
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
