Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756502Ab1JMQKx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 12:10:53 -0400
Received: from mail-dy0-f46.google.com ([209.85.220.46]:58599 "EHLO
	mail-dy0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755918Ab1JMQKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 12:10:50 -0400
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] pata_rdc: parallel scanning needs an extra locking
Date: Thu, 13 Oct 2011 18:08:31 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.37.6-0.7-desktop-dirty; KDE/4.6.0; x86_64; ; )
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <201110131606.04496.bzolnier@gmail.com> <20111013164923.23683fcb@lxorguk.ukuu.org.uk>
In-Reply-To: <20111013164923.23683fcb@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201110131808.31470.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:

> On Thu, 13 Oct 2011 16:06:04 +0200
> Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> 
> > From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > Subject: [PATCH] pata_rdc: parallel scanning needs an extra locking
> > 
> > This is similar change as commit 60c3be3 ("ata_piix: parallel scanning
> > on PATA needs an extra locking") for ata_piix host driver.
> 
> Again has anyone verified with the vendor that the RDC can support
> parallel scanning ?

Upstream has always used it:

commit 6b406782ad0408f9cb480c2e1b543d194e8206d0
Author: Alan Cox <alan@linux.intel.com>
Date:   Wed Jun 24 18:29:44 2009 +0100

    [libata] Add pata_rdc driver for RDC ATA devices
    
    From: Alan Cox <alan@linux.intel.com>
    
    Signed-off-by: Alan Cox <alan@linux.intel.com>
    Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
...
+
+       host->flags |= ATA_HOST_PARALLEL_SCAN;
+
...

My patch only adds needed locking.
