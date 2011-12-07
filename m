Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754286Ab1LGKNW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 05:13:22 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:62693 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752672Ab1LGKNU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 05:13:20 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 1/2] [media] V4L: atmel-isi: add code to enable/disableISI_MCK clock
Date: Wed, 7 Dec 2011 18:12:52 +0800
Message-ID: <4C79549CB6F772498162A641D92D5328039E9C15@penmb01.corp.atmel.com>
In-Reply-To: <20111207084958.GA14542@n2100.arm.linux.org.uk>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 1/2] [media] V4L: atmel-isi: add code to enable/disableISI_MCK clock
Thread-Index: Acy0vXac6wVmRO8URuS9xPiuiUNkvQACm+0Q
References: <1322647604-30662-1-git-send-email-josh.wu@atmel.com> <20111207084958.GA14542@n2100.arm.linux.org.uk>
From: "Wu, Josh" <Josh.wu@atmel.com>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Cc: <g.liakhovetski@gmx.de>, <linux-media@vger.kernel.org>,
        "Ferre, Nicolas" <Nicolas.FERRE@atmel.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
X-OriginalArrivalTime: 07 Dec 2011 10:12:55.0382 (UTC) FILETIME=[C97DB760:01CCB4C8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Russell King

On Wed, Dec 07, 2011 at 4:50 PM, Russell King wrote:

> On Wed, Nov 30, 2011 at 06:06:43PM +0800, Josh Wu wrote:
>> +	/* Get ISI_MCK, provided by programmable clock or external clock
*/
>> +	isi->mck = clk_get(dev, "isi_mck");
>> +	if (IS_ERR_OR_NULL(isi->mck)) {

> This should be IS_ERR()

So it means the clk_get() will never return NULL even when clk structure
is NULL in clk lookup entry. Right?

>> +		dev_err(dev, "Failed to get isi_mck\n");
>> +		ret = isi->mck ? PTR_ERR(isi->mck) : -EINVAL;

>		ret = PTR_ERR(isi->mck);

Best Regards,
Josh Wu
