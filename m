Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174Ab1KWQl6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 11:41:58 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35639 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755Ab1KWQl5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 11:41:57 -0500
MIME-Version: 1.0
In-Reply-To: <CAHR064iYVHhWgte1vE4xTaS5K4xhVUFHnYkVB1JA_PD8tPFGkQ@mail.gmail.com>
References: <1321999366-23784-1-git-send-email-corentincj@iksaif.net>
	<1321999366-23784-12-git-send-email-corentincj@iksaif.net>
	<20111122222354.GK24283@suse.de>
	<CAHR064iYVHhWgte1vE4xTaS5K4xhVUFHnYkVB1JA_PD8tPFGkQ@mail.gmail.com>
Date: Wed, 23 Nov 2011 17:41:55 +0100
Message-ID: <CANq1E4QHhYqz0R+g9fj-iAd8QZpfAAgZoz_iA5FjHLHSFDJzCg@mail.gmail.com>
Subject: Re: [PATCH 11/15] samsung-laptop: add keyboard backlight support
From: David Herrmann <dh.herrmann@googlemail.com>
To: Corentin Chary <corentin.chary@gmail.com>
Cc: Greg KH <gregkh@suse.de>, platform-driver-x86@vger.kernel.org,
        Matthew Garrett <mjg@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 23, 2011 at 7:35 AM, Corentin Chary
<corentin.chary@gmail.com> wrote:
> On Tue, Nov 22, 2011 at 11:23 PM, Greg KH <gregkh@suse.de> wrote:
>> On Tue, Nov 22, 2011 at 11:02:42PM +0100, Corentin Chary wrote:
>>> Signed-off-by: Corentin Chary <corentincj@iksaif.net>
>>
>> What happens on boxes that don't have this type of hardware?  Will the
>> LED device still show up, yet it will not work?
>>
>> You should be able to trigger this off of the model type somehow, much
>> like the video backlight should work.
>
> kbd_backlight_enable(samsung) will be called, it will fire a {0x78,
> 0xaabb} command on machines using swsmi and this command will fail if
> the feature is not available. I did some test, and unknown commands
> seems to fail gracefully, and that makes sabi_command() (and callers)
> return -EINVAL).
>
> It think {0x78, 0x80} is also here to tell if the backlight is
> available or not, but I can't test it, since it always returns 1 here.

I do not have a keyboard backlight and hence always get an error
message on boot up. It would be great to suppress this error message
as this is not really an error (for me):
samsung_laptop: SABI command 0x0078 failed with completion flag 0xaa

> So yeah, if someone could test that on a swsmi laptop without keyboard
> backlight, that would be great.
> --
> Corentin Chary
> http://xf.iksaif.net
> --
> To unsubscribe from this list: send the line "unsubscribe platform-driver-x86" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
