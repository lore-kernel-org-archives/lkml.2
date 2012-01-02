Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302Ab2ABUzM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 15:55:12 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:47675 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752606Ab2ABUzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 15:55:10 -0500
X-Sasl-enc: 61ss7RgdLGfhKjnWq7iEX3u+7WUAW1a5shUUqDpYLTX1 1325537709
Message-ID: <4F0219AB.6010505@fastmail.fm>
Date: Mon, 02 Jan 2012 20:55:07 +0000
From: Jack Stone <jwjstone@fastmail.fm>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Alan Stern <stern@rowland.harvard.edu>, Oliver Neukum <oliver@neukum.org>,
        Matthew Garrett <mjg@redhat.com>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        "John W. Linville" <linville@tuxdriver.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>
Subject: Re: loading firmware while usermodehelper disabled.
References: <Pine.LNX.4.44L0.1201021041550.10702-100000@netrider.rowland.org> <4F02165C.1060400@fastmail.fm> <CA+55aFwf06vRraVqtz8_2qWjxH0V=Yj5m7mEy3XVbA7+qj5k5A@mail.gmail.com>
In-Reply-To: <CA+55aFwf06vRraVqtz8_2qWjxH0V=Yj5m7mEy3XVbA7+qj5k5A@mail.gmail.com>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/12 20:48, Linus Torvalds wrote:
> On Mon, Jan 2, 2012 at 12:41 PM, Jack Stone <jwjstone@fastmail.fm> wrote:
>>
>> What about the case where the firmware that needs to be loaded is on the
>> USB device that needs the firmware. This can be resolved at boot using
>> an initrd but at resume time we don't have that.
> 
> Quite frankly, caching the firmware will just automagically fix this.
> 
> I don't understand why people even bother to talk about USB ID's etc
> changing - that is totally irrelevant. We don't look up firmware by
> USB ID's anyway.

I agree. The only problem I can see is with the lifetime of the
firmware. If we have a generic USB driver that looks after (for example)
all USB disks then we do not want to add the knowedge to it for each
individual vendors firmware.

For example:

	1/ Plug in device, registers as a bootstrap device
	2/ Load firmware into device (and put firmware in cache)
	3/ Device disconnects and reconnects with new USB id
	4/ Generic driver takes over as it recognizes the new id

The problem comes with knowing when to put the firmware - how do we tell
the generic driver that that device has firmware that might need to be
freed on disconnect. I don't know enough about USB to know if we can
tell if the same device has reconnected due to firmware being loaded or
if it was simply unplugged and a new device plugged in.

Hope this makes sense,

Jack

