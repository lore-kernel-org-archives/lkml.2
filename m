Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456Ab2CLQ5V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 12:57:21 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:39056 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753185Ab2CLQ5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 12:57:19 -0400
Date: Mon, 12 Mar 2012 11:57:03 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: Thomas Rast <trast@inf.ethz.ch>
Cc: Willy Tarreau <w@1wt.eu>, Greg KH <greg@kroah.com>,
        Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, git@vger.kernel.org,
        Thomas Rast <trast@student.ethz.ch>
Subject: Re: stripping [PATCH] without losing later tags from mailed patches
 (Re: [ 02/12] Remove COMPAT_IA32 support)
Message-ID: <20120312165703.GB18791@burratino>
References: <20120312002046.041448832@1wt.eu>
 <1331514446.3022.140.camel@deadeye>
 <20120312024948.GB4650@kroah.com>
 <20120312063027.GB8971@1wt.eu>
 <20120312064855.GB16820@burratino>
 <20120312085820.GA11569@1wt.eu>
 <20120312152004.GB9380@kroah.com>
 <20120312152453.GB12405@1wt.eu>
 <87aa3l4vqq.fsf@thomas.inf.ethz.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87aa3l4vqq.fsf@thomas.inf.ethz.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Rast wrote:

> The problem with -b is that it's a backwards-compatibility shorthand for
> --binary, which used to pass --allow-binary-replacement (or --binary) to
> git-apply.  However, that option was obsoleted in 2b6eef9 (Make apply
> --binary a no-op., 2006-09-06) and has been a no-op for over 5 years.
> It has also not been documented since cb3a160 (git-am: ignore --binary
> option, 2008-08-09).
>
> So perhaps we can safely claim -b for --keep-non-patch, like so:

Thanks.

It we want to be extra friendly to people who have been using
"format-patch --binary" with "am -b" in their scripts, we could have a
transitional period during which -b is treated as a usage error.

Luckily, a quick Google code search does not reveal any users for "am
-b", so I am not too worried and would not mind your patch that just
switches over right away, though.  After all, the failure modes are:

 - if my current script using "am -b" gets run using ancient git, it
   will accept binary patches and will strip out too many brackets
   in the subject line

 - if my ancient script using "am -b" gets run using current git, it
   will helpefully keep [IA64] brackets in the subject line

Neither seems terribly painful.

The manual would need to mention that this once meant --binary to
avoid confusion when that happens.

Hope that helps,
Jonathan
