Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756176Ab1AKRFP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 12:05:15 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:65126 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753020Ab1AKRFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 12:05:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=t9aMGXZ/hAf0oRYuMrVSskghspXzld2Z42DtuCvUZ1COMtxBOkcg27/qjIsf+/6zVr
         EScFY6A9YqxdmOLih3jOO3bzXQVjfz6kfmOgFZK1NVxmhy8EupxPEPorOQdpz2UMaV1U
         jgSZ7v7zSUUewseGhpUFVGsS4w1LZMYRHn/+c=
MIME-Version: 1.0
In-Reply-To: <20110111164834.GA28175@srcf.ucam.org>
References: <4D145EB5.7090205@aquazul.com>
	<20110104143651.8f6d62e0.akpm@linux-foundation.org>
	<4D2C8864.8030909@aquazul.com>
	<20110111164834.GA28175@srcf.ucam.org>
Date: Tue, 11 Jan 2011 17:05:11 +0000
Message-ID: <AANLkTinovDucigOX+kidh+KwekbZP65moy7P2pYNn25L@mail.gmail.com>
Subject: Re: mbp_nvidia_bl: Remove DMI dependency (was: Re: [PATCH,RESEND]
 backlight: mbp_nvidia_bl - add support for MacBookPro7,1)
From: Richard Hughes <hughsient@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Mourad De Clerck <mourad@aquazul.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Richard Purdie <rpurdie@linux.intel.com>, linux-kernel@vger.kernel.org,
        Richard Hughes <richard@hughsie.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 January 2011 16:48, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Tue, Jan 11, 2011 at 05:42:12PM +0100, Mourad De Clerck wrote:
>> A bit late, but I tested this patch series and it works for me.
>>
>> The only slight change is that gnome-power-manager needs to be updated
>> to use /sys/class/backlight/apple_backlight instead of mbp_backlight.
>
> gnome-power-manager needs not to have a hardcoded list of backlights.

It's only uses the PolicyKit-enabled utility if there is no XBACKLIGHT
driver support. The list is put there as for a long time people had
multiple backlights, where, for instance thinkpad_screen worked but
not acpi_video1.

If the named backlight file isn't present in the override list, then
we just use the first one in /sys/class/backlight

Mourad, how many devices do you have in /sys/class/backlight?

Richard.
