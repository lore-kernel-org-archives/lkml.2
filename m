Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753032Ab2KQFQ2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 00:16:28 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:35134 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342Ab2KQFQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 00:16:27 -0500
Message-ID: <50A71DA5.2070905@linux.vnet.ibm.com>
Date: Fri, 16 Nov 2012 23:16:21 -0600
From: Trey Ramsay <tramsay@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Chris Ball <cjb@laptop.org>
CC: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        Rich Rattanni <rattanni@gmail.com>,
        Radovan Lekanovic <lekanovic@gmail.com>
Subject: Re: [PATCH 1/1] mmc: Bad device can cause mmc driver to hang
References: <87k3tpkz53.fsf@octavius.laptop.org> <1353079901-8773-1-git-send-email-tramsay@linux.vnet.ibm.com> <876255bluf.fsf@octavius.laptop.org> <50A6D1C7.302@linux.vnet.ibm.com> <87mwyh9ia0.fsf@octavius.laptop.org>
In-Reply-To: <87mwyh9ia0.fsf@octavius.laptop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12111705-2398-0000-0000-00000DCEB289
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000295; HX=3.00000198; KW=3.00000007;
 PH=3.00000001; SC=3.00000008; SDB=6.00192001; UDB=6.00043485; UTC=2012-11-17
 05:16:26
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/16/2012 06:37 PM, Chris Ball wrote:
> Hi Trey, thanks for the analysis,
> 
> On Fri, Nov 16 2012, Trey Ramsay wrote:
>> Good question.  In regards to the original problem were it was hung in
>> mmc_blk_err_check, the new code path will timeout after 10 minutes, log
>> an error, issue a hardware reset and abort the request. Is the hardware
>> reset enough or will that even work when the device isn't coming out of
>> program state? Should we try to refuse all new I/O?
> 
> mmc_hw_reset() only works for eMMC devices with a hooked up reset GPIO
> -- not SD cards -- and at the moment there's only one system (Intel
> Medfield) that supplies a GPIO, so that's not a general solution.
> 
> Maybe we should just merge your patch for now; we'll definitely get at
> least a pr_err() explaining what's going on, which is an improvement.
> Next time someone hits this (if anyone has an SD card that exhibits
> this problem, it'd be very valuable for testing) we can look at going
> farther, such as immediately setting host->flags |= SDHCI_DEVICE_DEAD.
> What do you think?
> 
> - Chris.
> 

Hi Chris,
Sounds good.  Thanks for the explanation. Setting host->flags |=
SDHCI_DEVICE_DEAD is a great idea.  I'll check with my team to see if we
have any hardware that exhibits this problem.  If we do, I can do some
testing on the code you suggested.

Thanks,
Trey

