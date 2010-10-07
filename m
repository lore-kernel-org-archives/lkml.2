Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760211Ab0JGIzR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 04:55:17 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:54973 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709Ab0JGIzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 04:55:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=DhNJ9iVtkA+RnGXI0+CRzIDO35QB06XcoUsNhJnwB+7D9lwHzk4UWS0l1RABj10IEz
         W/pJ/eo4mjj5ddu1ANl8phehZBXnRl+oDZhThfCvjsv2AeMTFOkgWlPy27GB+WjCHWNZ
         4i0RNzlZ/9OodSnjB9Ps6Nw8eb1lAWkJKHX90=
MIME-Version: 1.0
Date: Thu, 7 Oct 2010 18:55:15 +1000
Message-ID: <AANLkTikZj21CtFwC2ttvc0wJPx2qyedn7b1xXaxH659E@mail.gmail.com>
Subject: "do_IRQ: 0.89 No irq handler for vector (irq -1)"
From: Dave Airlie <airlied@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, Jesse Barnes <jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are seeing this on both intel and radeon drivers when we reload the
module with 2.6.36-rc7 or so, and we get no irqs for that device.

you can reproduce by

init 3
echo 0 > /sys/class/vtconsole/vtcon1/bind
rmmod i915
modprobe i915

or radeon.

It seems to be possibly MSI related.

Dave.
