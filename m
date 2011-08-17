Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494Ab1HQSn0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 14:43:26 -0400
Received: from smtp.microsoft.com ([131.107.115.215]:22196 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752976Ab1HQSnZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 14:43:25 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Sasha Levin <levinsasha928@gmail.com>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: [PATCH 2/8] Staging: hv: vmbus: Invoke vmbus_on_msg_dpc()
 directly
Thread-Topic: [PATCH 2/8] Staging: hv: vmbus: Invoke vmbus_on_msg_dpc()
 directly
Thread-Index: AQHMW5WZ/QXPkP6eVk60VTPXCgO/oZUhdeiA///rDYA=
Date: Wed, 17 Aug 2011 18:43:24 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E04808194C66@TK5EX14MBXC126.redmond.corp.microsoft.com>
References: <1313446210-10611-1-git-send-email-kys@microsoft.com>
	 <1313446327-10650-1-git-send-email-kys@microsoft.com>
	 <1313446327-10650-2-git-send-email-kys@microsoft.com>
 <1313585267.15004.3.camel@lappy>
In-Reply-To: <1313585267.15004.3.camel@lappy>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.36]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Sasha Levin [mailto:levinsasha928@gmail.com]
> Sent: Wednesday, August 17, 2011 8:48 AM
> To: KY Srinivasan
> Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org; Haiyang Zhang
> Subject: Re: [PATCH 2/8] Staging: hv: vmbus: Invoke vmbus_on_msg_dpc()
> directly
> 
> On Mon, 2011-08-15 at 15:12 -0700, K. Y. Srinivasan wrote:
> > The message processing function needs to execute on the same CPU where
> > the interrupt was taken. tasklets cannot gurantee this; so, invoke the
> > function directly.
> >
> > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> > ---
> 
> tasklets are guaranteed to run on the same CPU as the function that
> scheduled them.
> 
> Unless I'm missing something?

I too was under this impression until I stumbled upon this comment in
include/Linux/interrupt.h where I see that there is no guarantee that
tasklet would run on the same CPU that it was scheduled on
(look at the first listed property):

/* Tasklets --- multithreaded analogue of BHs.

   Main feature differing them of generic softirqs: tasklet
   is running only on one CPU simultaneously.

   Main feature differing them of BHs: different tasklets
   may be run simultaneously on different CPUs.

   Properties:
   * If tasklet_schedule() is called, then tasklet is guaranteed
     to be executed on some cpu at least once after this.
.
.
*/

Given this comment here, I felt that safest thing to do would be to just
not use the tasklet in this scenario.

Regards,

K. Y

