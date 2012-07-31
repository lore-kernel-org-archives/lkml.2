Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190Ab2GaCkj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 22:40:39 -0400
Received: from am1ehsobe003.messaging.microsoft.com ([213.199.154.206]:8948
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751476Ab2GaCkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 22:40:37 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -5
X-BigFish: VPS-5(zzbb2dI98dI9371I1432I4015Izz1202hzzz2dh668h839hd25he5bhf0ah107ah)
X-WSS-ID: 0M807FE-01-2TA-02
X-M-MSG: 
Message-ID: <5017458F.7000504@amd.com>
Date: Tue, 31 Jul 2012 10:40:15 +0800
From: Aaron Lu <aaron.lu@amd.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.6esrpre) Gecko/20120717 Thunderbird/10.0.6
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Jeff Garzik <jgarzik@pobox.com>, Alan Stern <stern@rowland.harvard.edu>,
        Sergei Shtylyov <sshtylyov@mvista.com>,
        Oliver Neukum <oneukum@suse.de>, Jeff Wu <jeff.wu@amd.com>,
        Lin Ming <minggr@gmail.com>, <linux-kernel@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <linux-ide@vger.kernel.org>, Aaron Lu <aaron.lwe@gmail.com>,
        Shane Huang <shane.huang@amd.com>
Subject: Re: [PATCH v4 0/7] ZPODD patches
References: <1343379650-2867-1-git-send-email-aaron.lu@amd.com>
In-Reply-To: <1343379650-2867-1-git-send-email-aaron.lu@amd.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 31 Jul 2012 02:40:21.0620 (UTC) FILETIME=[D47D3340:01CD6EC5]
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James,

Any chance of these patches get merged into 3.6?

Thanks,
Aaron

On 07/27/2012 05:00 PM, Aaron Lu wrote:
> v4:
> Rebase on top of Linus' tree, due to this, the problem of a missing
> flag in v3 is gone;
> Add a new function scsi_autopm_put_device_autosuspend to first mark
> last busy for the device and then put autosuspend it as suggested by
> Oliver Neukum.
> Typo fix as pointed by Sergei Shtylyov.
> Check can_power_off flag before any runtime pm operations in sr.
>
> v3:
> Rebase on top of scsi-misc tree;
> Add the sr related patches previously in Jeff's libata tree;
> Re-organize the sr patches.
> A problem for now: for patch
> scsi: sr: support zero power ODD(ZPODD)
> I can't set a flag in libata-acpi.c since a related function is
> missing in scsi-misc tree. Will fix this when 3.6-rc1 released.
>
> v2:
> Bug fix for v1;
> Use scsi_autopm_* in sr driver instead of pm_runtime_*;
>
> v1:
> Here are some patches to make ZPODD easier to use for end users and
> a fix for using ZPODD with system suspend.
>
> Aaron Lu (7):
>    scsi: sr: check support for device busy class events
>    scsi: pm: add interface to autosuspend scsi device
>    scsi: sr: support zero power ODD(ZPODD)
>    scsi: sr: block events when runtime suspended
>    scsi: pm: use runtime resume callback if available
>    scsi: sr: balance sr disk events block depth
>    block: genhd: add an interface to set disk's poll interval
>
>   block/genhd.c              |  25 +++++--
>   drivers/ata/libata-acpi.c  |   4 +-
>   drivers/scsi/scsi_pm.c     |  22 ++++--
>   drivers/scsi/sr.c          | 179 ++++++++++++++++++++++++++++++++++++++++++++-
>   drivers/scsi/sr.h          |   3 +
>   include/linux/cdrom.h      |  43 +++++++++++
>   include/linux/genhd.h      |   1 +
>   include/scsi/scsi_device.h |   3 +
>   8 files changed, 267 insertions(+), 13 deletions(-)
>


