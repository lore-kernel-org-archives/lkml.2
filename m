Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932411Ab1BYJdl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 04:33:41 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59025 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932167Ab1BYJdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 04:33:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=oOqGmljc9t+BuoIIW9sdNsYxOZOIQGMlstn4K1mJNqWaS59afIQKsVo5p1KMW4w2NO
         6p1sN3GP+9xZpaXgwN6u9HIKgx9mxEznsFVKQjB1jrk38BAb9ga3Sk8Qh/d7Y1JDPRFn
         NCHDbZNamV3AWxr3GFkJumfXYsH1Ubw6UH1iU=
Date: Fri, 25 Feb 2011 01:33:32 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: =?iso-8859-1?Q?Keng-Y=FC?= Lin <keng-yu.lin@canonical.com>
Cc: Martin Pitt <martin.pitt@canonical.com>,
        Corentin Chary <corentin.chary@gmail.com>,
        Matthew Garrett <mjg@redhat.com>, acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        tyson.chen@canonical.com
Subject: Re: [PATCH] eeepc-wmi: set the touchpad toggle key code to F21
Message-ID: <20110225093332.GC14053@core.coreip.homeip.net>
References: <1298611140-21573-1-git-send-email-keng-yu.lin@canonical.com>
 <AANLkTim_JKQU9J3OJ0FRQ_ZVPktAPbnzr2t8SvhL2Uzj@mail.gmail.com>
 <20110225071827.GA14053@core.coreip.homeip.net>
 <AANLkTim6pxadoTSsNqYV_gmRGOwyFRvfErSvcwRtaavy@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTim6pxadoTSsNqYV_gmRGOwyFRvfErSvcwRtaavy@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 25, 2011 at 05:22:43PM +0800, Keng-Yü Lin wrote:
> On Fri, Feb 25, 2011 at 3:18 PM, Dmitry Torokhov
> <dmitry.torokhov@gmail.com> wrote:
> > I believe that the kernel should use KEY_TOUCHPAD_TOGGLE and userspace
> > should use udev's key re-mapping facilities while X is unable to process
> > keycodes above 255 to adjust to the keycode du jour. If all kernel
> > drivers were to use KEY_TOUCHPAD_TOGGLE then remapping would be much
> > easier (the utility would simply check capabilities for
> > KEY_TOUCHPAD_TOGGLE and do the remap).
> 
> Can udev re-map a key code to another?

Not directly.

> 
> Am I correct that udev can only re-map a scan code to a specified key code.

Right, so once you determined via capabilities that device emits
KEY_TOUCHPAD_TOGGLE you query the keymap (using EVIOCGKEYCODE2; by
index) and replace all entries that are mapped to KEY_TOUCHPAD_TOGGLE to
whatever you want.

Thanks.

-- 
Dmitry
