Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965512Ab2JDIUF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 04:20:05 -0400
Received: from mga01.intel.com ([192.55.52.88]:44357 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932554Ab2JDIUC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 04:20:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,533,1344236400"; 
   d="scan'208";a="230385408"
Message-ID: <1349338789.13371.193.camel@smile>
Subject: Re: [PATCH 1/7] string: introduce helper to get base file name from
 given path
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Nick Bowler <nbowler@elliptictech.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
        YAMANE Toshiaki <yamanetoshi@gmail.com>
Date: Thu, 04 Oct 2012 11:19:49 +0300
In-Reply-To: <20121003183921.GA3098@elliptictech.com>
References: <1349190062-13107-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <20121002173440.GA26975@kroah.com>
	 <CAHp75VfkLWPo2nNb44vLGBsy808Ztsh=nxMhTzRgCgCMzJizsA@mail.gmail.com>
	 <20121002181250.GA14042@kroah.com> <20121003183921.GA3098@elliptictech.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-10-03 at 14:39 -0400, Nick Bowler wrote: 
> On 2012-10-02 11:12 -0700, Greg KH wrote:
> > On Tue, Oct 02, 2012 at 08:52:05PM +0300, Andy Shevchenko wrote:
> > > On Tue, Oct 2, 2012 at 8:34 PM, Greg KH <gregkh@linuxfoundation.org> wrote:

[...]

> > Well, if you want your kbasename() function to work like the basename(3)
> > function, you need to properly handle a trailing '/' character.
> 
> Specifically, POSIX basename trims trailing '/' characters, so
> 
>   char foo[] = "a/string/with/trailing/slashes///";
>   basename(foo);
> 
> results in a string that compares equal to "slashes".  This implies that
> it must either modify the provided string or copy it somewhere else
> (POSIX admits either behaviour).
> 
> On the other hand, GNU basename does not trim trailing '/' characters
> and returns the empty string in this case.  It's truly unfortunate that
> glibc contains two different functions called basename, but regardless,
> the behaviour of the function in this proposal is certainly not
> unprecedented.
I fixed the description of the patch in v2.

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
