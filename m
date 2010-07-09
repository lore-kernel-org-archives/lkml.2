Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753466Ab0GIVrh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 17:47:37 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54464 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592Ab0GIVre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 17:47:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:message-id;
        b=PqGgX+5erhX+nh4WtCCgnn7fa+epaG5px17HSXSKmnFXVobzS6mmroMsZ/1lsQh1X2
         7m2lgr4UiWkDwzUa4FYuMxMojT/lZpOTQNROqVdm7mDzIOQqBPloVfocAvUgYyrB7wh+
         nN0jHRKL4y/OYEnT1wM4646UWoddoOidi6b6M=
From: Stephan Diestelhorst <stephan.diestelhorst@gmail.com>
To: Tejun Heo <tj@kernel.org>
Subject: Re: HDD not suspending properly / dead on resume
Date: Fri, 9 Jul 2010 23:47:28 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.32-23-generic; KDE/4.4.5; x86_64; ; )
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-pm@lists.osdl.org
References: <201007091750.05020.stephan.diestelhorst@amd.com>
In-Reply-To: <201007091750.05020.stephan.diestelhorst@amd.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_wj5NMmLhbH06zII"
Message-Id: <201007092347.29244.stephan.diestelhorst@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_wj5NMmLhbH06zII
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit

I wrote:
>   I have an issue with suspend to RAM and I/O load on a disk. Symptoms
> are that the disk does not respond to requests when woken up, producing
> only I/O errors on all tested kernels (newest 2.6.35-rc4 (Ubuntu
> mainline PPA build)):
> 
<snip>
 
> This can be triggered most reliably with multiple "direct" writes to
> disk, I create the load with the attached script. If the issue is
> triggered, suspend (through pm-suspend) takes very long.

Attached now...

> IMHO the interesting log output during suspend is:
> [ 1674.700125] ata1.00: qc timeout (cmd 0xec)

Almighty google suggested to try "pci=nomsi", which seems to have
cured the issue for me for now. Is that plausible? I'll keep this
under observation.

Thanks,
  Stephan

--Boundary-00=_wj5NMmLhbH06zII
Content-Type: application/x-shellscript;
  name="io_load.sh"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="io_load.sh"

#!/bin/bash
CONC=10
BS=4096
COUNT=1024
while true; do
	for i in $(seq 1 ${CONC}); do
		dd if=/dev/zero of=zeroes_${i} oflag=direct bs=${BS} count=${COUNT} &
	done
	wait
done


--Boundary-00=_wj5NMmLhbH06zII--
