Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751464Ab0CUGGR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 02:06:17 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:3399 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005Ab0CUGGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 02:06:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=KhoRLL4y0F3+zdbVFQhHs8QToAH7PWVcuXwgIWvKOZxGdt+wnlTsyKXO+8tTjfBS7R
         fMlQOR09VifD0MAFU7EsaFiL0g9n8OKcFNrCaSuX6G3m5YpVuFFqWlvwLWqNX7ip33en
         mEBhb+vzC5b6DfFz0OWJjj8A9q9hQgKOSVbhw=
Date: Sun, 21 Mar 2010 08:06:07 +0200
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jiri Slaby <jirislaby@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Neil Horman <nhorman@tuxdriver.com>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [git pull] pull request for writable limits for 2.6.34-rc0
Message-ID: <20100321060607.GA4062@x200>
References: <4B1D32D1.4090404@gmail.com>
 <4B9136F4.4010007@gmail.com>
 <alpine.LFD.2.00.1003201207160.18017@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1003201207160.18017@i5.linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 20, 2010 at 12:20:58PM -0700, Linus Torvalds wrote:
> On Fri, 5 Mar 2010, Jiri Slaby wrote:
> > 
> > please pull the writable limits tree below.

> As a result, I ended up looking at the writable limits only today.
> 
> And I'm not entirely happy. For example, I absolutely _detest_ seeing new 
> compat code for a feature that was just added. My immediate reaction is 
> "WTF? What kind of moron doesn't make things 64-bit safe to begin with?". 
> It's really annoying.
> 
> Why doesn't the new set/getprlimit things just take a pointer to a 
> well-defined pair of 64-bit values? Why is there any compat cruft at all 
> there? That is beyond insane. Just make the user level interface work 
> right in the first place, instead of adding crazy compat crap. This is 
> _not_ a legacy interface.

It's a perfect opportunity to introduce getrlimit64(2), setrlimit64(2)
_without_ involving /proc, without all bugs in setrlimit(2), without
compat code, with all resources equal across arches, and, optionally,
with infinity setting clearly separate from value (useful for C/R).

Pity, we will have config option for 64-bit internal rlimits.

	Alexey, who detests /proc/self/limits format
