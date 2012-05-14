Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756951Ab2ENPju (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 11:39:50 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:51278 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756790Ab2ENPjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 11:39:48 -0400
Date: Mon, 14 May 2012 08:39:29 -0700
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: "Du, ChangbinX" <changbinx.du@intel.com>
Cc: Sergei Shtylyov <sshtylyov@mvista.com>,
        "mina86@mina86.com" <mina86@mina86.com>,
        "Fleming, Matt" <matt.fleming@intel.com>,
        "balbi@ti.com" <balbi@ti.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] testusb: add path /dev/bus/usb to default search paths
 for usbfs
Message-ID: <20120514153929.GA1725@kroah.com>
References: <1337021163-1487-1-git-send-email-changbinx.du@intel.com>
 <0C18FE92A7765D4EB9EE5D38D86A563A062C91@SHSMSX101.ccr.corp.intel.com>
 <4FB0D76B.2060603@mvista.com>
 <0C18FE92A7765D4EB9EE5D38D86A563A062DC8@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0C18FE92A7765D4EB9EE5D38D86A563A062DC8@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 14, 2012 at 10:49:06AM +0000, Du, ChangbinX wrote:
> 
> Hello.
> 
> On 14-05-2012 10:51, Du, ChangbinX wrote:
> 
> > As real device-nodes managed by udev whose nodes lived in /dev/bus/usb 
> > are mostly used today, let testusb tool use that directory as one 
> > default path make tool be more convenient to use.
> 
> > Signed-off-by: Du Changbin<changbinx.du@intel.com>
> > ---
> >   tools/usb/testusb.c |    6 ++++++
> >   1 file changed, 6 insertions(+)
> 
> > diff --git a/tools/usb/testusb.c b/tools/usb/testusb.c index 
> > 6e0f567..c6c839e 100644
> > --- a/tools/usb/testusb.c
> > +++ b/tools/usb/testusb.c
> [...]
> > @@ -376,6 +377,11 @@ static const char *usbfs_dir_find(void)
> >   		}
> >   	} while (++it != end);
> >
> > +	/* real device-nodes managed by udev */
> > +	if (access(udev_usb_path, F_OK) == 0) {
> > +		return udev_usb_path;
> > +	}
> 
>     Why {} with single statement?
> 
> Hi, thanks for your tip. It's a code style issue. I will remove {}.
> 
> By the way, I don't know how I can do with this case? Resend a new
> patch? Do I need include discussion message in new patch mail?

Please resend a new patch with this fixed up.

> And how can I know my patch has be accepted? I am a newbie, could you
> help me?

You will get an automated email from my patch system when it is applied.

thanks,

greg k-h
