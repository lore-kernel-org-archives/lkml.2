Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752248Ab1HLB2o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 21:28:44 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:35639 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167Ab1HLB2n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 21:28:43 -0400
MIME-Version: 1.0
In-Reply-To: <1451239.ZLFiT5MIDr@edgy>
References: <Pine.LNX.4.44L0.1108101025250.1917-100000@iolanthe.rowland.org>
	<3166003.Y8gKYdUrh9@edgy>
	<4E446873.9020508@gmail.com>
	<1451239.ZLFiT5MIDr@edgy>
Date: Fri, 12 Aug 2011 03:28:42 +0200
Message-ID: <CACTFLANyL95Gy6c2YznV-h0tYdZ7nvRhObsq8dvp9n4_9=D_Mw@mail.gmail.com>
Subject: Re: Allocating buffers for USB transfers (again)
From: Daniel Mack <zonque@gmail.com>
To: =?UTF-8?B?TWF0xJtqIExhaXRs?= <matej@laitl.cz>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Florian Mickler <florian@mickler.org>,
        Oliver Neukum <oliver@neukum.org>, linux-usb@vger.kernel.org,
        alsa-devel@alsa-project.org, Takashi Iwai <tiwai@suse.de>,
        Clemens Ladisch <clemens@ladisch.de>, pedrib@gmail.com,
        William Light <wrl@illest.net>, Greg KH <greg@kroah.com>,
        linux-kernel@vger.kernel.org, Robert Hancock <hancockrwd@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 12, 2011 at 1:50 AM, Matěj Laitl <matej@laitl.cz> wrote:
> On 12. 8. 2011 Daniel Mack wrote:
>> > This patch actually makes the sound playback _worse_. Now I get strange
>> > squawks where previously at least first seconds of a song sounded
>> > normally.
>> >
>> > However, I no longer get "zero length buffer submitted" or that "...
>> > Weird." debug messages, only several megabytes of: (should I post these
>> > somewhere?)
>> >
>> > xhci_hcd 0000:05:00.0: Giveback URB ffff880114cec000, len = 880,
>> > expected = 1000, status = -115
>> > xhci_hcd 0000:05:00.0: Giveback URB ffff880114740000, len = 352,
>> > expected = 1000, status = -115
>> > xhci_hcd 0000:05:00.0: underrun event on endpoint
>>
>> Might be the hardware doesn't like this. As I said, the patch is blindly
>> written and I couldn't test it. Did you test this on a EHCI port as well?
>
> Good point, this patch distorts the playback also on the EHCI port. (the
> playback seems to be 10 times slower than it should be)

And it is only this *last* patch that causes it, yes?

If that is the case, we need empty subframes in the middle of urbs,
and we need to figure a way how to teach the XHCI driver to cope with
that, too.


Daniel
