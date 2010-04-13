Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863Ab0DMPQK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 11:16:10 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:10143 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751983Ab0DMPQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 11:16:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=WbQYWgbx1JuCeHrjqQhJjSnbGhN/w5lLdXpMAoqbs4KmvfzkWkwIHxhRRlAdAxrOOK
         CHJVSPoW32IeDWEL/8XXEnQ5JaCbJhGuT1NS3qG62csWGd8O+XoGANIBMpq/PTwgeDCd
         xQrsYbN02+da1o6SmPYZY4qGpHuY2vNqv1jAA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Sergei Shtylyov <sshtylyov@mvista.com>
Subject: Re: [PATCH 54/64] alim15x3: fix handling of UDMA enable bit
Date: Tue, 13 Apr 2010 17:15:06 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.33-0.1-desktop; KDE/4.3.5; x86_64; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20100118171349.14623.90030.sendpatchset@localhost> <20100118172126.14623.55960.sendpatchset@localhost> <4BC325D8.9040607@ru.mvista.com>
In-Reply-To: <4BC325D8.9040607@ru.mvista.com>
MIME-Version: 1.0
Message-Id: <201004131715.06225.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Sergei,

On Monday 12 April 2010 03:53:28 pm Sergei Shtylyov wrote:
> Bartlomiej Zolnierkiewicz wrote:
> > From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > Subject: [PATCH] alim15x3: fix handling of UDMA enable bit
> >
> > Clear UDMA enable bit also for PIO modes.
> >   
> 
>    Sorry for late mail but I fail to understand why this was done and 
> what this patch fixes.
> 
> > Based on libata pata_ali host driver.
> 
>    libata has different mode programming code where first always the PIO 
> mode and then DMA mode is set. With IDE core, the order can be 
> different, PIO mode programming shouldn't affect DMA mode bits -- and 
> does not affect it in the other drivers...

This was just a tiny part of larger patchset preparing alim15x3 for
conversion to ide2libata framework and it seems the problem is only
affecting user-initiated transfer mode changes (which are strongly
discouraged anyway) as both libata and IDE core use quite similar
transfer mode programming sequence by default.

However thanks for noticing the issue, I will fix it for both drivers
during the next update of atang tree (unless somebody sends me a patch
sooner).
--
Bartlomiej Zolnierkiewicz
