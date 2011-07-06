Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752034Ab1GFD5z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 23:57:55 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:55028 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083Ab1GFD5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 23:57:54 -0400
MIME-Version: 1.0
X-Originating-IP: [202.78.240.10]
In-Reply-To: <20110706033630.GA29391@kroah.com>
References: <1309657621-21711-1-git-send-email-chrisf@ijw.co.nz>
	<20110706033630.GA29391@kroah.com>
Date: Wed, 6 Jul 2011 15:57:53 +1200
Message-ID: <CAH3ygc2bEphf50oTxDjRNVNfLw96x5w5L88w2DVfAHOKgkEHRQ@mail.gmail.com>
Subject: Re: [PATCH] drivers: staging: iio: adc: fix uninitialized use
From: Chris Forbes <chrisf@ijw.co.nz>
To: Greg KH <greg@kroah.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks one of Dan Carpenter's patches in the staging-next tree -- f88af7e --
already fixes this; disregard my patch.

-- Chris

On Wed, Jul 6, 2011 at 3:36 PM, Greg KH <greg@kroah.com> wrote:
> On Sun, Jul 03, 2011 at 01:47:01PM +1200, Chris Forbes wrote:
>> Fixed an uninitialized variable access. In the first two error paths in
>> max1363_probe(), 'st' is not yet initialized, but its 'reg' member is
>> accessed anyway. This would most likely crash.
>>
>> The intended value for st->reg *is* available at that point in 'reg',
>> so just use that directly.
>
> This doesn't apply anymore, care to redo it against the latest
> staging-next branch and resend?
>
> thanks,
>
> greg k-h
>
