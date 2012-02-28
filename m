Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965783Ab2B1QRx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 11:17:53 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:33850 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965331Ab2B1QRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 11:17:52 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of dirk.brandewie@gmail.com designates 10.68.219.130 as permitted sender) smtp.mail=dirk.brandewie@gmail.com; dkim=pass header.i=dirk.brandewie@gmail.com
Message-ID: <4F4CFE2C.2020305@gmail.com>
Date: Tue, 28 Feb 2012 08:17:48 -0800
From: Dirk Brandewie <dirk.brandewie@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: dirk.brandewie@gmail.com
CC: linux-kernel@vger.kernel.org, cbouatmailru@gmail.com, dg77.kim@samsung.com,
        kyungmin.park@samsung.com, myungjoo.ham@samsung.com,
        Jason.Wortham@maxim-ic.com, bruce.e.robertson@intel.com
Subject: Re: [PATCH 0/5] MAX17042 add support for maxim POR procedure
References: <1327425968-21195-1-git-send-email-dirk.brandewie@gmail.com>
In-Reply-To: <1327425968-21195-1-git-send-email-dirk.brandewie@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping. Any further comments on this patch set?  Can it make the 3.4 merge
window?

TIA
--Dirk
On 01/24/2012 09:26 AM, dirk.brandewie@gmail.com wrote:
> From: Dirk Brandewie<dirk.brandewie@gmail.com>
>
> This patch set adds support for the power on reset procedure for the
> max17042 battery fuel gauge and alert interrupts.
>
> The accuracy of the fuel gauge is improved by configuring the fuel
> gauge with the characterization data for the battery present in the
> platform.
>
>
> Changes since v3:
> Patch added patch to fix scaling of VCELL register values reported
>
> Capacity property now used the reported SOC register to account for
> empty compensation in reported capacity.
>
> Fixed sparse/smatch warnings
>
> Changes since v2:
>
> Dropped patch moving non-POR init to worker function.
>
> Reorganized POR patch to only schedule worker thread if the fuel gauge
> is in the POR state
>
> Changes since v1:
>
> Moved power_supply_register() back to the probe max17042_get_property()
> will return -EAGAIN until the init function completes
>
> Added support for interrupts from the alert pin if the platform has it
> connected to an interrupt source.
>
> Added fix for the values returned by POWER_SUPPLY_PROP_VOLTAGE_NOW
> and POWER_SUPPLY_PROP_VOLTAGE_AVG.
>
> Added Ack's from previous patch series
>
>
> Bruce Robertson (1):
>    max17042: Fix value scaling for VCELL and avgVCELL
>
> Dirk Brandewie (4):
>    max17042: Align register definitions with data sheet and init appnote
>    max17042: Add POR init procedure from Maxim appnote
>    max17042: Add support for signalling change in SOC
>    max17042: Change capacity property to use reported SOC register
>
>   drivers/power/max17042_battery.c       |  452 +++++++++++++++++++++++++++++++-
>   include/linux/power/max17042_battery.h |   93 ++++++-
>   2 files changed, 522 insertions(+), 23 deletions(-)
>

