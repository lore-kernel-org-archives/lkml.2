Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757053Ab0LMVRO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 16:17:14 -0500
Received: from kroah.org ([198.145.64.141]:41569 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756623Ab0LMVRN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 16:17:13 -0500
Date: Mon, 13 Dec 2010 13:15:31 -0800
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH v2] Staging: rt2860: include KERN_* in printk
Message-ID: <20101213211531.GA19783@kroah.com>
References: <1292176591-26081-4-git-send-email-agimenez@sysvalve.es>
 <1292198324-12072-1-git-send-email-agimenez@sysvalve.es>
 <20101213183032.GA6147@kroah.com>
 <20101213202429.GA6811@bart.evergreen.loc>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20101213202429.GA6811@bart.evergreen.loc>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 13, 2010 at 09:24:30PM +0100, L. Alberto Giménez wrote:
> On Mon, Dec 13, 2010 at 10:30:32AM -0800, Greg KH wrote:
> > On Mon, Dec 13, 2010 at 12:58:44AM +0100, L. Alberto Giménez wrote:
> > > Fix checkpatch complains.
> > > 
> > > The change of the DBGPRINT_ERR macro causes the change on the callers.
> > 
> > What change?
> 
> -#define DBGPRINT_ERR(Fmt)           \
> -{                                   \
> -    printk("ERROR! ");          \
> -    printk Fmt;                  \
> -}
> +#define DBGPRINT_ERR(fmt, args...) printk(KERN_ERR fmt, ##args)
> 
> Recommended by Joe. I agree that it is cleaner and more compliant.

Not really, it should be replaced with dev_err() or some such universal
replacement.


> That macro needed that the callers use two parens, as in:
> 
> DBGPRINT_ERR(("MlmeInit failed, Status[=0x%08x]\n", Status));
> 
> With the introduced change, all calls to the DBGPRINT_ERR macro must be
> translated to a regular single-parenthesized.
> 
> DBGPRINT_ERR("NICInitializeAdapter failed, Status[=0x%08x]\n", Status);
> 
> Yes, it's crap code, but I own an eeepc 901 and this was the perfect excuse to
> get my harnds dirty :)

That's fine.

How about splitting just the DBGPRINT_ERR() change into one patch, and
the other printk cleanups into another one?  Remember, only do one thing
per patch please.

thanks,

greg k-h
