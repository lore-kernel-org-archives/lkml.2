Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751275Ab2KVTqy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:46:54 -0500
Received: from ogre.sisk.pl ([193.178.161.156]:60713 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755919Ab2KVTqu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:46:50 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Cyril Roelandt <tipecaml@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, lenb@kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] acpi_system_write_wakeup_device(): fix error check for unsigned variable.
Date: Thu, 22 Nov 2012 01:23:24 +0100
Message-ID: <1645783.2WuR77RKxS@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0-rc6; KDE/4.9.3; x86_64; ; )
In-Reply-To: <50AD6C4A.4030809@gmail.com>
References: <1353117263-6957-1-git-send-email-tipecaml@gmail.com> <1732852.VDXGV3Ao2T@vostro.rjw.lan> <50AD6C4A.4030809@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, November 22, 2012 01:05:30 AM Cyril Roelandt wrote:
> On 11/21/2012 01:44 AM, Rafael J. Wysocki wrote:
> > On Saturday, November 17, 2012 02:54:23 AM Cyril Roelandt wrote:
> >> The LEN variable is unsigned, therefore checking whether it is less than 0 is
> >> useless.
> >>
> >> Signed-off-by: Cyril Roelandt<tipecaml@gmail.com>
> >> ---
> >>   drivers/acpi/proc.c |    2 --
> >>   1 file changed, 2 deletions(-)
> >>
> >> diff --git a/drivers/acpi/proc.c b/drivers/acpi/proc.c
> >> index 27adb09..37871a7 100644
> >> --- a/drivers/acpi/proc.c
> >> +++ b/drivers/acpi/proc.c
> >> @@ -366,8 +366,6 @@ acpi_system_write_wakeup_device(struct file *file,
> >>
> >>   	if (len>  4)
> >>   		len = 4;
> >> -	if (len<  0)
> >> -		return -EFAULT;
> >
> > I would prefer to check if count<  0 instead.
> >
> 
> 
> count has type size_t, so it is also an unsigned variable. I think that 
> acpi_system_write_wakeup_device really cannot be called with a "count" 
> parameter that is less than 0.

OK

So I suppose we can just drop len entirely and replace it with count, right?
[And drop the < 0 check too.]

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
