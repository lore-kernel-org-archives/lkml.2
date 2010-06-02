Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757212Ab0FBHJa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 03:09:30 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:49111 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862Ab0FBHJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 03:09:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=xjQ3vnnYWIcGJ0U44c+zA2ZBy08BLBPThrSUFFB+B5znAvElcxRjXpvxoAvwYQujT2
         rIuRibsg1BjF7P99jZdxP+HsXtEjSC2Lodji0ctMKWjR41dRry2QMHQ1pVS1UeMyPWaj
         86OmhNE3DIAKuvlolQ5NHcv0rw0rARlRUqmMc=
Date: Wed, 2 Jun 2010 00:09:23 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Long playing threaded interrupt handlers
Message-ID: <20100602070922.GC3713@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HI Thomas,

The threaded IRQ infrastructure that went into the kernel is extremely
helpful, however in the input land there are quite a few devices that
require polling after an IRQ has been raised.

Currently most such drivers, instead of threaded interrupts, still use
[delayed] work to do the polling, and still face the issue of shutting
down interrupt and scheduled work in a raceless way leaving irq enable
counter balanced. Is it allowed to have threaded ISR execute for
extended a amount of time, and do the required polling, provided that
ISR does certain checks to finish promply in case when we unbind the
driver or try to suspend the device?

Thanks.

-- 
Dmitry
