Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760044Ab0FQXlh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 19:41:37 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:53761 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753123Ab0FQXlf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 19:41:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=IFz2giJkK8hpx0LrKT5kjnoXbm4pfpxWtvguVrVLaHV1FfLGcbw5cwIW7/UINcKyMa
         huLha9o5s4A+gKpzYfyBFYglTPDYB7v9wMOKdTK7qFIPixhXp7XEE6mwxYD0WVr0Tw3Y
         TvdT8qHr5qabMh9p/ukhs7TVkYEdK6Enl8OW4=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1006171341420.8191@boston.corp.fedex.com>
References: <Pine.LNX.4.64.1006171341420.8191@boston.corp.fedex.com>
Date: Thu, 17 Jun 2010 17:41:35 -0600
Message-ID: <AANLkTimOjN2CiqGIxh8BClkki8F1SsERaumyy4L1a6Ab@mail.gmail.com>
Subject: Re: What is HSM violation? Causing ata1.00 hard resetting link
From: Robert Hancock <hancockrwd@gmail.com>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: Jeff Garzik <jgarzik@redhat.com>, Greg KH <greg@kroah.com>,
       kristen.c.accardi@intel.com, Dely Sy <dely.l.sy@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Matthew Wilcox <willy@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 17, 2010 at 12:05 AM, Jeff Chua <jeff.chua.linux@gmail.com> wrote:
>
> Hi,
>
> I just got an external e-SATA hard disk, and I'm testing for backup.
>
> When I tried to "tar" 90GB to it, it caused a HSM violation, and since this
> is the root file system, system is brain-dead. "Bus error" for every command
> issued!
>
>
> Error is (typed as was captured in the screen) ...
>
> ata1.00: exception Emask 0x2 SAct 0x7 SErr 0x3000400 action 0x6
> ata1.00: irq_stat 0x44000008

The controller is reporting a protocol violation in Serror, and the
IRQ status reports a taskfile error and unknown FIS received from the
device.

What kind of external drive is this? Seems to me like either it's
doing something not quite kosher, or there's some other problem (maybe
the eSATA cable is bad, or it doesn't seat properly in the connector -
apparently that's not uncommon).

> ata1.00: cmd 60/30:00:37:b0:84/00:00:17:00:00/40 tag 0 ncq 24576 in
>       res 40/00:08:6f:b0:84/00:00:17:00:00/40 Emask 0x2 (HSM violation)
> ata1.00: cmd 60/50:08:6f:b0:84/00:00:17:00:00/40 tag 1 ncq 40960 in
>       res 51/04:00:6f:b0:84/00:00:17:00:00/40 Emask 0x403 (HSM violation)
> ata1.00: cmd 60/00:10:bf:b0:84/01:00:17:00:00/40 tag 2 ncq 131072 in
>       res 40/00:08:6f:b0:84/00:00:17:00:00/40 Emask 0x2 (HSM violation)
> ata1: hard resetting link
> ata1: softreset failed (device not ready)
> ata1: hard resetting link
> ata1: softreset failed (device not ready)
> ata1: hard resetting link
> ata1: link is slow to respond, please be patient (ready=0)
>
>
> Running on SSD on Linux 2.6.35-rc3.
>
> This does not happen all the time, but I've seen this if it's copying
> intensively.
>
> Thanks,
> Jeff.
>
