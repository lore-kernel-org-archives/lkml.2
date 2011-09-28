Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755166Ab1I1Wde (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:33:34 -0400
Received: from smtp-out.google.com ([216.239.44.51]:2159 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752105Ab1I1Wdc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:33:32 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=V3VGR/04JMOXP+4nmfluILiRGKZ871Y/s1yAmoDJMlZtNekgOvPybXZ0lTGigE1L4
	kjT/fAlt28HYaWzHCaOfg==
MIME-Version: 1.0
In-Reply-To: <1316597339-29861-55-git-send-email-yong.zhang0@gmail.com>
References: <1316597339-29861-1-git-send-email-yong.zhang0@gmail.com> <1316597339-29861-55-git-send-email-yong.zhang0@gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 28 Sep 2011 16:33:08 -0600
Message-ID: <CAErSpo7EUw_4sKXXd2pYkTuqvBFOHgZ1zwrv68K3OU57-QE2Dw@mail.gmail.com>
Subject: Re: [PATCH 54/57] Documentation: irq: Change documents related to IRQF_DISABLED
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Randy Dunlap <rdunlap@xenotime.net>, linux-pci@vger.kernel.org,
        linux-doc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 21, 2011 at 3:28 AM, Yong Zhang <yong.zhang0@gmail.com> wrote:
> IRQF_DISABLED is a NOOP now, place where suggest to use this
> flag also doesn't make sense any more.
>
> Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>

I assume this will be applied via some non-PCI tree (let me know if
otherwise).  The MSI-HOWTO.txt change looks fine to me.

> --- a/Documentation/scsi/ncr53c8xx.txt
> +++ b/Documentation/scsi/ncr53c8xx.txt
> @@ -786,7 +786,9 @@ port address 0x1400.
>         irqm:1     same as initial settings (assumed BIOS settings)
>         irqm:2     always totem pole
>         irqm:0x10  driver will not use IRQF_SHARED flag when requesting irq
> -        irqm:0x20  driver will not use IRQF_DISABLED flag when requesting irq
> +        irqm:0x20  driver will not use IRQF_DISABLED (does not make sense
> +                  any more since genirq will keep irq disabled and the flag
> +                  is dead from linux-2.6.35) flag when requesting irq
>
>     (Bits 0x10 and 0x20 can be combined with hardware irq mode option)

The new text doesn't make sense to me.  I think it should say something like:

    irqm:0x20  driver will not use IRQF_DISABLED flag when requesting
irq (only useful for linux-2.6.34 and earlier)

Bjorn
