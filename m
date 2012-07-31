Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756318Ab2GaUK0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 16:10:26 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:33956 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756277Ab2GaUKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 16:10:21 -0400
From: Federico Vaga <federico.vaga@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Cc: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
Subject: Update STA2X11 to videobuf2 and control framework
Date: Tue, 31 Jul 2012 22:13:30 +0200
Message-Id: <1343765616-5780-1-git-send-email-federico.vaga@gmail.com>
X-Mailer: git-send-email 1.7.11.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


As suggested I moved the Video Buffer Input (VIP) of the STA2X11 board to the
videobuf2. This patch series is an RFC.

The first patch is just an update to the adv7180 because the VIP (the only
user) now use the control framework so query{g_|s_|ctrl} are not necessery.

The second patch adds a new memory allocator for the videobuf2. I name it
videobuf2-dma-streaming but I think "streaming" is not the best choice, so
suggestions are welcome. My inspiration for this buffer come from
videobuf-dma-contig (cached) version. After I made this buffer I found the
videobuf2-dma-nc made by Jonathan Corbet and I improve the allocator with
some suggestions (http://patchwork.linuxtv.org/patch/7441/). The VIP doesn't
work with videobu2-dma-contig and I think this solution is easier the sg.

The third patch updates the VIP to videobuf2 and control framework. I made also
some restyling to the driver and change some mechanism so I take the ownership
of the driver and I add the copyright of ST Microelectronics. Some trivial
code is unchanged. The patch probably needs some extra update and probably,
you will give me many suggestions. 
I add the control framework to the VIP but without any control. I add it to 
inherit controls from adv7180.

--
Federico Vaga
