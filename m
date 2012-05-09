Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751548Ab2EIEhq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 00:37:46 -0400
Received: from mail.palosanto.com ([200.93.199.101]:44018 "EHLO
	pbx.palosanto.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853Ab2EIEhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 00:37:45 -0400
X-Greylist: delayed 1494 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 May 2012 00:37:44 EDT
Message-ID: <4FA9EEAC.7010201@palosanto.com>
Date: Tue, 08 May 2012 23:12:28 -0500
From: =?ISO-8859-1?Q?Alex_Villac=EDs_Lasso?= <a_villacis@palosanto.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Francois Romieu <romieu@fr.zoreil.com>
CC: Thomas Pilarski <thomas.pi@arcor.de>,
        Julien Ducourthial <jducourt@free.fr>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] r8169: fix problem with TSO (TX_BUFFS_AVAIL negative
 value)
References: <1336430367.11363.38.camel@blackbone.local> <20120507234205.GA2230@electric-eye.fr.zoreil.com>
In-Reply-To: <20120507234205.GA2230@electric-eye.fr.zoreil.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El 07/05/12 18:42, Francois Romieu escribió:
> Julien Ducourthial<jducourt@free.fr>  :
>> The r8169 may get stuck or show bad behaviour after activating TSO :
>> the net_device is not stopped when it has no more TX descriptors.
>> This problem comes from TX_BUFS_AVAIL which may reach -1 when all
>> transmit descriptors are in use. The patch simply tries to keep positive
>> values.
> It seems more than good.
>
> Alex, Thomas, can you check if Julien's patch below fixes your broken
> kernels as well ?
>
No luck. The backtrace still appears after using the patched driver.
