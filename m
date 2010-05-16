Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925Ab0EPKks (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 06:40:48 -0400
Received: from smtp128.mail.ukl.yahoo.com ([77.238.184.59]:34951 "HELO
	smtp128.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752129Ab0EPKkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 06:40:47 -0400
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Sun, 16 May 2010 06:40:46 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=S1LN1iCjItvbRq7hPg9QYKrPIFX4wrKKHP2q2V6leaIq/y25dq9x0P2JYAkCXn/9XRJCk74MiW5dCxIXvs0wAL5cN7tc8CRRdxF7aXGiTn7UPpM4vaRi41XlKkTd6W8plAfyk0/ZdYknWHsnsKy/eM8Y9oOLWmj8ZdAZkNi+pkk=  ;
X-Yahoo-SMTP: pBUX04qswBBDzuR5UAvE0Uc4jpf04Q--
X-YMail-OSG: f4JxVtcVM1l_ky6RlqlUE0MxqPxXvEC3JkzGAZ17LgmfPFptTqdcXaahoZYx4ooNWPrsEC89AgBcH9CRZPFVWJ7IIHKjJnzIoKbOekfsMu0TJ7oFFsFBcwSBaaiFJt3acGnMvZglbdDvMhwD5lC1nu_ti_S4naIjTCNaiV5YcLJYFd9orqePRzS2vTNdGaHH7Aw9r3XT.UiIH5lbqZQl4Y1hXIH.6N8wbbfvmLaLTjp7cg--
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4BEFCA05.8000402@yahoo.de>
Date: Sun, 16 May 2010 12:33:41 +0200
From: Robert Schedel <r.schedel@yahoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100411 Thunderbird/3.0.4
MIME-Version: 1.0
To: dhprince.devel@yahoo.co.uk
CC: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.34-rc7] HID: hid-samsung: add support for Creative
 Desktop Wireless 6000
References: <4BEF3D1F.6080403@yahoo.co.uk>
In-Reply-To: <4BEF3D1F.6080403@yahoo.co.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 16.05.2010 02:32, Don Prince wrote:
> Add support for the Creative Desktop Wireless 6000 keyboard/mouse
> bundle's multimedia buttons which are not currently handled by
> the default/samsung HID driver.
> 
> Signed-off-by: Don Prince <dhprince-devel@yahoo.co.uk>
> 
> ---
> [...]

As originator of the "old" 0419:0001 IrDA driver parts had a short look at it:
- Merging with old code looks OK. Tested with old 0419:0001 (184) device, still functional.
- 0419:0600 not yet known in usb.ids, might be worth a contribution
- As you merged in a new device, and for explaining why this handling was added, my suggestion is to adapt the existing comments, e.g.:

/*
 * This driver supports several HID devices:
 *
 * [0419:0001] Samsung IrDA remote controller (reports as Cypress USB Mouse).
 *
 * There are several variants:
 *
 * 1. 184 byte report descriptor
[...]
 * [0419:0600] Creative Desktop Wireless 6000 keyboard/mouse combo
 *
 * Several key mappings used from the consumer usage page
 * deviate from the USB HUT 1.12 standard.
 */

Of course some HID maintainer should also review it, for general policy.

Regards,
Robert Schedel
