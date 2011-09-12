Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758181Ab1ILPbq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 11:31:46 -0400
Received: from e24smtp04.br.ibm.com ([32.104.18.25]:48112 "EHLO
	e24smtp04.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757915Ab1ILPbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 11:31:44 -0400
Message-ID: <4E6E25CC.5020101@br.ibm.com>
Date: Mon, 12 Sep 2011 12:31:24 -0300
From: Breno Leitao <brenohl@br.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Lucas Kannebley Tavares <lucaskt@linux.vnet.ibm.com>
CC: Thadeu Lima De Souza Cascardo <cascardo@linux.vnet.ibm.com>,
        Alan Cox <alan@linux.intel.com>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] jsm: Fixed EEH recovery error
References: <1315834565-9280-1-git-send-email-lucaskt@linux.vnet.ibm.com>
In-Reply-To: <1315834565-9280-1-git-send-email-lucaskt@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 11091215-8936-0000-0000-0000046CB142
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2011 10:36 AM, Lucas Kannebley Tavares wrote:
> There was an error on the jsm driver that would cause it to be unable to
> recover after a second error is detected.
>
> At the first error, the device recovers properly:
>
> [72521.485691] EEH: Detected PCI bus error on device 0003:02:00.0
> [72521.485695] EEH: This PCI device has failed 1 times in the last hour:
> ...
> [72532.035693] ttyn3 at MMIO 0x0 (irq = 49) is a jsm
> [72532.105689] jsm: Port 3 added
>
> However, at the second error, it cascades until EEH disables the device:
>
> [72631.229549] Call Trace:
> ...
> [72641.725687] jsm: Port 3 added
> [72641.725695] EEH: Detected PCI bus error on device 0003:02:00.0
> [72641.725698] EEH: This PCI device has failed 3 times in the last hour:
>
> It was caused because the PCI state was not being saved after the first
> restore. Therefore, at the second recovery the PCI state would not be
> restored.
>
> Signed-off-by: Lucas Kannebley Tavares<lucaskt@linux.vnet.ibm.com>
Signed-off-by: Breno Leitao <brenohl@br.ibm.com>

