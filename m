Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752451Ab1FLSio (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 14:38:44 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:34346 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899Ab1FLSim convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 14:38:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=FV4XwtwMlEWuzimkutpA0PV+CNvsLsQI+Q7yTVMJ+L5zL55cN9NO1PETrZIDjlF+lD
         0o359qmDaI5XQ/7bpzuIKnOnYZdWKSaWzaS+VoYmDpAfYmozrpyZGSuXt9NYl5EjhQJr
         ZH73GVLbiGP49s1mMlnjeRfMDWe0HKUbhmoLU=
From: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
To: "Winkler, Tomas" <tomas.winkler@intel.com>
Subject: Re: mei driver breaks suspend on 3.0git
Date: Sun, 12 Jun 2011 20:38:36 +0200
User-Agent: KMail/1.13.7 (Linux/3.0.0-rc2-00256-gb99ca60; KDE/4.6.4; x86_64; ; )
Cc: "Weil, Oren jer" <oren.jer.weil@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <201106121314.26394.a.miskiewicz@gmail.com> <6F5C1D715B2DA5498A628E6B9C124F0401AD318AB4@hasmsx504.ger.corp.intel.com> <201106122016.33399.a.miskiewicz@gmail.com>
In-Reply-To: <201106122016.33399.a.miskiewicz@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201106122038.36623.a.miskiewicz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 12 of June 2011, Arkadiusz Miskiewicz wrote:
> On Sunday 12 of June 2011, Winkler, Tomas wrote:
> > > -----Original Message-----
> > > From: Weil, Oren jer
> > > Sent: Sunday, June 12, 2011 8:36 PM
> > > To: Arkadiusz Miskiewicz
> > > Cc: Winkler, Tomas; linux-kernel@vger.kernel.org
> > > Subject: RE: mei driver breaks suspend on 3.0git
> > > 
> > > >It's thinkpad t400 with
> > > >00:03.0 Communication controller [0780]: Intel Corporation Mobile 4
> > > >Series Chipset MEI Controller [8086:2a44] (rev 07)
> > > 
> > > Can you send us more details? Does it happened in stress? How do I
> > > reproduce
> > > it?
> 
> No stress. This is my daily use notebook and I simply suspend to ram when
> sitting under X in kde4.
> 
> > > Can you send us the debug prints?
> 
> Attached. suspend starts, tries to resume devices, MEI suspend fails
> causing whole suspend to be aborted.

Shouldn't ret > 0 in mei_wd_stop to be "success"?

Untested.

diff --git a/drivers/staging/mei/wd.c b/drivers/staging/mei/wd.c
index 2564b03..608245a 100644
--- a/drivers/staging/mei/wd.c
+++ b/drivers/staging/mei/wd.c
@@ -171,8 +171,10 @@ int mei_wd_stop(struct mei_device *dev, bool preserve)
        mutex_lock(&dev->device_lock);
        if (!dev->wd_stopped)
                dev_dbg(&dev->pdev->dev, "stop wd failed to complete.\n");
-       else
+       else {
+               ret = 0;
                dev_dbg(&dev->pdev->dev, "stop wd complete.\n");
+       }

        if (preserve)
                dev->wd_timeout = wd_timeout;

-- 
Arkadiusz Miśkiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
