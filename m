Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757122Ab2BWV1l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 16:27:41 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:49444 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754369Ab2BWV1k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 16:27:40 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of bobbypowers@gmail.com designates 10.229.137.18 as permitted sender) smtp.mail=bobbypowers@gmail.com; dkim=pass header.i=bobbypowers@gmail.com
MIME-Version: 1.0
In-Reply-To: <20120223195026.GA30895@merkur.ravnborg.org>
References: <1330023731-14043-1-git-send-email-bobbypowers@gmail.com>
	<alpine.DEB.2.00.1202231927240.24797@skynet.skynet.ie>
	<20120223195026.GA30895@merkur.ravnborg.org>
Date: Thu, 23 Feb 2012 16:27:39 -0500
Message-ID: <CAArOQ2Xw2MCeRNkRD1Week_Gq9xG0URrGNRyLs_GgFGYPF3_Qg@mail.gmail.com>
Subject: Re: [PATCH] linux headers: include linux/types.h where appropriate
From: Bobby Powers <bobbypowers@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Dave Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, davem@davemloft.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 23, 2012 at 2:50 PM, Sam Ravnborg <sam@ravnborg.org> wrote:
> On Thu, Feb 23, 2012 at 07:28:10PM +0000, Dave Airlie wrote:
>>
>> > This silences the related header check warnings.
>>
>> please fix the bug in the correct place, the drm.h header includes
>> linux/types.h and this is one on purpose.
>>
>> maybe expend some effort fixing the stupid tool to recurse like a normal
>> preprocessor would.
>
> Before we fix the tool maybe we should agree on what the tool should check for.
> One obvious thing to check is that we do not start to use user-land
> types in our exported headers like uint32_t etc.
> Another could be that no header file should depend oon the user to include other
> header files.
> Etc.

I just sent out a patch that recursively checks for including types.h,
as it was quite simple.  Additional checks seem like they may be a
good idea, but not something that has to be decided right here.

> The checks we have implmented today are very conservative - but as you resist
> to add a few includes in the drm/drm*.h files prevents us from hitting
> zero warnings even with these conservative checks.
>
> If we started to be more strict we would see much more warnings/errors.
> But all this fuzz about a handfull of includes in the drm header files
> sure scare me away from ever starting this.
> I can only image the uproar some other changes may cause then.

Interestingly, with headers_check searching for types.h recursively
(clearing up some noise), include/drm/drm_mode.h stands out as still
needing to include <linux/types.h>, as it doesn't import drm.h.

>
>        Sam
