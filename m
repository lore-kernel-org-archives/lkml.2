Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657Ab1IHXZW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 19:25:22 -0400
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:47063 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754051Ab1IHXZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 19:25:14 -0400
Message-ID: <4E6935D9.1040104@xenotime.net>
Date: Thu, 08 Sep 2011 14:38:33 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Yong Zhang <yong.zhang0@gmail.com>
CC: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
        Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH 61/62] Documentation: irq: Change documents related to
 IRQF_DISABLED
References: <1315383059-3673-1-git-send-email-yong.zhang0@gmail.com> <1315383059-3673-62-git-send-email-yong.zhang0@gmail.com>
In-Reply-To: <1315383059-3673-62-git-send-email-yong.zhang0@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/07/11 01:10, Yong Zhang wrote:
> IRQF_DISABLED is a NOOP now, place where suggest to use this
> flag also doesn't make sense anymore.
> 
> Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
> ---
>  Documentation/PCI/MSI-HOWTO.txt  |   21 ---------------------
>  Documentation/scsi/ncr53c8xx.txt |    4 +++-
>  Documentation/scsi/tmscsim.txt   |    4 ++--
>  3 files changed, 5 insertions(+), 24 deletions(-)

> diff --git a/Documentation/scsi/ncr53c8xx.txt b/Documentation/scsi/ncr53c8xx.txt
> index cda5f8f..654b34c 100644
> --- a/Documentation/scsi/ncr53c8xx.txt
> +++ b/Documentation/scsi/ncr53c8xx.txt
> @@ -786,7 +786,9 @@ port address 0x1400.
>          irqm:1     same as initial settings (assumed BIOS settings)
>          irqm:2     always totem pole
>          irqm:0x10  driver will not use IRQF_SHARED flag when requesting irq
> -        irqm:0x20  driver will not use IRQF_DISABLED flag when requesting irq
> +        irqm:0x20  driver will not use IRQF_DISABLED(Does not make sense
> +		   anymore since genirq will keep irq disabled and the flag

                             will not use IRQF_DISABLED (does not make sense
                   any more

> +		   is dead from linux-2.6.36) flag when requesting irq
>  
>      (Bits 0x10 and 0x20 can be combined with hardware irq mode option)
>  
> diff --git a/Documentation/scsi/tmscsim.txt b/Documentation/scsi/tmscsim.txt
> index 61c0531..45cfd63 100644
> --- a/Documentation/scsi/tmscsim.txt
> +++ b/Documentation/scsi/tmscsim.txt
> @@ -108,8 +108,8 @@ MHz PCI bus works for me, though, but I don't recommend using higher clocks
>  than the 33.33 MHz being in the PCI spec.
>  
>  If you want to share the IRQ with another device and the driver refuses to
> -do so, you might succeed with changing the DC390_IRQ type in tmscsim.c to 
> -IRQF_SHARED | IRQF_DISABLED.
> +do so,  you should find out what's the mismatch between the shared irqs,

   do so, you should                                                  IRQs,


> +and CONFIG_DEBUG_SHIRQ may give you more help.
>  
>  
>  3.Features


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
