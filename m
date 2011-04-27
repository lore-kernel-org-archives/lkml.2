Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752675Ab1D0F6j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 01:58:39 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:62643 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988Ab1D0F6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 01:58:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=bXvsyrmJLdlkt1UbyAdRpaqg6MZf6TZ/elwyAd0T1jITSDoYz7asxSa979LULoE0hi
         5D+BT1lV/p6i1rr0flXjRE/i0vgGlOvrR2EPp2LOApyHZfcY2pGHx0+GN7OxS+aWp1aT
         N2b1FSX8nSs4i8oz/9SDOe5q77rXUsyKxZiUQ=
Subject: Re: [PATCH] Applying inappropriate ioctl operation on socket
 should return ENOTTY
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Lifeng Sun <lifongsun@gmail.com>
Cc: linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>
In-Reply-To: <1303882625-28115-1-git-send-email-lifongsun@gmail.com>
References: <1303882625-28115-1-git-send-email-lifongsun@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 27 Apr 2011 07:58:30 +0200
Message-ID: <1303883910.2699.53.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 27 avril 2011 à 13:37 +0800, Lifeng Sun a écrit :
> ioctl() calls against a socket with an inappropriate ioctl operation
> are incorrectly returning EINVAL rather than ENOTTY:
> 
>   [ENOTTY]
>       Inappropriate I/O control operation.
> 
> BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=33992
> 
> This bug is not limited to socket, it also occurs in a lot of, maybe
> some hundred, other ioctl operations, while in the patch I only fixed
> about a dozen of additional ones in pipe, fifo and character device
> drivers.

Really ?

EINVAL is ok too : Request or argp is not valid.

I would say, its not a bug as you claim. 

Its really too late to make such change and risk regressions.

isatty(fd) performs well. Please use it instead.

Also, networking patches should be sent to netdev@vger.kernel.org and
David Miller, as mentioned in MAINTAINERS file.



