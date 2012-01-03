Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615Ab2ACAlz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 19:41:55 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:46062 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753461Ab2ACAlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 19:41:52 -0500
X-Sasl-enc: MV3NO08OH7AmnzWAOw90aOHTuePyyAQr7BbliqgX5Iks 1325551311
References: <20120102211904.GA15316@srcf.ucam.org> <CA+55aFwJuuvqcsgHnZ4-VhUhbVvL6beKogo1adgYyZt_ZM=H7A@mail.gmail.com> <20120102215028.GA15701@srcf.ucam.org> <CA+55aFz73GuHiOW1NoAuJLea_GKLepiZjrnrgpOKdQizPgnhoA@mail.gmail.com> <20120102221235.GA16012@srcf.ucam.org> <CA+55aFyHvmvast_kuNddU3iotReR1mOpKM4HGAw80ma8kn+2-g@mail.gmail.com> <20120102222920.GA16160@srcf.ucam.org> <CA+55aFyUK6X7ip2UXV9iT07=qezXfbw82wn6UKAN8JFQtYNs5Q@mail.gmail.com> <20120102230037.GA16458@srcf.ucam.org> <4F023E6B.2020307@fastmail.fm> <20120103001356.GA17183@srcf.ucam.org> <8e95c7e3-e9d5-43c4-8e6a-b8d40584cbd6@email.android.com> <20120103003126.52ad9077@pyramind.ukuu.org.uk>
User-Agent: K-9 Mail for Android
In-Reply-To: <20120103003126.52ad9077@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: loading firmware while usermodehelper disabled.
From: Jack Stone <jwjstone@fastmail.fm>
Date: Tue, 03 Jan 2012 00:41:34 +0000
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Matthew Garrett <mjg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oliver@neukum.org>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        "John W. Linville" <linville@tuxdriver.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>
Message-ID: <089f1112-758b-4006-ba47-64ce4bc1409f@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

>> So we have a table of USB ids that list the devices that need
>firmware drivers. When the uvcvideo driver registers the firmware
>interface with a USB id that matches the list we load the firmware
>driver and pass it a "warm start" event so it can cache the firmware.
>> 
>> As long as we can identify the devices that *might* need firmware
>then we are ok.
>
>You just broke the module loading guarantees that stop it all coming
>apart
>in the first place. Probably not in many real world ways but not good.
>
>If we warm booted from Windows into Linux and then suspended then on
>resume we won't have the driver for the firmware loaded present - we
>never saw the 'need firmware' id.

I agree we won't see the need firmware id but we should still be able to identify the device from some of its ids shouldn't we? We could then cache the firmware even though we never loaded it.

>That moves us from a dependancy chain for firmware to one including
>firmware and modules (imagine /lib/modules over iscsi for an iscsi
>adapter needing firmware).
>
>At the moment I don't think anyone has been dumb enough to do firmware
>requiring storage and NFS root over firmware requiring USB devices is
>pretty dumb. I don't however think it's a good hole to dig ?

I'm sure someone will try it at somepoint...

Thanks,

Jack

-- 
Sent from my Android phone with K-9 Mail. Please excuse my brevity.
