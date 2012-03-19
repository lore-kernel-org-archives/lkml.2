Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030689Ab2CSGvv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 02:51:51 -0400
Received: from edison.jonmasters.org ([173.255.233.168]:58455 "EHLO
	edison.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030209Ab2CSGvu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 02:51:50 -0400
X-Greylist: delayed 1016 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Mar 2012 02:51:50 EDT
Mime-Version: 1.0 (Apple Message framework v1257)
Content-Type: text/plain; charset=windows-1252
From: Jon Masters <jonathan@jonmasters.org>
In-Reply-To: <CAKaWdxaaKMiwnhP7R786mqHTPs+o=izerZDbUgPBaxyU+XL-2g@mail.gmail.com>
Date: Mon, 19 Mar 2012 02:34:48 -0400
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <C141162D-9164-43D3-9A1F-93156DC7409B@jonmasters.org>
References: <CAKaWdxZGg-Xpw2E85bAr8BVgWtXxEitwsir=yXp5qS0FMUk1uQ@mail.gmail.com> <m1ehtd8qez.fsf@fess.ebiederm.org> <CAKaWdxbuwV6yQnX=4zcBZncL8f+7cXPFwx8ejw=6d=dX8NoZsw@mail.gmail.com> <87obshxt4w.fsf@xmission.com> <CAKaWdxa326eP47=nENh8_1NmRCadTB=o8jyWO2dAzZcn9yCwiA@mail.gmail.com> <87zkc1w6wp.fsf@xmission.com> <CAKaWdxa8yJJhnPj1th6GdYvn9+Lu7GUV1e=960gMQOdc8W47dQ@mail.gmail.com> <CAKaWdxaaKMiwnhP7R786mqHTPs+o=izerZDbUgPBaxyU+XL-2g@mail.gmail.com>
To: Keith Chew <keith.chew@gmail.com>
X-Mailer: Apple Mail (2.1257)
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
Subject: Re: Hang on "echo b > /proc/sysrq-trigger"
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Nov 2009 07:31:22 +0000)
X-SA-Exim-Scanned: Yes (on edison.jonmasters.org)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Keith,

I've just been reviewing LKML for the past month…was there ever any followup?
Perhaps it's worth discussing a patch to change the below delay?

Jon.

On Mar 10, 2012, at 6:45 PM, Keith Chew wrote:

> Hi Eric
> 
> Keep a quick update...
> 
>>> I would check with your BIOS folks and perhaps play with the kernel
>>> option.  The most reliable way to peform a reset is to trigger a board
>>> reset by writing to 0xcf9 or a similar register.  I expect your BIOS
>>> does that and you can probably get the kernel to do that.  I would
>>> definitely test to see if you can write to the mostly standard
>>> 0xcf9 register directly from the kernel and trigger a reset directly.
>>> 
> 
> Thank you very much for this. We have tried with reboot=p, which is
> writing to the 0xCF9 register directly, and the test has been running
> good for the past 9 days. Will keep monitoring it.
> 
> Also, I have also added a delay in the KBD reboot, which appears to
> have made the reboot reliable (running good for past 8 days, before it
> would hang after 2 days):
> -----------------------
> kb_wait();
> udelay(150); <------ Increased from 50
> outb(0xfe, 0x64); /* pulse reset low */
> udelay(50);
> -----------------------
> 
> Looks like the code may be issuing the reboot a bit too early after
> returning from kb_wait().
> 
> Regards
> Keith
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

