Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651Ab1AFXso (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 18:48:44 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35246 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625Ab1AFXsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 18:48:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=tl3YpDbXtOSRF378na4pkYTw8O5PfKUo6uvsPZXtuqgH/diHjGJYxoZJ1iXOsVRxNL
         k/wNz2hfIzF+fhpfWBKbEBKaL+MMWFptrDQScACmmJnrJVELzq5vBf/IL941iF3BnWAX
         XruZe+5yv3vp5r6WDwX2swTweF6v+N2kInwws=
Date: Fri, 7 Jan 2011 02:47:57 +0300
From: Dan Carpenter <error27@gmail.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH][rfc] xattr acl: Suspicious use of potentially null
 pointer.
Message-ID: <20110106234750.GB1761@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Jesper Juhl <jj@chaosbits.net>, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>
References: <alpine.LNX.2.00.1101062247420.13988@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1101062247420.13988@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 06, 2011 at 10:52:22PM +0100, Jesper Juhl wrote:
> 
> In posix_acl_from_xattr() we have this at the head of the function:
> 
>   		posix_acl_xattr_header *header = (posix_acl_xattr_header *)value;
>    		posix_acl_xattr_entry *entry = (posix_acl_xattr_entry *)(header+1), *end;
> 
> Since 'value' is passed in by the caller and may be NULL, the second line 
> looks suspicious to me - taking a potentially NULL pointer (at least 
> btrfs will pass something allocated with kmalloc() which may be NULL), 
> adding one to it and casting it does not seem like it would always be such 
> a hot idea.

The original code is fine.

regards,
dan carpenter

