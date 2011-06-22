Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758813Ab1FVTHt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 15:07:49 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42464 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758730Ab1FVTHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 15:07:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=LSmG7uHCnd2MS5xNj4aC6YWB//FdpKEi5qpZWsa9fMw9Fhi9xfrDeRKNQQIRxeTGlD
         NZGeIVBnRoYd2wiVkkC5rajLoatFmOwvGIeS36af3iLIg7yc1Fx8ub6psPw6y3t8rbfD
         0zy3wVzM8uKer3N/TVGFscfJGKK1g1fUE5L7k=
Date: Wed, 22 Jun 2011 23:07:39 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Joe Perches <joe@perches.com>, Andrew Morton <akpm@linux-foundation.org>,
        James Morris <jmorris@namei.org>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org,
        security@kernel.org
Subject: Re: [PATCH] kernel: escape non-ASCII and control characters in
 printk()
Message-ID: <20110622190739.GB14351@albatros>
References: <20110622095341.GA3353@albatros>
 <1308760683.10423.16.camel@Joe-Laptop>
 <20110622191022.66135615@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110622191022.66135615@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

On Wed, Jun 22, 2011 at 19:10 +0100, Alan Cox wrote:
> If that is set you shouldn't be filtering out unicode, just control codes.

OK.

> Minor other nit is that you might want to allow BEL through and you
> certainly want to allow tab through.

In what situation do you think BEL makes sense in kernel log?  I cannot
image the situation.  Alarms should use KERN_EMERG/KERN_ALERT log level.

> The core code should not be hardcoding policy assumptions about symbol
> sets and ASCII, for an awful lot of consoles today that assumption is
> just plain wrong, for others it makes sense

No problem, I don't insist.

> So with tty maintainer hat on - NAK to the current approach but a good
> idea to do it properly.


The final check should be:

    if (iscntrl(c) && (c != '\n') && (c != '\t'))

Any comments against this variant?


Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
