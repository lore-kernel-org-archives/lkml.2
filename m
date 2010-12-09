Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962Ab0LITQ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 14:16:59 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:65060 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752695Ab0LITQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 14:16:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Fi0ouNbeS8pof5IZmAcOJgNeJLYnTFrxLhRbh6dzoFqJ7qdVgsbUHIsupmua/B/Wcu
         ilTQh75wiqraDrY998HJXWvLHTUJxpgISzaawzoNfL1kuvgoPIsp/JmZo7SiTlloZ0Jh
         K0Z0nw7er0v70fCF0500bjeIBDbPRXEasaBb4=
Date: Thu, 9 Dec 2010 11:16:47 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Linux Input <linux-input@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Jarod Wilson <jarod@redhat.com>,
        David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
Subject: Re: [RFC] Input: define separate EVIOCGKEYCODE_V2/EVIOCSKEYCODE_V2
Message-ID: <20101209191647.GC23781@core.coreip.homeip.net>
References: <20101209093948.GD8821@core.coreip.homeip.net>
 <4D012844.3020009@euromail.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D012844.3020009@euromail.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 09, 2010 at 08:04:36PM +0100, Henrik Rydberg wrote:
> On 12/09/2010 10:39 AM, Dmitry Torokhov wrote:
> 
> > The desire to keep old names for the EVIOCGKEYCODE/EVIOCSKEYCODE while
> > extending them to support large scancodes was a mistake. While we tried
> > to keep ABI intact (and we succeeded in doing that, programs compiled
> > on older kernels will work on newer ones) there is still a problem with
> > recompiling existing software with newer kernel headers.
> > 
> > New kernel headers will supply updated ioctl numbers and kernel will
> > expect that userspace will use struct input_keymap_entry to set and
> > retrieve keymap data. But since the names of ioctls are still the same
> > userspace will happily compile even if not adjusted to make use of the
> > new structure and will start miraculously fail in the field.
> > 
> > To avoid this issue let's revert EVIOCGKEYCODE/EVIOCSKEYCODE definitions
> > and add EVIOCGKEYCODE_V2/EVIOCSKEYCODE_V2 so that userspace can explicitly
> > select the style of ioctls it wants to employ.
> > 
> > Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
> > ---
> 
> 
> Would the header change suffice in itself?

We still need to change evdev to return -EINVAL on wrong sizes but yes,
the amount of change there could be more limited. I just thought that
splitting it up explicitly shows the differences in handling better. If
people prefer the previos version we could leave it, I am 50/50 between
them.

> Either way, also checked that the
> bugfixes following the original patch is still in effect, so looks ok to me.

Thanks.

-- 
Dmitry
