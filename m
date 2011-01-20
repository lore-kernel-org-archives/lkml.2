Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182Ab1ATEWT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 23:22:19 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:34709 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754215Ab1ATEWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 23:22:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=L0CkpPUEw35n9Viz1FisdPdmxaUU4bej2Z93dzCd2CcvA7ADX7n0cTcIWcCh24DpYn
         l1Dj+ofxaR9AXt1kwIEuG3M0lH+X1D20IxTY5vsmDRHIVFLFWXPGrrXvHmhHaAAKczou
         XMceslEEOquy4Vv6JFPvGMag9+PXQ/Iu7EwZM=
MIME-Version: 1.0
Date: Thu, 20 Jan 2011 11:21:14 +0700
Message-ID: <AANLkTi=koHRNJaVQGwdPiEkSOwveOKHK97oO99n6PiwF@mail.gmail.com>
Subject: [2.6.37/38] SDHCI spurious interrupt...
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: Chris Ball <cjb@laptop.org>
Cc: linux-mmc@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With 2.6.37 (and by extension 2.6.38-rc1, as the code hasn't changed),
I occasionally see an 'IRQ 16: nobody cared' message a second before
shutting down (previously reported [1]); the culprit is the SDHCI
driver for my Ricoh controller.

I modified the interrupt handler to be unregistered later with a
delay, and to dump out the interrupt mask read, but didn't catch it
yet.

Any ideas?

Thanks,
  Daniel

[1] https://patchwork.kernel.org/patch/416211/
-- 
Daniel J Blueman
