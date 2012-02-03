Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757183Ab2BCU2K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 15:28:10 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:59861 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755109Ab2BCU2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 15:28:08 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Richard Purdie <rpurdie@rpsys.net>, Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 0/3] apple_bl: Add support for gmux backlight control
Date: Fri,  3 Feb 2012 14:28:01 -0600
Message-Id: <1328300884-21551-1-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 1.7.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many models of Apple laptops have a gmux device, whose primary purpose
seems to be controlling the display mux in these machines. The gmux
often also supports adjustment of screen brightness, and in some cases
it is the only working method available for adjusting the backlight.

This series adds support to apple_bl for gmux backlight control, along
with some driver reworking to better support this device. While I was at
it I went ahead and threw in a patch to convert the printks to
pr_<level>.

I've been able to get these changes tested on several different models
of MacBooks, and the functioning of the existing backlight support is
unaffected. On some models the gmux is present but does not control
screen brightness. I haven't found any way to detect this in software
though, as the reads and writes to the backlight control ports behave
identically to when the gmux can control the backlight.

Thanks,
Seth


Seth Forshee (3):
  apple_bl: Convert printks to pr_<level>
  apple_bl: Rework in advance of gmux backlight support
  apple_bl: Add support for gmux backlight control

 drivers/video/backlight/apple_bl.c |  329 +++++++++++++++++++++++++-----------
 1 files changed, 230 insertions(+), 99 deletions(-)

