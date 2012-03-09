Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030621Ab2CIUe5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 15:34:57 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:51696 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030437Ab2CIUez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 15:34:55 -0500
Date: Fri, 9 Mar 2012 14:34:46 -0600
From: Jonathan Nieder <jrnieder@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, "H. Peter Anvin" <hpa@zytor.com>,
        Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@hack.frob.com>
Subject: Re: [ 17/68] regset: Return -EFAULT, not -EIO, on host-side memory
 fault
Message-ID: <20120309203446.GB23244@burratino>
References: <20120309194409.GA2069@kroah.com>
 <20120309190216.344083722@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120309190216.344083722@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:

> 3.0-stable review patch.  If anyone has any objections, please let me know.
>
> ------------------
>
> From: "H. Peter Anvin" <hpa@zytor.com>
>
> commit 5189fa19a4b2b4c3bec37c3a019d446148827717 upstream.
>
> There is only one error code to return for a bad user-space buffer
> pointer passed to a system call in the same address space as the
> system call is executed, and that is EFAULT.

I don't think this has the potential to cause regressions, and it
certainly makes things saner, so from that point of view it looks
good.  But I am still wondering how it matches the following
criterion:

 - It must fix a problem that causes a build error (but not for things
   marked CONFIG_BROKEN), an oops, a hang, data corruption, a real
   security issue, or some "oh, that's not good" issue.  In short, something
   critical.

Can someone enlighten me?

Part of the reason I am asking is to figure out whether the patch
ought to be applied to 2.6.32.y, too.

Thanks,
Jonathan
