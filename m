Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756446Ab2GKHE0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 03:04:26 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:9380 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754096Ab2GKHEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 03:04:25 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Wed, 11 Jul 2012 00:04:24 -0700
Message-ID: <4FFD2568.6070404@nvidia.com>
Date: Wed, 11 Jul 2012 12:34:08 +0530
From: Venu Byravarasu <vbyravarasu@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1] usb: host: Fix possible kernel crash
References: <Pine.LNX.4.44L0.1207101108060.1308-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1207101108060.1308-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 10 July 2012 08:39 PM, Alan Stern wrote:
> On Tue, 10 Jul 2012, Venu Byravarasu wrote:
>
>> Thanks Alan for your comments.
>>
>> On Monday 09 July 2012 08:04 PM, Alan Stern wrote:
>>> On Mon, 9 Jul 2012, Venu Byravarasu wrote:
>>>
>>>> In functions itd_complete &  sitd_complete, a pointer
>>>> by name stream may get dereferenced after freeing it, when
>>>> iso_stream_put is called with stream->refcount = 2.
>>> I don't understand the problem.  Did you actually see this happen or is
>>> it only theoretical?
>> Yes it is a theoretical problem, as complained by Coverity.
>> As per the logic you explained above, this change is not needed.
>> However coverity was complaining as below:
>>
>> /kernel/drivers/usb/host/ehci-sched.c 1777 USE_AFTER_FREE Dereferencing
>> freed pointer "stream"
>>
>> Hence to pacify coverity, this change is done.
>> Please let me know if you see any other better way to handle it.
> This seems to be a false positive from Coverity.
>
> In any case, I'm about to submit some patches which get rid of the
> reference counting entirely.  So let's not worry about this.
>
> Alan Stern
>
Thanks Alan for taking care of it, in your future patch.




