Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754283Ab0D0Ked (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 06:34:33 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:41846 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853Ab0D0Kec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 06:34:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        b=Z0K4h1PNtZDkA0toLUGwkoef/3CjBbLFCZ+SyNh+jTlAzcS3UReJvsPuepM8f8Vj2+
         Z/px3YdY2x8/DuLB6nxg1I6cHOtX1IEzfw9rCmXKav3k0gPFKZ2ja63L0fgbHPiGHc4P
         qlaQqSE1tX6ztyDFB8pH/V27WJYCwi9wPlCNo=
Date: Tue, 27 Apr 2010 12:30:51 +0200
From: Dan Carpenter <error27@gmail.com>
To: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <dg@emlix.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jani Nikula <ext-jani.1.nikula@nokia.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [patch] gpio: potential null dereference
Message-ID: <20100427103051.GB29093@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Daniel =?iso-8859-1?Q?Gl=F6ckner?= <dg@emlix.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jani Nikula <ext-jani.1.nikula@nokia.com>,
	David Brownell <dbrownell@users.sourceforge.net>,
	Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
References: <20100426192520.GU29093@bicker> <20100426230515.GA1388@emlix.com> <20100427090533.GZ29093@bicker> <4BD6B13C.6020406@emlix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4BD6B13C.6020406@emlix.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 27, 2010 at 11:41:16AM +0200, Daniel Glöckner wrote:
> It returns a valid pointer iff (desc->flags & GPIO_TRIGGER_MASK).
> 
> When !(desc->flags & GPIO_TRIGGER_MASK) it returns NULL and everything
> gets allocated (unless !gpio_flags as well). What you wanted to remove
> is the allocation code, not error handling code. 

No no.  I don't want to remove anything.  I'm happy with the code as is
now that you've explained it to me.  :)

regards,
dan carpenter

> It is always run when
> the trigger is set from "none" to something else.
> 
>   Daniel
>
