Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934907Ab2JXOPK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 10:15:10 -0400
Received: from mail.csclub.uwaterloo.ca ([129.97.134.52]:41858 "EHLO
	mail.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934793Ab2JXOPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 10:15:09 -0400
From: "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>
Date: Wed, 24 Oct 2012 10:15:06 -0400
To: =?utf-8?B?QmrDuHJu?= Mork <bjorn@mork.no>
Cc: linux-kernel@vger.kernel.org, linux@sierrawireless.com
Subject: Re: Fix memory leak in sierra_release()
Message-ID: <20121024141506.GP18610@csclub.uwaterloo.ca>
References: <20121023200333.GN18610@csclub.uwaterloo.ca>
 <87r4oof83e.fsf@nemi.mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87r4oof83e.fsf@nemi.mork.no>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2012 at 01:00:21PM +0200, Bjørn Mork wrote:
> "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca> writes:
> 
> > I found a memory leak in sierra_release() (well sierra_probe() I guess)
> > that looses 8 bytes each time the driver releases a device.
> >
> > Here is the patch to fix it.
> >
> > diff --git a/drivers/usb/serial/sierra.c b/drivers/usb/serial/sierra.c
> > index 01d882c..76ef95b 100644
> > --- a/drivers/usb/serial/sierra.c
> > +++ b/drivers/usb/serial/sierra.c
> > @@ -959,6 +959,7 @@ static void sierra_release(struct usb_serial *serial)
> >  			continue;
> >  		kfree(portdata);
> >  	}
> > +	kfree(serial->private);
> >  }
> >  
> >  #ifdef CONFIG_PM
> 
> Looks sensible to me, but needs a signed-off-by and CC to linux-usb.

Oh yeah.  I shouldn't send patches at the end of the day.

I will try again.

-- 
Len Sorensen
