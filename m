Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757134Ab1LBQew (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 11:34:52 -0500
Received: from mail.windriver.com ([147.11.1.11]:61743 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756990Ab1LBQeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 11:34:50 -0500
Message-ID: <4ED8FE14.7020007@windriver.com>
Date: Fri, 2 Dec 2011 11:34:28 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110922 Thunderbird/3.1.15
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Kumar Gala <galak@kernel.crashing.org>,
        Scott Wood <scottwood@freescale.com>, <gregkh@suse.de>,
        <alan@linux.intel.com>, <linux-serial@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] 8250: add workaround for MPC8[356]xx UART break IRQ
 storm
References: <1322783258-20443-1-git-send-email-paul.gortmaker@windriver.com>	<1322783258-20443-4-git-send-email-paul.gortmaker@windriver.com>	<4ED812E4.60905@freescale.com>	<4ED81632.3030809@windriver.com>	<176AE2A1-6AA2-4F14-942F-8ED77AB1DBEC@kernel.crashing.org> <20111202113059.15d73840@lxorguk.ukuu.org.uk>
In-Reply-To: <20111202113059.15d73840@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-12-02 06:30 AM, Alan Cox wrote:
>>> OK, I'll simply change the above to CONFIG_PPC then.
>>
>> It does, the bug is in the uart IP which I don't think we ever plan on fixing, so 32 or 64-bit parts will have it for ever and ever ;)
> 
> It should be runtime selected, there should be no ifdefs here.

The ifdef wasn't strictly required; it just made it so gcc would
toss the errata code out of the irq handler for !PPC.  Anyway it
will be a moot point if I can somehow hide all the mess by snooping
serial_inp() traffic and deploying the errata fix from there....

P.

> 
