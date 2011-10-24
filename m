Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932125Ab1JXUcR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 16:32:17 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:47301 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755520Ab1JXUcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 16:32:16 -0400
Date: Mon, 24 Oct 2011 13:32:04 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Christoph Fritz <chf.fritz@googlemail.com>
Cc: Denilson Figueiredo de =?iso-8859-1?Q?S=E1?= 
	<denilsonsa@gmail.com>,
        linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        linux-input@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: Linux USB HID should ignore values outside Logical
 Minimum/Maximum range
Message-ID: <20111024203204.GA31721@core.coreip.homeip.net>
References: <op.v3q34la3dsdv5o@localhost>
 <1319476183.3210.12.camel@lovely>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1319476183.3210.12.camel@lovely>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,

On Mon, Oct 24, 2011 at 07:09:43PM +0200, Christoph Fritz wrote:
> Hi Denilson,
> 
>  please see my comment below.
> 
> On Sat, 2011-10-22 at 09:42 -0200, Denilson Figueiredo de Sá wrote:
> > Short description:
> > 
> > An absolute pointing device using USB HID defines a LOGICAL_MINIMUM and
> > a LOGICAL_MAXIMUM for X, Y axes, and then sends a HID report containing
> > values outside that range.
> > 
> > Linux kernel should ignore values outside that range, as they are not
> > meaningful.
> 
> To answer with a quote from the comment above input.h:"struct
> input_absinfo":
> 
>  *
>  * Note that input core does not clamp reported values to the
>  * [minimum, maximum] limits, such task is left to userspace.
>  *
> 
> to do so, use this from input.h:
> 
> #define EVIOCGABS(abs)		_IOR('E', 0x40 + (abs), struct input_absinfo)	/* get abs value/limits */
> #define EVIOCSABS(abs)		_IOW('E', 0xc0 + (abs), struct input_absinfo)	/* set abs value/limits */

While input core does not clam or validate the values reported by the
driver it might make sense to do so in hid-input; I am not sure how
often these limits programmed intorrectly. Jiri i sprobably the best
person to answer this question.

Thanks.

-- 
Dmitry
