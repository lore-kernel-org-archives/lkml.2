Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228Ab1LSUV6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 15:21:58 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:55566 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639Ab1LSUVy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 15:21:54 -0500
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1112152228030.22491-100000@netrider.rowland.org>
References: <CAMP44s3eeTOBRiFwEL3FypDY_+-MReqYJJVO1URNrnFVFXzvDg@mail.gmail.com>
	<Pine.LNX.4.44L0.1112152228030.22491-100000@netrider.rowland.org>
Date: Mon, 19 Dec 2011 22:21:53 +0200
Message-ID: <CAMP44s08LPo5Fp+jjictn48bMLo9R0OyGryYw32Bup6TqmCxEQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] usb: musb: fix pm_runtime mismatches
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, Jiri Kosina <trivial@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 16, 2011 at 5:30 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Fri, 16 Dec 2011, Felipe Contreras wrote:
>> > Should these calls be pm_runtime_put_sync() instead of
>> > pm_runtime_put()?
>>
>> I don't see why... The thing failed, it's not going to be used any
>> more so better let PM deactivate the device.
>
> It's not a big deal.  The difference is that pm_runtime_put_sync()
> avoids an extra context switch when suspending the device.  A minor
> optimization, that's all.

Ok, I used what most of the code was using, but I've trusted you and
updated the patches. It would probably make sense to do the same in
other places.

-- 
Felipe Contreras
