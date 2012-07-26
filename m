Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269Ab2GZVWJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 17:22:09 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:51570 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752934Ab2GZVWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 17:22:00 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tushar Behera <tushar.behera@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: [ 22/23] ARM: SAMSUNG: Update default rate for xusbxti clock
Date: Thu, 26 Jul 2012 14:20:01 -0700
Message-Id: <20120726211407.891861694@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120726211405.959857593@linuxfoundation.org>
References: <20120726211420.GA7678@kroah.com>
 <20120726211405.959857593@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tushar Behera <tushar.behera@linaro.org>

commit bdd3cc26ba651e33780ade33f1410320cf2d0cf4 upstream.

The rate of xusbxti clock is set in individual machine files.
The default value should be defined at the clock definition
and individual machine files should modify it if required.

Division by zero in kernel.
[<c0011849>] (unwind_backtrace+0x1/0x9c) from [<c022c663>] (Ldiv0+0x9/0x12)
[<c022c663>] (Ldiv0+0x9/0x12) from [<c001a3c3>] (s3c_setrate_clksrc+0x33/0x78)
[<c001a3c3>] (s3c_setrate_clksrc+0x33/0x78) from [<c0019e67>] (clk_set_rate+0x2f/0x78)

Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
Signed-off-by: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/plat-s5p/clock.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm/plat-s5p/clock.c
+++ b/arch/arm/plat-s5p/clock.c
@@ -38,6 +38,7 @@ struct clk clk_ext_xtal_mux = {
 struct clk clk_xusbxti = {
 	.name		= "xusbxti",
 	.id		= -1,
+	.rate		= 24000000,
 };
 
 struct clk s5p_clk_27m = {


