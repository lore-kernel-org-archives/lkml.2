Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965089Ab2JCSja (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 14:39:30 -0400
Received: from mx.scalarmail.ca ([98.158.95.75]:36456 "EHLO
	ironport-01.sms.scalar.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754940Ab2JCSj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 14:39:27 -0400
Date: Wed, 3 Oct 2012 14:39:21 -0400
From: Nick Bowler <nbowler@elliptictech.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
        YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: Re: [PATCH 1/7] string: introduce helper to get base file name from
 given path
Message-ID: <20121003183921.GA3098@elliptictech.com>
References: <1349190062-13107-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <20121002173440.GA26975@kroah.com>
 <CAHp75VfkLWPo2nNb44vLGBsy808Ztsh=nxMhTzRgCgCMzJizsA@mail.gmail.com>
 <20121002181250.GA14042@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121002181250.GA14042@kroah.com>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-10-02 11:12 -0700, Greg KH wrote:
> On Tue, Oct 02, 2012 at 08:52:05PM +0300, Andy Shevchenko wrote:
> > On Tue, Oct 2, 2012 at 8:34 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> > > On Tue, Oct 02, 2012 at 06:00:54PM +0300, Andy Shevchenko wrote:
[...]
> > >> +/**
> > >> + * kbasename - return the last part of a pathname.
> > >> + *
> > >> + * @path: path to extract the filename from.
> > >> + */
> > >> +static inline const char *kbasename(const char *path)
> > >> +{
> > >> +     const char *tail = strrchr(path, '/');
> > >> +     return tail ? tail + 1 : path;
> > >
> > > What happens if '/' is the last thing in the string?  You will then
> > > point to an empty string, which I don't think all callers of this
> > > function is assuming going to work properly (hint, the USB caller will
> > > not...)
> > Thanks for pointing to that. I think it's a usb specific case, so, I
> > assume your comment related to that patch.
> 
> Well, if you want your kbasename() function to work like the basename(3)
> function, you need to properly handle a trailing '/' character.

Specifically, POSIX basename trims trailing '/' characters, so

  char foo[] = "a/string/with/trailing/slashes///";
  basename(foo);

results in a string that compares equal to "slashes".  This implies that
it must either modify the provided string or copy it somewhere else
(POSIX admits either behaviour).

On the other hand, GNU basename does not trim trailing '/' characters
and returns the empty string in this case.  It's truly unfortunate that
glibc contains two different functions called basename, but regardless,
the behaviour of the function in this proposal is certainly not
unprecedented.

Cheers,
-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)

