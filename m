Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758293Ab0GHBsx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 21:48:53 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:39521 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756008Ab0GHBsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 21:48:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=nBAxgg5A2nCcDyo+x8sZ0ICZ5rWD8rSlKrDB2yxIwKWiAgV7H+IF7ZJYzcf+LSw4xJ
         EAy41AXeUsrKOzfFGa4ZJAesM2Ki1EhGdUmuoud2EgS5CmPrU7pEQSvPE+Yl8NUY9zJg
         o/XQn3NrVqP7SmkCLh6x/s34rzuR7ZmQ1bYv4=
Subject: [PATCH] fujitsu-laptop: make needlessly global symbols static
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>,
       Matthew Garrett <mjg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stefani Seibold <stefani@seibold.net>, Andi Kleen <ak@linux.intel.com>,
       platform-driver-x86@vger.kernel.org
Content-Type: text/plain
Date: Thu, 08 Jul 2010 09:49:05 +0800
Message-Id: <1278553745.7162.6.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following symbols are needlessly defined global:

logolamp_led
kblamps_led

This patch makes the symbols static.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/platform/x86/fujitsu-laptop.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/fujitsu-laptop.c b/drivers/platform/x86/fujitsu-laptop.c
index e325aeb..a758d59 100644
--- a/drivers/platform/x86/fujitsu-laptop.c
+++ b/drivers/platform/x86/fujitsu-laptop.c
@@ -182,7 +182,7 @@ static enum led_brightness logolamp_get(struct led_classdev *cdev);
 static void logolamp_set(struct led_classdev *cdev,
 			       enum led_brightness brightness);
 
-struct led_classdev logolamp_led = {
+static struct led_classdev logolamp_led = {
  .name = "fujitsu::logolamp",
  .brightness_get = logolamp_get,
  .brightness_set = logolamp_set
@@ -192,7 +192,7 @@ static enum led_brightness kblamps_get(struct led_classdev *cdev);
 static void kblamps_set(struct led_classdev *cdev,
 			       enum led_brightness brightness);
 
-struct led_classdev kblamps_led = {
+static struct led_classdev kblamps_led = {
  .name = "fujitsu::kblamps",
  .brightness_get = kblamps_get,
  .brightness_set = kblamps_set
-- 
1.5.4.3



