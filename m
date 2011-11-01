Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505Ab1KASJb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 14:09:31 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53690 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753698Ab1KASJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 14:09:29 -0400
MIME-Version: 1.0
In-Reply-To: <20111101180038.GB4241@suse.de>
References: <1320162100-13494-1-git-send-email-dh.herrmann@googlemail.com>
	<20111101170156.GA8925@suse.de>
	<CANq1E4S07S2kNTmAxQRa4mEVKrGnS7cTHKqPoHEzLOyu3Mfqzw@mail.gmail.com>
	<20111101180038.GB4241@suse.de>
Date: Tue, 1 Nov 2011 19:09:27 +0100
Message-ID: <CANq1E4T6urGVLC7xEa_4D=sCGYD0zsiVbH9u_E6O_xwuhR2Z4g@mail.gmail.com>
Subject: Re: [RFC] Input: Remove unsafe device module references
From: David Herrmann <dh.herrmann@googlemail.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-input@vger.kernel.org, dmitry.torokhov@gmail.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 1, 2011 at 7:00 PM, Greg KH <gregkh@suse.de> wrote:
> On Tue, Nov 01, 2011 at 06:52:11PM +0100, David Herrmann wrote:
>> My solution: Some parent subsystem of us must take and release this
>> module-refcnt instead of us, so this bug doesn't occur.
>
> Yes, that is the ultimate solution for something like this.
>
> But, in reality, we don't care about module unloading races as there are
> plenty of other issues involved there where things can go bad, so we
> just try the best we can :)

Ah, I am kind of relieved that I got this right. I almost started
thinking I am insane.. ;)

So your answer is that this is so unlikely that it won't be fixed? I
am fine with that, even though I wonder why stuff like "struct
file_operations" include "owner" fields to protect callbacks but
"struct device_type" does *not* include any protection of it's
"release" callback.
This is why I thought calling module_get/put() inside the driver-core
would be just consistent with other subsystems.

But if this race is fine, I will simply copy it.

> thanks,
>
> greg k-h

Sorry for the confusion and thanks for your answers.
Regards
David
