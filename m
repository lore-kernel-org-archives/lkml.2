Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755775Ab0KXSdK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 13:33:10 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:58862 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755485Ab0KXSdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 13:33:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=gZSMYkAOzS4E0WiBUaox6SPMBHMVVfDfpSQWTTypS8z9Mxe1+QAPECFjN//f0kGBii
         zAHsY47nlYIYQBjI4PjZ/JBRu2nSwVf9s9Wlw5FQ34w0gyV57hdE+Qm6CpnoBE+yD24q
         iX5JUSZgb98a9+p+usNiq+hnLXgtMY/KFDT0k=
Date: Wed, 24 Nov 2010 21:33:00 +0300
From: Vasiliy Kulikov <segoon@openwall.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kernel-janitors@vger.kernel.org, Dave Airlie <airlied@redhat.com>,
        Tiago Vignatti <tiago.vignatti@nokia.com>,
        Mike Travis <travis@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] gpu: vga: limit kmalloc'ed memory size
Message-ID: <20101124183300.GA31411@albatros>
References: <1290445864-13657-1-git-send-email-segoon@openwall.com>
 <20101122100915.5bf966fe.akpm@linux-foundation.org>
 <20101123190828.GA27159@albatros>
 <20101123124600.4401ea43.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101123124600.4401ea43.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

On Tue, Nov 23, 2010 at 12:46 -0800, Andrew Morton wrote:
> What I'm suggesting is that we simply do
> 
> 	kbuf = strndup_user(buf, count);
> 
> and make strndup_user() do the right thing if `count' turned out to be
> crazy large.  THis way we don't have to sprinkle decisions about "crazy
> largeness" all over the kernel.
> 
> And the way in which I suggest that strndup_user() decides whether the
> length is too great is to try to kmalloc that amount of memory. 
> If it succeeds then fine, proceed.

I don't think that it is a good idea - the process would have an ability
to allocate too much system memory bypassing any limits.  Assuming that
the kernel would only double the memory is not right - even if the
process is limited in physical memory it may pass address of e.g. mapped file.


Also this specific driver is happy with very low limit of copied string.

> If it fails then return an error,
> probably ENOMEM.

It is already done in strndup_user().

> And that attempt to invoke kmalloc() shouldn't spew a
> warning.

It is not obvious for me to change strndup_user's behaviour, I'm not
familiar with this code.


-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
