Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261Ab1DTBWW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 21:22:22 -0400
Received: from smtp-out.google.com ([74.125.121.67]:60706 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530Ab1DTBWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 21:22:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=d2h8ypwu7L1wUiCQNX9IK4Zcm9RHAHKZBZLRS8pD1QW25tGOx4qlXTBcJimJs4NzoH
         8c2zkcbukdzX+Ke+q4Vg==
Date: Tue, 19 Apr 2011 18:22:14 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>,
        J Freyensee <james_p_freyensee@linux.intel.com>
cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        suhail.ahmed@intel.com, christophe.guerard@intel.com
Subject: Re: [PATCH 1/4] export kernel call get_task_comm().
In-Reply-To: <1303258222.13457.42.camel@localhost>
Message-ID: <alpine.DEB.2.00.1104191817590.8047@chino.kir.corp.google.com>
References: <james_p_freyensee@linux.intel.com> <1303253889-10074-2-git-send-email-james_p_freyensee@linux.intel.com> <alpine.DEB.2.00.1104191620360.4300@chino.kir.corp.google.com> <1303258222.13457.42.camel@localhost>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Apr 2011, J Freyensee wrote:

> > > From: J Freyensee <james_p_freyensee@linux.intel.com>
> > > 
> > > This allows drivers who call this function to be compiled modularly.
> > > Otherwise, a driver who is interested in this type of functionality
> > > has to implement their own get_task_comm() call, causing code
> > > duplication in the Linux source tree.
> > > 
> > > Signed-off-by: J Freyensee <james_p_freyensee@linux.intel.com>
> > 
> > Acked-by: David Rientjes <rientjes@google.com>
> > 
> > There've been some other patchsets proposed recently that need to print a 
> > thread's comm and since /proc/pid/comm can change the comm's of other 
> > threads out from under them, it's necessary to serialize access to it with 
> > task_lock().  This patch certainly makes it easier for modules to do so 
> > correctly, thanks!
> 
> Thanks for the compliment; it's appreciated.  I've made my patch sets
> independent from one another.  And I believe a common consensus (at
> least with Greg KH, Alan C., Arjan VdV and myself) was achieved that
> this is a good patch to apply? So maybe this can be applied to the
> kernel, independent of my other patches, so this will fit your needs?
> 

This patch in particular can probably go through the -mm tree; the last 
activity for get_task_comm() was three years ago (59714d65dfbc 
"get_task_comm(): return the result") which also went through the -mm tree 
and its export is a general service to module authors.  Let's cc Andrew 
and see if he'll merge it.

The only other dependency on this is in your third patch in the series 
which actually has potential stack overflow that I'll comment on there, so 
there's nothing else that has a dependency on this patch being merged 
immediately.
