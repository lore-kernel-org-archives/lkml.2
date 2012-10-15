Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485Ab2JONVQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 09:21:16 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:39902 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753353Ab2JONVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 09:21:15 -0400
MIME-Version: 1.0
In-Reply-To: <1921559.OPsFBnvatA@linux-lqwf.site>
References: <1350278059-14904-1-git-send-email-ming.lei@canonical.com>
	<2564763.3cNFlv543H@linux-lqwf.site>
	<CACVXFVPi=fq1NP-nuWQi34xTpGgWbaceW1Hbzcq38RqQMF_T-w@mail.gmail.com>
	<1921559.OPsFBnvatA@linux-lqwf.site>
Date: Mon, 15 Oct 2012 21:21:13 +0800
Message-ID: <CACVXFVM9bSX+iMx_7Z+S=HsNqNTpR0=qU3MeDQ1wD1LLM0UK-g@mail.gmail.com>
Subject: Re: [RFC PATCH 3/3] USB: forbid memory allocation with I/O during bus
 reset if storage interface exits
From: Ming Lei <ming.lei@canonical.com>
To: Oliver Neukum <oneukum@suse.de>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 15, 2012 at 8:30 PM, Oliver Neukum <oneukum@suse.de> wrote:

>
> All network devices?

Good point, but I am wondering if there are guys who would like to
bring up iSCSI over usb network dongle, which should be
very slow at least with high speed.  For super speed device,
looks there are few network dongles in market now.

So how about keeping the limit now?

We can remove the limit or extend it to network device if there are
some USB 3.0 network dongles coming.

>
>> > we will see busses attached to busses and as soon as the daughter
>> > bus is hotpluggable you are thwarted anyway. Just do it unconditionally.
>>
>> IMO, doing it unconditionally is not good because big chunk buffer
>> is often allocated in probe() path.
>
> It would be a chunk that has just been freed.

The reset will last for a bit long time, and many memory allocations
are involved inside usb_reset_and_verify_device(), so it might be
hard to get the previous chunk.

Thanks,
--
Ming
