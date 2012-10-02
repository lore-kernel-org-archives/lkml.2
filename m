Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378Ab2JBSMx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 14:12:53 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:35631 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753423Ab2JBSMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 14:12:52 -0400
X-Sasl-enc: CnS1KVzzSYeanTTFJK6PlXXv3FGNrrelcsazXYUM9VAk 1349201571
Date: Tue, 2 Oct 2012 11:12:50 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
        YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: Re: [PATCH 1/7] string: introduce helper to get base file name from
 given path
Message-ID: <20121002181250.GA14042@kroah.com>
References: <1349190062-13107-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <20121002173440.GA26975@kroah.com>
 <CAHp75VfkLWPo2nNb44vLGBsy808Ztsh=nxMhTzRgCgCMzJizsA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75VfkLWPo2nNb44vLGBsy808Ztsh=nxMhTzRgCgCMzJizsA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 02, 2012 at 08:52:05PM +0300, Andy Shevchenko wrote:
> On Tue, Oct 2, 2012 at 8:34 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> > On Tue, Oct 02, 2012 at 06:00:54PM +0300, Andy Shevchenko wrote:
> >> There are several places in kernel that use functionality like shell's basename
> >> function. Let's do it common helper for them.
> >>
> >> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> >> Cc: YAMANE Toshiaki <yamanetoshi@gmail.com>
> >> ---
> >>  include/linux/string.h |   11 +++++++++++
> >>  1 file changed, 11 insertions(+)
> >>
> >> diff --git a/include/linux/string.h b/include/linux/string.h
> >> index b917881..b09a342 100644
> >> --- a/include/linux/string.h
> >> +++ b/include/linux/string.h
> >> @@ -147,5 +147,16 @@ static inline bool strstarts(const char *str, const char *prefix)
> >>
> >>  extern size_t memweight(const void *ptr, size_t bytes);
> >>
> >> +/**
> >> + * kbasename - return the last part of a pathname.
> >> + *
> >> + * @path: path to extract the filename from.
> >> + */
> >> +static inline const char *kbasename(const char *path)
> >> +{
> >> +     const char *tail = strrchr(path, '/');
> >> +     return tail ? tail + 1 : path;
> >
> > What happens if '/' is the last thing in the string?  You will then
> > point to an empty string, which I don't think all callers of this
> > function is assuming going to work properly (hint, the USB caller will
> > not...)
> Thanks for pointing to that. I think it's a usb specific case, so, I
> assume your comment related to that patch.

Well, if you want your kbasename() function to work like the basename(3)
function, you need to properly handle a trailing '/' character.

And yes, the USB code does check for this.  I don't remember why, odds
are it was needed for something.

greg k-h
