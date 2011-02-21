Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751460Ab1BUXk1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 18:40:27 -0500
Received: from adelie.canonical.com ([91.189.90.139]:46882 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006Ab1BUXkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 18:40:23 -0500
Date: Mon, 21 Feb 2011 23:40:15 +0000
From: Andy Whitcroft <apw@canonical.com>
To: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [BUG ?] checkpatch.pl rejects as error something I think it
 ought to be allow
Message-ID: <20110221234015.GG2809@shadowen.org>
References: <4D62F502.9040506@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D62F502.9040506@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 21, 2011 at 03:28:02PM -0800, Corey Ashford wrote:
> Hi,
> 
> I have a piece of code where I have two constants defined as follows:
> 
> 	static const unsigned long polling_interval_sec = 1;
> 	static const unsigned long polling_interval_ns = 0;
> 
> Now, it's clear to me that I want these two values to have the
> keywords const and static.  I could use a #define here, but const
> static seemed cleaner to me.
> 
> When I run checkpatch.pl across this code, I get this error:
> 
> ERROR: do not initialise statics to 0 or NULL.
> 
> I think the problem here is that another case is needed for "static
> const" that does allow 0.
> 
> What do you think?
> 
> Thanks for your consideration,

The warning is intended to tell you that the = 0 is unnecessary.  Any
static is 0 by default I believe.  At some point the addition of the 0
would move the value from the bss to the data segment bloating the code.
This may no longer be true.

-apw
