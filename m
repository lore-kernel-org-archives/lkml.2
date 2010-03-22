Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804Ab0CVM4i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 08:56:38 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:45689 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754765Ab0CVM4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 08:56:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=TRhJ4ndi2+EP0f1YN2LipmaBcSWtPf8T4JZ7ctrfGZa+lhbfn/2H2vZ8Ql228mYceM
         ba09JGelOCSRrLVJKYvpzc568D5ARHxT5E9paHIyHNlqn8oVkM1seim87imGbNWh/PBl
         94VOq1Nl2qQ1vSCmQrKlyL9HEaeHTkP7Z4ciM=
Date: Mon, 22 Mar 2010 15:56:26 +0300
From: Dan Carpenter <error27@gmail.com>
To: David Howells <dhowells@redhat.com>
Cc: kernel-janitors@vger.kernel.org, linux-afs@lists.infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] afs: potential null dereference
Message-ID: <20100322125626.GM21571@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	David Howells <dhowells@redhat.com>,
	kernel-janitors@vger.kernel.org, linux-afs@lists.infradead.org,
	linux-kernel@vger.kernel.org
References: <20100320111938.GT5331@bicker> <28809.1269259520@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <28809.1269259520@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 22, 2010 at 12:05:20PM +0000, David Howells wrote:
> Dan Carpenter <error27@gmail.com> wrote:
> 
> > It seems clear from the surrounding code that xpermits is allowed to be 
> > NULL here.
> 
> Interesting.  The memcpy() won't oops due to this because if it is given a
> NULL pointer, it will also be given a zero count.  I wonder if this means the
> if-statement your patch adds is actually unnecessary...
> 

I was concerned about the dereference here:

+       if (xpermits)
+               memcpy(permits->permits, xpermits->permits,
                                         ^^^^^^^^^^^^^^^^^
+                       count * sizeof(struct afs_permit));

This code has been there for three years, so yeah, you would think if it
were a problem someone would have complained.  My theory was "xpermits"
was almost always non-null.

regards,
dan carpenter

> David
