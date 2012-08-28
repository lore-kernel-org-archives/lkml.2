Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752052Ab2H1MmH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 08:42:07 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:6897 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002Ab2H1MmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 08:42:05 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Tue, 28 Aug 2012 05:42:03 -0700
Message-ID: <503CB7A8.4050600@nvidia.com>
Date: Tue, 28 Aug 2012 17:50:56 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Rabin Vincent <rabin@rab.in>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "lrg@ti.com" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] regulator: disable supply regulator if it is enabled
 for boot-on
References: <1344938848-29606-1-git-send-email-ldewangan@nvidia.com> <5034AA28.5050306@nvidia.com> <20120823145308.GA28328@sirena.org.uk> <50364179.6070304@nvidia.com> <5037BF45.1070205@nvidia.com> <20120824233835.GA29178@ubuntu>
In-Reply-To: <20120824233835.GA29178@ubuntu>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 25 August 2012 05:10 AM, Rabin Vincent wrote:
> On Fri, Aug 24, 2012 at 11:22:05PM +0530, Laxman Dewangan wrote:
>> I tried to reproduce the issue but could not able to do this.
>> Can you please send me your board/dt files where you are porviding
>> platform data for regulator?
>> This will help me to reproduce the issue.
> Here's a dts patch:
>
Hi Rabin,

I tried to reproduce the lockup issue with the following change but not 
seeing any lockup issue.
I implement enable/disable for fixed regulator and printed the string as 
enable/disable
During registration I got the log as
[    0.349955] Registering the regulator vbat
[    0.354352] vbat: 3300 mV
[    0.357260] Registering the regulator vtest1
[    0.361810] fixed_enable(): Enabling vtest1
[    0.366144] vtest1: 3300 mV
[    0.369177] vtest1: supplied by vbat
::::::::::::::::

and when init_complete() get called then it happened as

[    1.509855] vtest1: disabling
[    1.512813] fixed_disable(): Disabling vtest1
[    1.517158] fixed_disable(): Disabling vbat
[    1.521342] vbat: disabling
[    1.524124] fixed_disable(): Disabling vbat


Also reviewing the change, I am not seeing any call trace where the 
recursive locking happening.

Please help to reproduce/understand the issue.


