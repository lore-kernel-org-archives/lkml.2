Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751843Ab2LUJrl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 04:47:41 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:39577 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450Ab2LUJre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 04:47:34 -0500
From: Andrey Smirnov <andrew.smirnov@gmail.com>
To: andrey.smirnov@convergeddevices.net
Cc: broonie@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] Add "no-bus" configuration for regmap API
Date: Fri, 21 Dec 2012 01:47:15 -0800
Message-Id: <1356083238-6932-1-git-send-email-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch proposes extension to the API that was suggested by Mark in
the following thread:
http://article.gmane.org/gmane.linux.kernel/1383734

The idea behind extensions is to allow the devices that expose some
register-like interface but whose protocol for reading or writing
those registers could not be simplified to serialized bytestream
writes to be used within 'regmap' framework

Original RFC thread can be found here:
https://lkml.org/lkml/2012/11/23/367

First two patches are refactoring patches that add all the necessary
plumbing to the regmap internals and move old functionality to use
that infrastracture.

Third patch introduces code that implements 'no-bus' configuration

Andrey Smirnov (3):
  Add provisions to have user-defined read operation
  Add provisions to have user-defined write operation
  Add "no-bus" option for regmap API

 drivers/base/regmap/internal.h |    5 ++
 drivers/base/regmap/regmap.c   |  156 +++++++++++++++++++++++++++++-----------
 include/linux/regmap.h         |    7 ++
 3 files changed, 126 insertions(+), 42 deletions(-)

-- 
1.7.9.5

