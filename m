Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758064Ab0HQRtH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 13:49:07 -0400
Received: from smtp-out.google.com ([216.239.44.51]:26128 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754819Ab0HQRtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 13:49:03 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=hJbulRg30Xw5QyY7K6Kt296T5Z9pqF6FOI8wBWkTW58xE7ie5luDTfEEo3TJT9Hip
	4wP9M/Jtibgf7BTNdeHsg==
Date: Tue, 17 Aug 2010 10:48:54 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Jan Kara <jack@suse.cz>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 4/6] jbd: remove dependency on __GFP_NOFAIL
In-Reply-To: <20100817095103.GA3557@quack.suse.cz>
Message-ID: <alpine.DEB.2.00.1008171046330.6486@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1008161953430.17924@chino.kir.corp.google.com> <alpine.DEB.2.00.1008161956190.17924@chino.kir.corp.google.com> <20100817095103.GA3557@quack.suse.cz>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Aug 2010, Jan Kara wrote:

> > Removes the dependency on __GFP_NOFAIL by looping indefinitely in the
> > caller.
> > 
> > The error handling when kzalloc() returns NULL in start_this_handle()
> > was removed since it was unreachable.
>   Thanks! I've added the patch to my tree. Since rc1 is over, I think this
> is a material for the next merge window, right?

Yes, we still need to switch over GFP_KERNEL callers and remove the flag 
completely, so there's no hurry for this to go into 2.6.36.
