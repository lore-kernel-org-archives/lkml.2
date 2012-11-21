Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752701Ab2KUHk2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 02:40:28 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:38990 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115Ab2KUHk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 02:40:27 -0500
Date: Wed, 21 Nov 2012 10:39:56 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Russ Anderson <rja@sgi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Dimitri Sivanich <sivanich@sgi.com>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch] x86, UV: integer wrap bug in uv_hub_ipi_value()
Message-ID: <20121121073956.GF6186@mwanda>
References: <20121117151611.GB16900@elgon.mountain>
 <20121120004834.GE5060@sgi.com>
 <20121120042855.GE6186@mwanda>
 <20121120170723.GC11150@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121120170723.GC11150@sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2012 at 11:07:25AM -0600, Russ Anderson wrote:
> The issue isn't "ulong" vs "unsigned long".  The issue
> is int is 32 bit and long is 64 bit on x86_64.  Your 
> patch is casting the value as an "unsigned long" (64 bit
> on x86_64) into an int (32 bit).  I don't think that
> was your intent.

Wait what?  I only did int => long casts, not the other way around.

It occured to me to use u64 but this code is only compiled on x86_64
and I wrote my patch to match the surrounding context.

regards,
dan carpenter
