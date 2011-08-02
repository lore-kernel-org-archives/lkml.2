Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755535Ab1HBVub (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 17:50:31 -0400
Received: from smtp-out.google.com ([74.125.121.67]:21845 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755421Ab1HBVuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 17:50:24 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=xcRZ/kyrWclkzxC0ptnBX/v62MIJB4Vjzek9JwSnr6J8IfcPZ9k5ig99CjFZZDFTa
	e5MFZiZIhRx0DrHaJ/8JA==
Date: Tue, 2 Aug 2011 14:50:19 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andi Kleen <andi@firstfloor.org>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: Revert needed: udev spewing warnons on common systems in 3.0
In-Reply-To: <4b1d9f7714d8b7e26365720f4338f9cc.squirrel@www.firstfloor.org>
Message-ID: <alpine.DEB.2.00.1108021446420.12258@chino.kir.corp.google.com>
References: <20110802005206.GA3832@tassilo.jf.intel.com> <20110801183207.cea89a96.akpm@linux-foundation.org> <CA+55aFw=wX1CormdOAnsoK2ruDLp9SaEVh1EcTj8wvt+Kq2gAg@mail.gmail.com> <alpine.DEB.2.00.1108011916480.15596@chino.kir.corp.google.com>
 <20110802101614.009cdf42@lxorguk.ukuu.org.uk> <alpine.DEB.2.00.1108020249560.18935@chino.kir.corp.google.com> <20110802111117.10a73b89@lxorguk.ukuu.org.uk> <4b1d9f7714d8b7e26365720f4338f9cc.squirrel@www.firstfloor.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Aug 2011, Andi Kleen wrote:

> And that's fine because nothing is fundamentally broken here that
> needs urgent fixing (except for that bogus backtrace of course)
> 

Maybe not urgent, but needs to be fixed within the next 12 months because 
all of the users of /proc/pid/oom_adj thus far have been to disable oom 
killing for the thread and that protection isn't guaranteed when the 
tunable is removed.  Doing echo -17 > /proc/pid/oom_adj is a pretty good 
indicator that the process is important.

> The right way is to add a one linker printk_once and then just wait
> for a few years.
> 

This is what I did, except I waited one year instead of a few and now I 
wanted to add a more verbose warning for those that still haven't been 
fixed because we're one year away from the tunable's scheduled removal.  
If you're going to reply with a concern about the stack trace again, 
please see my patch I posted for Linus if the kernel log parsers are 
really that delicate.
