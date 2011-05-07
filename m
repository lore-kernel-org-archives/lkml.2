Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415Ab1EGAia (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 20:38:30 -0400
Received: from kroah.org ([198.145.64.141]:55984 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750892Ab1EGAi3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 20:38:29 -0400
Date: Fri, 6 May 2011 17:38:18 -0700
From: Greg KH <greg@kroah.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: akpm@linux-foundation.org, mingo@redhat.com, tglx@linutronix.de,
        hpa@zytor.com, x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, allen.kao@atheros.com,
        roman.gezikov@atheros.com, joonas.viskari@atheros.com
Subject: Re: [RFC 0/2] x86: Add support for Atheros AR1520 GPS devices
Message-ID: <20110507003818.GA23997@kroah.com>
References: <1304719780-27347-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304719780-27347-1-git-send-email-lrodriguez@atheros.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 06, 2011 at 03:09:38PM -0700, Luis R. Rodriguez wrote:
> These two patches adds support for the Atheros AR1520 GPS device,
> currently only pegged onto an mrst platform. This creates a character
> device called ar1520 and lets userspace talk to it through it. My only
> concern against this approach is that it this requires a custom userspace
> application for reseting the device, waking it up and for blocking reads
> through ioctl. The character device can be used to read/write data to it
> as well.

I really don't like using a character device for this, what's wrong with
a tty device instead like other GPS devices are using today (i.e. a
number of USB GPS devices)?

I don't understand what these ioctls are supposed to be doing, can't
they map to standard tty ioctls that we already have for flow control so
that userspace doesn't have to write a whole new application just to
talk to yet-another-gps-device?

thanks,

greg k-h
