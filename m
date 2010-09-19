Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753670Ab0ISLcJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 07:32:09 -0400
Received: from nw-smtp-05.wineasy.se ([195.42.210.229]:53809 "EHLO
	nw-smtp-05.wineasy.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132Ab0ISLcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 07:32:07 -0400
X-Greylist: delayed 2048 seconds by postgrey-1.27 at vger.kernel.org; Sun, 19 Sep 2010 07:32:07 EDT
Date: Sun, 19 Sep 2010 12:57:55 +0200
From: Hakan Lennestal <hakan.lennestal@brfsodrahamn.se>
To: linux-kernel@vger.kernel.org
Subject: 2.6.33.7, ftdi_sio, problem with digitemp
Message-Id: <20100919125755.b0c3b9e5.hakan.lennestal@brfsodrahamn.se>
Organization: Hemmavid
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi !

There was a ftdi_sio patch included in the 2.6.33.7 kernel (also 2.6.32.17 and 2.6.35):
"USB: ftdi_sio: support for Signalyzer tools based on FTDI chips"

This patch brakes the digitemp application, http://www.digitemp.com (it will hang).

The problem seem to be the addition of lowering and raising of the DTR/RTS signals in ftdi_sio.c:

  2324                /* raise DTR/RTS */
  2325                set_mctrl(port, TIOCM_DTR | TIOCM_RTS);

  ...

  2373                /* lower DTR/RTS */
  2374                clear_mctrl(port, TIOCM_DTR | TIOCM_RTS);

-- 
Hakan Lennestal <hakan.lennestal@brfsodrahamn.se>
