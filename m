Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965325Ab0COQH2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 12:07:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52560 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965216Ab0COQH0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 12:07:26 -0400
Date: Mon, 15 Mar 2010 17:07:25 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Adam Nielsen <a.nielsen@shikadi.net>
Cc: LKML Mailinglist <linux-kernel@vger.kernel.org>
Subject: Re: usbhid: How to wait for response after submitting report
In-Reply-To: <4B9B022F.6060402@shikadi.net>
Message-ID: <alpine.LNX.2.00.1003151706330.18642@pobox.suse.cz>
References: <4B9B022F.6060402@shikadi.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 13 Mar 2010, Adam Nielsen wrote:

> I'm working on a USB HID driver, but my driver seems to be receiving bad data.
>  I think it's because usbhid_submit_report is non-blocking and I'm not
> correctly waiting for a response.  I'm not sure though, because none of the
> existing usbhid drivers seem to work in this way.
> 
> Could someone please let me know if I'm going about this the right way?
> 
>   odin_psu->report->field[0]->value[0] = msg;
>   odin_psu->report->field[0]->value[1] = 0x01;
> 
>   usbhid_submit_report(odin_psu->hdev, odin_psu->report, USB_DIR_OUT);
>   usbhid_wait_io(odin_psu->hdev);
> 
>   usbhid_submit_report(odin_psu->hdev, odin_psu->report_in, USB_DIR_IN);
>   usbhid_wait_io(odin_psu->hdev);

Hi Adam,

I am afraid you'll have to explain in more detail what exactly you are 
tying to achieve, and why the way the current HID code does it (i.e. URB 
gets submitted, completion handler is called when completed) doesn't work 
for you.

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
