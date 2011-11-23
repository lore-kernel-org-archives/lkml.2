Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758657Ab1KWGfE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 01:35:04 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37717 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758539Ab1KWGfC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 01:35:02 -0500
MIME-Version: 1.0
In-Reply-To: <20111122222354.GK24283@suse.de>
References: <1321999366-23784-1-git-send-email-corentincj@iksaif.net>
	<1321999366-23784-12-git-send-email-corentincj@iksaif.net>
	<20111122222354.GK24283@suse.de>
Date: Wed, 23 Nov 2011 07:35:00 +0100
Message-ID: <CAHR064iYVHhWgte1vE4xTaS5K4xhVUFHnYkVB1JA_PD8tPFGkQ@mail.gmail.com>
Subject: Re: [PATCH 11/15] samsung-laptop: add keyboard backlight support
From: Corentin Chary <corentin.chary@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: platform-driver-x86@vger.kernel.org, Matthew Garrett <mjg@redhat.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 22, 2011 at 11:23 PM, Greg KH <gregkh@suse.de> wrote:
> On Tue, Nov 22, 2011 at 11:02:42PM +0100, Corentin Chary wrote:
>> Signed-off-by: Corentin Chary <corentincj@iksaif.net>
>
> What happens on boxes that don't have this type of hardware?  Will the
> LED device still show up, yet it will not work?
>
> You should be able to trigger this off of the model type somehow, much
> like the video backlight should work.

kbd_backlight_enable(samsung) will be called, it will fire a {0x78,
0xaabb} command on machines using swsmi and this command will fail if
the feature is not available. I did some test, and unknown commands
seems to fail gracefully, and that makes sabi_command() (and callers)
return -EINVAL).

It think {0x78, 0x80} is also here to tell if the backlight is
available or not, but I can't test it, since it always returns 1 here.

So yeah, if someone could test that on a swsmi laptop without keyboard
backlight, that would be great.
-- 
Corentin Chary
http://xf.iksaif.net
