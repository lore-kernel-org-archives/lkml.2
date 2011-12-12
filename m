Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960Ab1LLUKa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 15:10:30 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:44706 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326Ab1LLUKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 15:10:30 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, j.glisse@gmail.com,
        dri-devel@lists.freedesktop.org
Cc: bskeggs@redhat.com, thellstrom@vmware.com
Subject: [PATCH] fixes to drm-next - TTM DMA code (v1)
Date: Mon, 12 Dec 2011 15:09:26 -0500
Message-Id: <1323720569-15435-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.3
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090207.4EE65FB3.003E,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jerome pointed me to some accounting error in the DMA API debugging code and
while I can't figure it out yet, I did notice some extreme slowness - which
is due to the nouveau driver calling the unpopulate (now that unbind +
unpopulate are squashed) quite a lot (this is using Gnome Shell - I think GNOME2
did not have those issues but I can't recall).

Anyhow these patches fix the 50% perf regression I saw and also some minor bugs
that I noticed.



