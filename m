Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756657Ab1HEVkk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 17:40:40 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:59625 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756304Ab1HEVki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 17:40:38 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1+sJCZPQxKs0PKk5dESnAYTUdz6wiNd/yLpF7LGd2
	Pu6iWKEryl9Yng
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 6/6] viafb: remove 640x480-60 CRT special case
Date: Fri,  5 Aug 2011 21:59:16 +0000
Message-Id: <0492262281b82e71c6063e35ef73a33fad93cc6d.1312578946.git.FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <cover.1312578946.git.FlorianSchandinat@gmx.de>
References: <cover.1312578946.git.FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The timing for 640x480-60 was handled different than all others.
This patch changes this by changing the blanking start and end.
The reason for this is that I can't find any reason for the old
behaviour and it was not consistent anyway as the special case for
LCD did not always trigger as the LCD code does not use this
function and it did trigger regardless of whether the display set is
CRT or LCD but only based whether any DVI/LCD device exists.
There are no negative effects observed for CRT or DVI devices.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>

 drivers/video/via/hw.c      |   14 --------------
 drivers/video/via/viamode.c |    2 +-
 2 files changed, 1 insertions(+), 15 deletions(-)
-- 
1.6.3.2

