Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452Ab1IGQm2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 12:42:28 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:50933 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753145Ab1IGQmK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 12:42:10 -0400
From: "Koyamangalath, Abhilash" <abhilash.kv@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        "Ravi, Deepthy" <deepthy.ravi@ti.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mchehab@infradead.org" <mchehab@infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Date: Wed, 7 Sep 2011 15:40:23 +0530
Subject: RE: [PATCH 1/2] omap3: ISP: Fix the failure of CCDC capture during
 suspend/resume
Thread-Topic: [PATCH 1/2] omap3: ISP: Fix the failure of CCDC capture during
 suspend/resume
Thread-Index: AcxnWNIS/oDxFYU1TtivNbQMcsIyhAF7YjzA
Message-ID: <FCCFB4CDC6E5564B9182F639FC356087037AF843C7@dbde02.ent.ti.com>
References: <1312984992-19315-1-git-send-email-deepthy.ravi@ti.com>,<201108302307.47564.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201108302307.47564.laurent.pinchart@ideasonboard.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, Aug 30, 2011  Laurent Pinchart wrote:
> Hi,
>
> On Wednesday 10 August 2011 16:03:12 Deepthy Ravi wrote:
>> From: Abhilash K V <abhilash.kv@ti.com>
>>
>> While resuming from the "suspended to memory" state,
>> occasionally CCDC fails to get enabled and thus fails
>> to capture frames any more till the next suspend/resume
>> is issued.
>> This is a race condition which happens only when a CCDC
>> frame-completion ISR is pending even as ISP device's
>> isp_pm_prepare() is getting called and only one buffer
>> is left on the DMA queue.
>> The DMA queue buffers are thus depleted which results in
>> its underrun.So when ISP resumes there are no buffers on
>> the queue (as the application which can issue buffers is
>> yet to resume) to start video capture.
>> This fix addresses this issue by dequeuing and enqueing
>> the last buffer in isp_pm_prepare() after its DMA gets
>> completed. Thus,when ISP resumes it always finds atleast
>> one buffer on the DMA queue - this is true if application
>> uses only 3 buffers.
>
> How is that problem specific to the CCDC ? Can't it be reproduce at the
> preview engine or resizer output as well ?
[Abhilash K V]Yes,  I believe this issue would crop with preview and resizer too though I have
not been able to try these out.
>
> --
> Regards,
>
> Laurent Pinchart
>

