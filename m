Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180Ab2KEIW0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 03:22:26 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:35446 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192Ab2KEIWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 03:22:24 -0500
Date: Mon, 5 Nov 2012 09:22:28 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Colin Cross <ccross@google.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk, "Dae S. Kim" <dae@velatum.com>
Subject: Re: [ 044/218] Staging: Android alarm: IOCTL command encoding fix
Message-ID: <20121105082228.GB3730@kroah.com>
References: <20120928201501.208384923@linuxfoundation.org>
 <20120928201506.526781717@linuxfoundation.org>
 <CAMbhsRRP5ui-10hMEFYk2Rh93XrvKeircsZXsySE7YXF92qigQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMbhsRRP5ui-10hMEFYk2Rh93XrvKeircsZXsySE7YXF92qigQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 03, 2012 at 12:33:07AM -0700, Colin Cross wrote:
> On Fri, Sep 28, 2012 at 1:14 PM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > 3.4-stable review patch.  If anyone has any objections, please let me know.
> >
> > ------------------
> >
> > From: "Dae S. Kim" <dae@velatum.com>
> >
> > commit 6bd4a5d96c08dc2380f8053b1bd4f879f55cd3c9 upstream.
> >
> > Fixed a bug. Data was being written to user space using an IOCTL
> > command encoded with _IOC_WRITE access mode.
> >
> > Signed-off-by: Dae S. Kim <dae@velatum.com>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >
> > ---
> >  drivers/staging/android/android_alarm.h |    4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >
> > --- a/drivers/staging/android/android_alarm.h
> > +++ b/drivers/staging/android/android_alarm.h
> > @@ -110,10 +110,12 @@ enum android_alarm_return_flags {
> >  #define ANDROID_ALARM_WAIT                  _IO('a', 1)
> >
> >  #define ALARM_IOW(c, type, size)            _IOW('a', (c) | ((type) << 4), size)
> > +#define ALARM_IOR(c, type, size)            _IOR('a', (c) | ((type) << 4), size)
> > +
> >  /* Set alarm */
> >  #define ANDROID_ALARM_SET(type)             ALARM_IOW(2, type, struct timespec)
> >  #define ANDROID_ALARM_SET_AND_WAIT(type)    ALARM_IOW(3, type, struct timespec)
> > -#define ANDROID_ALARM_GET_TIME(type)        ALARM_IOW(4, type, struct timespec)
> > +#define ANDROID_ALARM_GET_TIME(type)        ALARM_IOR(4, type, struct timespec)
> >  #define ANDROID_ALARM_SET_RTC               _IOW('a', 5, struct timespec)
> >  #define ANDROID_ALARM_BASE_CMD(cmd)         (cmd & ~(_IOC(0, 0, 0xf0, 0)))
> >  #define ANDROID_ALARM_IOCTL_TO_TYPE(cmd)    (_IOC_NR(cmd) >> 4)
> >
> 
> This patch breaks Android userspace by changing the ioctl ABI to
> /dev/alarm.  It's definitely not a bug fix, as the IOW vs. IOR flag is
> only ever used by drivers, and is not used by alarm-dev.c.

But shouldn't Android userspace work fine if it's rebuilt with the fixed
header file?

And isn't this the correct fix that the kernel needs, to properly check
this ioctl data access works correctly?

> I would have commented sooner, but the original patch was not sent to
> any lists I am on, nor any lists that Google can find.

Odd, I don't have access to my email archive, so I don't remember where
it came from originally, sorry.  Possibly the driverdevel mailing list?

thanks,

greg k-h
