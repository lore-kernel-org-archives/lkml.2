Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752761Ab1D0G5p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 02:57:45 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:42688 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988Ab1D0G5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 02:57:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=b2wWjnvVuHzGib8g/EMPckABLD+Di02n3unQUroqH5LWVYqh97yBNAdGwwvre8hFVF
         7SNIbJNLJWyYk7XGsoF9VEoxUR+SGPC7blcj9x1khgthGmAk0XhX6hbahQM1CMm6Pki1
         AVsZ2VslyTtuA+6R5TyVSto6zVsJEVtBuage0=
Subject: Re: [PATCH] Applying inappropriate ioctl operation on socket
 should return ENOTTY
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Lifeng Sun <lifongsun@gmail.com>
Cc: linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>
In-Reply-To: <20110427063730.GA20313@md5.ntu.edu.sg>
References: <1303882625-28115-1-git-send-email-lifongsun@gmail.com>
	 <1303883910.2699.53.camel@edumazet-laptop>
	 <20110427063730.GA20313@md5.ntu.edu.sg>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 27 Apr 2011 08:57:37 +0200
Message-ID: <1303887457.2699.60.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 27 avril 2011 à 14:37 +0800, Lifeng Sun a écrit :
> On 07:58 Wed 04/27/11 Apr, Eric Dumazet wrote:
> > Really ?
> > 
> > EINVAL is ok too : Request or argp is not valid.
> 
> I'm afraid not. SUSv4 specifies, say,
> 
>   int tcsetattr(int fildes, int optional_actions,
>          const struct termios *termios_p);
> 
>  ERROR:
>   [EINVAL]
>       The optional_actions argument is not a supported value, or an
>       attempt was made to change an attribute represented in the
>       termios structure to an unsupported value.
> 
>   [ENOTTY]
>       The file associated with fildes is not a terminal.
> 
> which means when we apply tcsetattr (implemented by ioctl) to _any_
> non-terminal file descriptor, it should set errno to ENOTTY rather
> than EINVAL.
> 

You quote manpage for a library call, not a system call.

If you feel your glibc doesnt implement well this, please complain to
glibc maintainer.



