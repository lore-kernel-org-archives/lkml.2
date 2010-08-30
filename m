Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570Ab0H3IQ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 04:16:27 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:56204 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676Ab0H3IQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 04:16:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=tlbDoot8JO9gix8gabRZHbbm34e8az53oSvLOxLJn4kMBQjUDy+MgdCgta61nQzIBS
         nxHV5I9VFGMrsltr1uxbHnDHE5yOcT5NxcVS4FkolgdgLG+780qF45qW5om/4yaplXpZ
         y352n/W1gFzfS+20PdB0nqqwz/FmpONq+wKfk=
Date: Mon, 30 Aug 2010 10:14:45 +0200
From: Dan Carpenter <error27@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>,
        Marcel Holtmann <marcel@holtmann.org>,
        Alexander Kurz <linux@kbdbabel.org>,
        Andrea Gelmini <andrea.gelmini@gelma.net>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] pcmcia: comedi: fix compile error
Message-ID: <20100830081231.GL9832@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Dominik Brodowski <linux@dominikbrodowski.net>,
	Marcel Holtmann <marcel@holtmann.org>,
	Alexander Kurz <linux@kbdbabel.org>,
	Andrea Gelmini <andrea.gelmini@gelma.net>,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We changed struct pcmcia_device in 90abdc3b973229 "pcmcia: do not use
io_req_t when calling pcmcia_request_io()".  The rest of this file got
updated to the new API but this line was missed so my config doesn't
compile.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/staging/comedi/drivers/das08_cs.c b/drivers/staging/comedi/drivers/das08_cs.c
index c6aa52f..729ba8f 100644
--- a/drivers/staging/comedi/drivers/das08_cs.c
+++ b/drivers/staging/comedi/drivers/das08_cs.c
@@ -222,7 +222,7 @@ static int das08_pcmcia_config_loop(struct pcmcia_device *p_dev,
 		p_dev->resource[0]->flags &= ~IO_DATA_PATH_WIDTH;
 		p_dev->resource[0]->flags |=
 			pcmcia_io_cfg_data_width(io->flags);
-		p_dev->io.IOAddrLines = io->flags & CISTPL_IO_LINES_MASK;
+		p_dev->io_lines = io->flags & CISTPL_IO_LINES_MASK;
 		p_dev->resource[0]->start = io->win[0].base;
 		p_dev->resource[0]->end = io->win[0].len;
 		if (io->nwin > 1) {
