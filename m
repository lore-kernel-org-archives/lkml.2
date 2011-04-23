Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753657Ab1DWMdq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 08:33:46 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:61664 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753546Ab1DWMdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 08:33:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=PK8rFfaLy+/Tlo9Renblwr3IbiasTQYcEIHhWckkewFBxGhHPPPE86U9vr7VPc1dd3
         FddTz4rXvZpWyjzhMBmMHhj0OYGLAheKe4sjN5KwkoY+T5/82ljjZbetDHQPTIm/FtlI
         aCZfKkxUbLigUnZtystVwbRlOSS8nwdUYaV5g=
MIME-Version: 1.0
In-Reply-To: <op.vuallvn63ri7v4@arend-laptop>
References: <1303331669-31293-1-git-send-email-arend@broadcom.com>
 <201104211612.49805.arnd@arndb.de> <op.vuallvn63ri7v4@arend-laptop>
From: Jonas Gorski <jonas.gorski@gmail.com>
Date: Sat, 23 Apr 2011 14:33:21 +0200
Message-ID: <BANLkTinUWNvkigqkOQeYsyaAKnVXOCji8w@mail.gmail.com>
Subject: Re: [PATCH] drivers: brcmaxi: provide amba axi functionality in
 separate module
To: Arend van Spriel <arend@broadcom.com>
Cc: Arnd Bergmann <arnd@arndb.de>, "zajec5@gmail.com" <zajec5@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>,
        George Kashperko <george@znau.edu.ua>,
        Hauke Mehrtens <hauke@hauke-m.de>, Russell King <rmk@arm.linux.org.uk>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Andy Botting <andy@andybotting.com>, Greg KH <greg@kroah.com>,
        Michael Buesch <m@bues.ch>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 April 2011 16:38, Arend van Spriel <arend@broadcom.com> wrote:
> Would it be possible to make chipcommon driver optional (not doing the
> initialization)?

This would need to be done on a per-device/bus basis, at least for
embedded. Consider the following setup (which is quite common for dual
band routers):

BCM4718
+- Common Core <- provides flash write access, GPIOs, watchdog, ...
+- 802.11 Core <- for 2.4Ghz wifi
+- PCIe Core
  + BCM43224
    +- Common Core
    +- 802.11 Core <- for 5Ghz wifi

(I omitted any cores not relevant for the example)

So eventually you want to able to drive both 802.11 cores, but can't
exclusively claim both common cores.

Regards
Jonas
