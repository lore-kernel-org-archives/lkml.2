Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752116Ab2GUUrF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2012 16:47:05 -0400
Received: from mail.lang.hm ([64.81.33.126]:59642 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751831Ab2GUUrD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2012 16:47:03 -0400
Date: Sat, 21 Jul 2012 13:46:30 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Ming Lei <tom.leiming@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-usb <linux-usb@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Oliver Neukum <oneukum@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [RFC] firmware load: defer request_firmware during early boot
 and resume
In-Reply-To: <CA+55aFwte5bc-4FC758pBN3FbrtKQfwm_Mv_banekhL=kSF8kg@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1207211344390.20176@asgard.lang.hm>
References: <CACVXFVNWOcrR9tYhU1wVUSJ_DJ8x+SCk993Sn9dYDe2kzJBDuQ@mail.gmail.com> <CA+55aFwZRvtpE2e3zNqvtobpPROqw_bOwNt+=DBzmScV0_rq=w@mail.gmail.com> <CACVXFVPupumYqeBwTwgK3C04VQBxOjkFMbaKQ-Gsz3teCWqQ=w@mail.gmail.com>
 <CA+55aFwte5bc-4FC758pBN3FbrtKQfwm_Mv_banekhL=kSF8kg@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Jul 2012, Linus Torvalds wrote:

>> In my opinion,  we should cache firmware data for all hotplug
>> devices or devices which may experience power loss automatically
>> in kernel during suspend-resume cycle because all such devices may be
>> disconnected and connected again during suspend-resume cycle.
>
> Yes. *THAT* is absolutely the kind of change I'd love to see. The core
> device layer doesn't really make it easy to handle firmware sanely
> over suspend/resume, which is kind of sad. Why does every driver have
> to have its own "let me remember my firmware over the suspend/resume
> event" and have extra code in suspend/resume, when it's really a
> pretty generic situation: if the device has firmware, wouldn't it be
> really nice if the core driver layer just knew about that and kept
> track of it?

firmware can be added to the kernel image at compile time. would it make 
sense for there to be some mechanism that can add firmware to the kernel 
image after the fact so that it can create a 'cache' of the firmware 
needed for the particular system as part of that systems kernel image?

David Lang
