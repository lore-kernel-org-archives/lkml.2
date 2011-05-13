Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758023Ab1EMV5M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 17:57:12 -0400
Received: from smtp-out.google.com ([74.125.121.67]:5470 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755483Ab1EMV5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 17:57:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=qxd3pQTA1/RsWrCYawEHL3ydZSMfnGyDrOAfJ/v8lrtphAs++Zb+Uc2afP2u8TMSJ9
         TFxA7xq6o47ZGZ1kVyFQ==
Date: Fri, 13 May 2011 14:56:59 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Joe Perches <joe@perches.com>
cc: Andy Whitcroft <apw@canonical.com>, John Stultz <john.stultz@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>, "Ted Ts'o" <tytso@mit.edu>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Subject: Re: [PATCH 2/3] printk: Add %ptc to safely print a task's comm
In-Reply-To: <1305239342.6124.77.camel@Joe-Laptop>
Message-ID: <alpine.DEB.2.00.1105131455140.6451@chino.kir.corp.google.com>
References: <1305073386-4810-1-git-send-email-john.stultz@linaro.org> <1305073386-4810-3-git-send-email-john.stultz@linaro.org> <1305075090.19586.189.camel@Joe-Laptop>  <1305076246.2939.67.camel@work-vm> <1305076850.19586.196.camel@Joe-Laptop>
 <alpine.DEB.2.00.1105121510330.9130@chino.kir.corp.google.com> <1305239342.6124.77.camel@Joe-Laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 May 2011, Joe Perches wrote:

> > > > Although I'm not sure if there's precedent for a %p value that didn't
> > > > take a argument. Thoughts on that? Anyone else have an opinion here?
> > > The uses of %ptc must add an argument or else gcc will complain.
> > > I suggest you just ignore the argument value and use current.
> > That doesn't make any sense, why would you needlessly restrict this to 
> > current when accesses to other threads' ->comm needs to be protected in 
> > the same way?  I'd like to use this in the oom killer and try to get rid 
> > of taking task_lock() for every thread group leader in the tasklist dump.
> 
> I suppose another view is coder stuffed up, let them suffer...
> 
> At some point, gcc may let us extend printf argument type
> verification so it may not be a continuing problem.
> 

I don't understand your respose, could you answer my question?  Printing 
the command of threads other than current isn't special.
