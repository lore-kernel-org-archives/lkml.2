Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542Ab2ACAXR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 19:23:17 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:55716 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753477Ab2ACAXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 19:23:14 -0500
X-Sasl-enc: +XnnFSe5DZZJCaUCG+urZgkJMcRHjKeAYskoiY1kdhQH 1325550193
References: <20120102211904.GA15316@srcf.ucam.org> <CA+55aFwJuuvqcsgHnZ4-VhUhbVvL6beKogo1adgYyZt_ZM=H7A@mail.gmail.com> <20120102215028.GA15701@srcf.ucam.org> <CA+55aFz73GuHiOW1NoAuJLea_GKLepiZjrnrgpOKdQizPgnhoA@mail.gmail.com> <20120102221235.GA16012@srcf.ucam.org> <CA+55aFyHvmvast_kuNddU3iotReR1mOpKM4HGAw80ma8kn+2-g@mail.gmail.com> <20120102222920.GA16160@srcf.ucam.org> <CA+55aFyUK6X7ip2UXV9iT07=qezXfbw82wn6UKAN8JFQtYNs5Q@mail.gmail.com> <20120102230037.GA16458@srcf.ucam.org> <4F023E6B.2020307@fastmail.fm> <20120103001356.GA17183@srcf.ucam.org>
User-Agent: K-9 Mail for Android
In-Reply-To: <20120103001356.GA17183@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: loading firmware while usermodehelper disabled.
From: Jack Stone <jwjstone@fastmail.fm>
Date: Tue, 03 Jan 2012 00:22:58 +0000
To: Matthew Garrett <mjg@redhat.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oliver@neukum.org>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        "John W. Linville" <linville@tuxdriver.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>
Message-ID: <8e95c7e3-e9d5-43c4-8e6a-b8d40584cbd6@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Matthew Garrett <mjg@redhat.com> wrote:

>On Mon, Jan 02, 2012 at 11:31:55PM +0000, Jack Stone wrote:
>
>> Rather than merging the drivers we could make the uvcvideo (or any
>other
>> generic driver) driver expose a "subdriver" interface that allows
>> another module to bind to the specific ID and add extra handling to
>> certain events. We could then use that interface to provide a
>firmware
>> driver for each device that needs it. The firmware driver could bind
>to
>> the bootstrap device and to the uvcvideo subdriver interface and it
>> would then have all the lifetime info we need. [Credit to Linus for
>> suggesting this idea]
>
>No, the uvcvideo driver would need to call out to load the firmware 
>loader driver, otherwise you'll never know to load the firmware loader 
>driver.

So we have a table of USB ids that list the devices that need firmware drivers. When the uvcvideo driver registers the firmware interface with a USB id that matches the list we load the firmware driver and pass it a "warm start" event so it can cache the firmware.

As long as we can identify the devices that *might* need firmware then we are ok.

Thanks,

Jack

-- 
Sent from my Android phone with K-9 Mail. Please excuse my brevity.
