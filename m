Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755381Ab1BROvG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 09:51:06 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36180 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753670Ab1BROvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 09:51:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=IWXqZ+jXkWUStGZ/tB7IVquU6iv8lAQKMKQ9AosF7VqEmUYLwY5w5AORYWNyoe0zzz
         RjYRVd/IUlzc0w+H6irsM/sqr3/knsAFn+X+2NkXdqR17zOR7prH9rfMf+/oMEWR3cMQ
         p2PQkyMc7hrjsEmGIxlF4KtmXnI7lH84I+N2Q=
Date: Fri, 18 Feb 2011 15:50:57 +0100
From: Tejun Heo <tj@kernel.org>
To: Stefan Bader <stefan.bader@canonical.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-ide@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>,
        Andy Whitcroft <apw@canonical.com>
Subject: Re: Some hints needed how to handle SATA ALPM failures
Message-ID: <20110218145057.GM21209@htj.dyndns.org>
References: <4D5E6CE1.9020908@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D5E6CE1.9020908@canonical.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Feb 18, 2011 at 01:58:09PM +0100, Stefan Bader wrote:
> We are hoping that those working more closely with the SATA code might
> be aware of this issue.  As the symptoms are so severe (data corruption)
> we have ALPM disabled globally, but this does make it hard to get more
> targeted information on affected platforms.

What do you mean by data corruption?  File system ro remount or actual
fs corruption?  If actual fs corruption is happening, it's highly
likely that there's an underlying issue with the hardware.  If data
corruption can be reproduced, can you please run smartctl -a before
and after such failure and post the outputs?

As for ro remounts, I recall applying fixes for that months ago.  I
don't remember the details but some configurations raised extra PHY
event afterwards and command was failed without retry.  Anyways, it
got fixed.  Please dig through the log for details.

Also, the whole LPM thing got revamped several releases ago.  Can you
please test how the recent kernels behave?  There will be failures as
not all hardware can handle LPM well but those failures shouldn't lead
to any catastrophic failures like ro remounting of filesystem.

Thanks.

-- 
tejun
