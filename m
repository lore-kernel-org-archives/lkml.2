Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732Ab2DICQv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 22:16:51 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33910 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754080Ab2DICQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 22:16:49 -0400
Message-ID: <4F82468E.5000308@lwfinger.net>
Date: Sun, 08 Apr 2012 21:16:46 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120312 Thunderbird/11.0
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, jrh <jharbestonus@gmail.com>
Subject: Re: [PATCH] media: au0828: Convert BUG_ON to WARN_ONCE
References: <1333927151-13014-1-git-send-email-Larry.Finger@lwfinger.net> <CAGoCfixO1mUO0VGBL9GzOmaWpQ6rVos095reFfUWnVwCj0CyYg@mail.gmail.com>
In-Reply-To: <CAGoCfixO1mUO0VGBL9GzOmaWpQ6rVos095reFfUWnVwCj0CyYg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2012 08:46 PM, Devin Heitmueller wrote:
> On Sun, Apr 8, 2012 at 7:19 PM, Larry Finger<Larry.Finger@lwfinger.net>  wrote:
>> In the mail thread at http://www.mythtv.org/pipermail/mythtv-users/2012-April/331164.html,
>> a kernel crash is triggered when trying to run mythtv with a HVR950Q tuner.
>> The crash condition is due to res_free() being called to free something that
>> has is not reserved. The actual reason for this mismatch of reserve/free is
>> not known; however, using a BUG_ON rather than a WARN_ON seems unfortunate.
>
> This patch should be nack'd.  The real reason should be identified,
> and a patch should be submitted for that (and from what I gather, it
> seems like it is easily reproduced by the submitter).  Just add a few
> "dump_stack()" calls in the res_get() and res_free() calls to identify
> the failing call path.

I agree that we need to find the real cause; however, I am not the one with the 
problem, and I do not have the hardware. In addition, I am not sure how much 
additional debug information the person will be able to provide. He has not 
built Linux kernels since 1.2. If he can get a kernel built, then we will try to 
find the real cause.

In any case, why the reluctance to get rid of the BUG_ON? Is this condition so 
severe that the kernel needs to be stopped immediately?

Larry
