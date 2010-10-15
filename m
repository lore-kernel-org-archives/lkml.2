Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756419Ab0JOPpO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 11:45:14 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:44673 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756336Ab0JOPpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 11:45:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=q+6nHKZ3UEWUzY672N5knCmk0dbO/LjCkhjwTlov1nBShP24XtKvm2czYkjGyVzQjE
         /4+LLyJSebplRhfFrQAwm0sJwOKFsiqIj2A4C/49SK4FLEfFvAcPMmd4IzLYNtVeMwVw
         CkJdKu8RxO1i2aKPYxcJJ0EcbawAKrGHsSVgM=
Message-ID: <4CB876FB.3020508@gmail.com>
Date: Fri, 15 Oct 2010 23:44:59 +0800
From: Wan ZongShun <mcuos.com@gmail.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Russell King <linux@arm.linux.org.uk>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org, yachen@nuvoton.com
Subject: [PATCH] arm/nuc900: disable hardware cursor setting
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

Currently, the nuc900 lcd driver did not implement controlling
hardware cursor function, so enabling it which results in penal upper left 64x64 
part has been shown in black, so I disable it.

Signed-off-by: Wan ZongShun <mcuos.com@gmail.com>
---
  arch/arm/mach-w90x900/dev.c |    2 +-
  1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-w90x900/dev.c b/arch/arm/mach-w90x900/dev.c
index 5b0c38a..e1d262c 100644
--- a/arch/arm/mach-w90x900/dev.c
+++ b/arch/arm/mach-w90x900/dev.c
@@ -438,7 +438,7 @@ static struct nuc900fb_display nuc900_lcd_info[] = {
  		.upper_margin	= 18,
  		.lower_margin	= 4,
  		.vsync_len	= 1,
-		.dccs		= 0x8e00041a,
+		.dccs		= 0x0e00041a,
  		.devctl		= 0x060800c0,
  		.fbctrl		= 0x00a000a0,
  		.scale		= 0x04000400,
-- 
1.6.3.3
