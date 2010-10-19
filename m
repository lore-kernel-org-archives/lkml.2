Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756243Ab0JSIEW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 04:04:22 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56364 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753867Ab0JSIEP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 04:04:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=Sf922q6WigSC0hTl1+jBraTMEbekQPUNMr/zkk+SIkbQOE+GS2gtbm63rezDnRKnLI
         BSYexYJIgQFeDK/IQNW5K17+vldcKc0FYXFAuaDXZDR6vX58XoBGWFwU/oBfut6r9xtX
         T7aN4K9D2hnCP+2/yswBGxtUMEdElMlDfGfsc=
MIME-Version: 1.0
In-Reply-To: <AANLkTinjZOS+n6RfdshXdOk7uN4neEKPitT12srK1GsF@mail.gmail.com>
References: <AANLkTinjZOS+n6RfdshXdOk7uN4neEKPitT12srK1GsF@mail.gmail.com>
Date: Tue, 19 Oct 2010 11:04:13 +0300
Message-ID: <AANLkTimzEb=gs7JUh49+zRULL=fv+ugi3fY22HbmDGDq@mail.gmail.com>
Subject: Fwd: kconfig issue with 'choice' and defconfigs
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm forwarding this one so it doesn't get lost (I thought I sent it to lkml).

---------- Forwarded message ----------
From: Felipe Contreras <felipe.contreras@gmail.com>
Date: Fri, Oct 15, 2010 at 1:54 PM
Subject: kconfig issue with 'choice' and defconfigs
To: linux-kbuild@vger.kernel.org
Cc: Michal Marek <mmarek@suse.cz>


Hi,

I noticed this when playing with USB (USB_GADGET_MUSB_HDRC), basically
anything 'choice' related doesn't play nice with defconfigs.

Any ideas?

./scripts/kconfig/conf --defconfig=/dev/null testconfig

testconfig:
---
config FRIEND
       bool
       select MARK
       default y

choice
       prompt "pick one"

config NOONE
       bool "no one"

config JOHN
       bool "john"

config JOHNJR
       tristate
       depends on JOHN
       default FRIEND

config MARK
       bool "mark"

endchoice
---

CONFIG_FRIEND=y
CONFIG_NOONE=y
# CONFIG_JOHN is not set
# CONFIG_MARK is not set

-- 
Felipe Contreras
