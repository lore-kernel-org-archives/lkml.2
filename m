Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753743Ab2AZXsq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 18:48:46 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:47757 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751323Ab2AZXso convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 18:48:44 -0500
MIME-Version: 1.0
In-Reply-To: <20120124172231.GA27273@suse.de>
References: <CAPnjgZ0-VdAzudGFopBd+5j4HhOp10C=x0kPuJEZyaYSzwjBAA@mail.gmail.com>
	<Pine.LNX.4.44L0.1201211055180.24505-100000@netrider.rowland.org>
	<20120124165711.GC3836@linutronix.de>
	<20120124172231.GA27273@suse.de>
Date: Thu, 26 Jan 2012 15:48:43 -0800
X-Google-Sender-Auth: QZTMXEZBRuzXh00QV2IUDiNsFH4
Message-ID: <CAPnjgZ0a4i1eGRK_pjKuiaG=sXKGCHT8kO4segHxqN6L2wm8Qw@mail.gmail.com>
Subject: Re: [PATCH] usb: Use a workqueue in usb_add_hcd() to reduce boot time
From: Simon Glass <sjg@chromium.org>
To: Greg KH <gregkh@suse.de>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Alan Stern <stern@rowland.harvard.edu>,
        LKML <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Tue, Jan 24, 2012 at 9:22 AM, Greg KH <gregkh@suse.de> wrote:
> On Tue, Jan 24, 2012 at 05:57:11PM +0100, Sebastian Andrzej Siewior wrote:
>> * Alan Stern | 2012-01-21 11:11:09 [-0500]:
>>
>> >Doing time-consuming things later won't make any difference.  That is,
>> >suppose the boot sequence performs activities A and B, where A takes a
>> >long time.  Doing A later, so that the boot sequence performs B and
>> >then A, won't change the total time required.
>>
>> That is true. However if you show the gui _now_ and look for USB later
>> then it feels faster and this is usually enough.
>
> Which has been done before, with great success (i.e. we did it for
> Moblin boot times), so it shouldn't be that big of an issue.
>
> Which points out the question, exactly what is the issue here?  We have
> "multithreaded" pci driver startup for a long time now, did that stop
> working here?  If you use bootchart, does it show that the USB host
> driver is stoping the machine from proceeding to the next stage in the
> boot process?
>
> From my experience, I never saw the USB host controller get in the way
> at all, it was always somethine else happening that caused problems
> (i.e. video.)
>
> Simon, do you have boot charts anywhere showing this?

I did have initcall timing when I last looked at this. USB was holding
up progress. Sorry for the delay - I hope to get back to this next
week.

Regards,
Simon

>
> thanks,
>
> greg k-h
