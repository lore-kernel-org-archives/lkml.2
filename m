Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751528Ab2KTE3X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 23:29:23 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:23289 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770Ab2KTE3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 23:29:22 -0500
Date: Tue, 20 Nov 2012 07:28:56 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Russ Anderson <rja@sgi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Jack Steiner <steiner@sgi.com>,
        Dimitri Sivanich <sivanich@sgi.com>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        rja@americas.sgi.com
Subject: Re: [patch] x86, UV: integer wrap bug in uv_hub_ipi_value()
Message-ID: <20121120042855.GE6186@mwanda>
References: <20121117151611.GB16900@elgon.mountain>
 <20121120004834.GE5060@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121120004834.GE5060@sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 19, 2012 at 06:48:34PM -0600, Russ Anderson wrote:
> On Sat, Nov 17, 2012 at 06:16:11PM +0300, Dan Carpenter wrote:
> > This is a static checker fix.  The problem is that we store the bits
> > from "uv_apicid_hibits" into "apicid" (the high 16 bits) but then we
> > shift it 16 bit to the left.  "apicid" is an int so it wraps and we lose
> > them.
> 
> Is this the complete patch?  phys_apicid is an int, but gets
> cast as unsigned long.  Doesn't phys_apicid also have to be
> changed to unsigned long?  And why ulong instead of uint (on x86_64)?

Uint is 32bit across all arches in linux and unix, according to
wikipedia.  The wakeup_secondary_cpu() function pointer takes an int
so I couldn't change the parameter.

> 
> I agree with changing signed to unsigned where appropriate, but
> this looks like a partial fix.  Am I missing something?
> 

I do feel a little embarrassed that I didn't use "unsigned long"
consistently.  I just used ulong to make the line a bit shorter, but
I could redo it with "unsigned long" if you want.

regards,
dan carpenter


