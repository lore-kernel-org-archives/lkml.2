Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760Ab1IERjH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 13:39:07 -0400
Received: from mga14.intel.com ([143.182.124.37]:53818 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751930Ab1IERi7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 13:38:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,334,1312182000"; 
   d="scan'208";a="45740262"
From: "Nallasellan, Singaravelan" <singaravelan.nallasellan@intel.com>
To: "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 5 Sep 2011 23:08:53 +0530
Subject: Player Thread is not woken after period elapsed
Thread-Topic: Player Thread is not woken after period elapsed
Thread-Index: Acxr8qpKdD/inT3XSSCim3TexQToDA==
Message-ID: <3CA6C6D9F70D314CA34352990B57DA1507C420F147@bgsmsx502.gar.corp.intel.com>
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

Hi,

When I tried to root cause a glitch in the audio playback, I found a weird behavior. 

User thread which invokes the writei function which in turn  invokes a kernel function which waits for the free buffer to write the audio data.  This kernel function adds this thread to a wake(sleep) queue  and calls a schedule_timeout (msecs_to_jiffies(10000)).

When the audio playback of a period is completed, the hardware generates an interrupt. The handler in the path wake_up the thread added to the sleep queue.  Most of the time, the playback thread is woken up.

During this error case, the thread is not getting woken up. However the sleep queue is not empty.  This continues until the playback enter into underrun due to all the periods in the buffer are played back. Audio playback continues after recovery from xrun. 

Will you provide some hint on how to go about identifying the root cause?

Thanks
-Sing
