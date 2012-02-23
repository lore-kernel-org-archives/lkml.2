Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756746Ab2BWTua (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 14:50:30 -0500
Received: from smtp.snhosting.dk ([87.238.248.203]:32224 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756267Ab2BWTu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 14:50:28 -0500
Date: Thu, 23 Feb 2012 20:50:26 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Dave Airlie <airlied@linux.ie>
Cc: Bobby Powers <bobbypowers@gmail.com>, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, davem@davemloft.net
Subject: Re: [PATCH] linux headers: include linux/types.h where appropriate
Message-ID: <20120223195026.GA30895@merkur.ravnborg.org>
References: <1330023731-14043-1-git-send-email-bobbypowers@gmail.com> <alpine.DEB.2.00.1202231927240.24797@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1202231927240.24797@skynet.skynet.ie>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 23, 2012 at 07:28:10PM +0000, Dave Airlie wrote:
> 
> > This silences the related header check warnings.
> 
> please fix the bug in the correct place, the drm.h header includes 
> linux/types.h and this is one on purpose.
> 
> maybe expend some effort fixing the stupid tool to recurse like a normal 
> preprocessor would.

Before we fix the tool maybe we should agree on what the tool should check for.
One obvious thing to check is that we do not start to use user-land
types in our exported headers like uint32_t etc.
Another could be that no header file should depend oon the user to include other
header files.
Etc.

The checks we have implmented today are very conservative - but as you resist
to add a few includes in the drm/drm*.h files prevents us from hitting
zero warnings even with these conservative checks.

If we started to be more strict we would see much more warnings/errors.
But all this fuzz about a handfull of includes in the drm header files
sure scare me away from ever starting this.
I can only image the uproar some other changes may cause then.

	Sam
