Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754448Ab1HKXkp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 19:40:45 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39801 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754417Ab1HKXkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 19:40:40 -0400
Message-ID: <4E446873.9020508@gmail.com>
Date: Fri, 12 Aug 2011 01:40:35 +0200
From: Daniel Mack <zonque@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: =?UTF-8?B?TWF0xJtqIExhaXRs?= <matej@laitl.cz>
CC: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Florian Mickler <florian@mickler.org>,
        Oliver Neukum <oliver@neukum.org>, linux-usb@vger.kernel.org,
        alsa-devel@alsa-project.org, Takashi Iwai <tiwai@suse.de>,
        Clemens Ladisch <clemens@ladisch.de>, pedrib@gmail.com,
        William Light <wrl@illest.net>, Greg KH <greg@kroah.com>,
        linux-kernel@vger.kernel.org, Robert Hancock <hancockrwd@gmail.com>
Subject: Re: Allocating buffers for USB transfers (again)
References: <Pine.LNX.4.44L0.1108101025250.1917-100000@iolanthe.rowland.org> <20110811180507.GC5884@xanatos> <CACTFLAMcOMv4D8k-P24TAkPwLRgYps4hoO-vC1NH+cibcsrUFQ@mail.gmail.com> <3166003.Y8gKYdUrh9@edgy>
In-Reply-To: <3166003.Y8gKYdUrh9@edgy>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/2011 01:29 AM, Matěj Laitl wrote:
> On 11. 8. 2011 Daniel Mack wrote:
>> On Thu, Aug 11, 2011 at 8:05 PM, Sarah Sharp
>>> Because according to Matej, he applied that patch, plus my patch to
>>> reject zero-length buffers[1], and he saw debugging that indicated he
>>> *did* see zero-length buffers.  Is there any chance your driver might
>>> submit a zero-length buffer in the middle of the isochronous URB
>>> transfer array?
>>
>> Hmm, judging from the code, this can only ever happen if we receive an
>> inbound iso frame which has a valid status and an actual_length of
>> zero. Also, it was not neccessary to catch this case for EHCI.
>>
>> Maetj, does this patch make any difference?
>
> This patch actually makes the sound playback _worse_. Now I get strange
> squawks where previously at least first seconds of a song sounded normally.
>
> However, I no longer get "zero length buffer submitted" or that "... Weird."
> debug messages, only several megabytes of: (should I post these somewhere?)
>
> xhci_hcd 0000:05:00.0: Giveback URB ffff880114cec000, len = 880, expected =
> 1000, status = -115
> xhci_hcd 0000:05:00.0: Giveback URB ffff880114740000, len = 352, expected =
> 1000, status = -115
> xhci_hcd 0000:05:00.0: underrun event on endpoint

Might be the hardware doesn't like this. As I said, the patch is blindly 
written and I couldn't test it. Did you test this on a EHCI port as well?

Daniel

