Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932746Ab0EYXOx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 19:14:53 -0400
Received: from smtp.microsoft.com ([131.107.115.215]:36904 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932370Ab0EYXOw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 19:14:52 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Ky Srinivasan <ksrinivasan@novell.com>, Greg KH <gregkh@suse.de>
CC: "'devel@driverdev.osuosl.org'" <devel@driverdev.osuosl.org>,
       "'virtualization@lists.osdl.org'" <virtualization@lists.osdl.org>,
       "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/1] staging: hv: Fix race condition on IC channel
	 initialization
Thread-Topic: [PATCH 1/1] staging: hv: Fix race condition on IC channel
	 initialization
Thread-Index: AQHK+cJx3lHuMTU1SkOkLfigiRlmsZJiydVA
Date: Tue, 25 May 2010 23:14:48 +0000
Message-ID: <1FB5E1D5CA062146B38059374562DF7266B8C0B7@TK5EX14MBXC128.redmond.corp.microsoft.com>
References: <1FB5E1D5CA062146B38059374562DF7266B8AE7C@TK5EX14MBXC128.redmond.corp.microsoft.com>
 <20100521201228.GA6712@suse.de>
 <1FB5E1D5CA062146B38059374562DF7266B8B5F2@TK5EX14MBXC128.redmond.corp.microsoft.com>
 <4BF7A20602000030000859E3@sinclair.provo.novell.com>
In-Reply-To: <4BF7A20602000030000859E3@sinclair.provo.novell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Ky Srinivasan [mailto:ksrinivasan@novell.com]
> You would need to protect the increment, if interrupts are going to
> come in on any cpu and update the counter. While in your current
> implementation interrupts are only delivered on cpu0, it is still
> probably good to deal with the more general case and protect the
> counter.
> 
> On a slightly different note, why don't you make the synchronization
> more explicit than what you currently have: Rather than polling the
> variable in a loop, why don't you put that context to sleep and the
> interrupt context that updates the count would be responsible for
> issuing the wakeup when the conditions are appropriate - when all
> channels are initialized.

Thank you for the suggestion. I will keep the counter atomic to handle 
more general case potentially. To ensure channels are ready before 
vmbus_init() returns, I used an event waiting mechanism instead of 
polling the variable periodically. A modified patch will be submitted 
soon.

Thanks,

- Haiyang

