Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756237Ab2FOKkN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 06:40:13 -0400
Received: from mailrelay1.diasemi.com ([82.210.246.133]:32810 "EHLO
	mailrelay1.diasemi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127Ab2FOKkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 06:40:12 -0400
Message-Id: <201206151038.q5FAcciG000985@sw-eng-lt-dc-vm2>
From: Krystian Garbaciak <krystian.garbaciak@diasemi.com>
Date: Fri, 15 Jun 2012 11:23:56 +0100
Subject: [PATCH 0/2 v2] regmap: Add support for indirect addressing/paging into regmap.
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        Anthony Olech <Anthony.Olech@diasemi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following patches bring simple, virtual address range based paging feature.
This implementation requires bulk read/write to address single page
(data window).
Configuration let you define several virtual ranges for independent paging.
At this version, it don't allow to nest virtual range into the other virtual
range.

Krystian Garbaciak (2):
  regmap: Move lock out from internal function _regmap_update_bits().
  regmap: Add support for register indirect addressing.

 drivers/base/regmap/internal.h |   17 +++
 drivers/base/regmap/regmap.c   |  217 ++++++++++++++++++++++++++++++++++++++--
 include/linux/regmap.h         |   39 +++++++
 3 files changed, 263 insertions(+), 10 deletions(-)

