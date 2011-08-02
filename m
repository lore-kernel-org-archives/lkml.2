Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175Ab1HBJxp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 05:53:45 -0400
Received: from smtp-out.google.com ([74.125.121.67]:37802 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628Ab1HBJxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 05:53:40 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=VCtW7VQJT2dUkE6PLbt0eaMnL0tGdCJzwpC5KdXzexv+8Oihs3ErsWKV53xMQurEp
	tJCeSJj0wYv+vrmzJPnRw==
Date: Tue, 2 Aug 2011 02:53:34 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: Revert needed: udev spewing warnons on common systems in 3.0
In-Reply-To: <20110802101614.009cdf42@lxorguk.ukuu.org.uk>
Message-ID: <alpine.DEB.2.00.1108020249560.18935@chino.kir.corp.google.com>
References: <20110802005206.GA3832@tassilo.jf.intel.com> <20110801183207.cea89a96.akpm@linux-foundation.org> <CA+55aFw=wX1CormdOAnsoK2ruDLp9SaEVh1EcTj8wvt+Kq2gAg@mail.gmail.com> <alpine.DEB.2.00.1108011916480.15596@chino.kir.corp.google.com>
 <20110802101614.009cdf42@lxorguk.ukuu.org.uk>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Aug 2011, Alan Cox wrote:

> > It was a printk_once() when the tunable was scheduled to be removed two 
> > years later.  Now that one year has passed since the oom killer rewrite 
> > has been merged, it was changed to a WARN_ONCE() simply to attract more 
> > attention to the issue. 
> 
> For the most part the only people whose attention you need are the
> distributions not the end users so the WARN isn't helpful.
> 

That's obviously wrong since all of the applications that I've cited 
that have been fixed to date have been the result of users actually 
noticing the printk_once() and emailing me directly to pass it along to 
the appropriate parties.  I've also found other cases where bugzilla 
entries were created based on that single line warning by users, who in 
turn get distros and maintainers to convert to the new interface.

It's quite effective, but there are still some applications that have yet 
to be reported, hence the reason for anybody actually hitting this new 
WARN_ONCE().
