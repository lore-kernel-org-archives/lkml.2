Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756637Ab1DRTYJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 15:24:09 -0400
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:48096 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756494Ab1DRTYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 15:24:06 -0400
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        arnaud.patard@rtp-net.org
Subject: [PATCH 00/12] staging: xgifb: clean ups for the main module
Date: Mon, 18 Apr 2011 22:13:56 +0300
Message-Id: <1303154048-21989-1-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The main focus of this set is to get rid of the duplicate register I/O
functions defined in the main module.

Testing:
	- compile-tested with GCC 4.5.2, no warnings
	- tested with Z9 (XG21) on ARM, framebuffer console works

Aaro Koskinen (12):
  staging: xgifb: replace outXGIREG() with outb()
  staging: xgifb: replace inXGIIDXREG() with xgifb_reg_get()
  staging: xgifb: replace outXGIIDXREG() with xgifb_reg_set()
  staging: xgifb: replace orXGIIDXREG() with xgifb_reg_or()
  staging: xgifb: replace andXGIIDXREG() with xgifb_reg_and()
  staging: xgifb: replace setXGIIDXREG() with xgifb_reg_and_or()
  staging: xgifb: delete unused register I/O macros
  staging: xgifb: delete unused register I/O functions
  staging: xgifb: main: move functions to avoid forward declarations
  staging: xgifb: main: delete redudant extern declarations
  staging: xgifb: main: delete unused functions
  staging: xgifb: main: make internal functions static

 drivers/staging/xgifb/XGI_main.h    |  136 -----
 drivers/staging/xgifb/XGI_main_26.c |  939 ++++++++++++++---------------------
 2 files changed, 375 insertions(+), 700 deletions(-)

