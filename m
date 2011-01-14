Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757470Ab1ANC6J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 21:58:09 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:42604 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576Ab1ANC6C convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 21:58:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=rpGayE1VYaHglLd2l0xPlUNSEDXf34LQGeancfdkeYokM/jaRNwU//hgEKDvoVxg8K
         2egIjei8Wq7Ih/f4s4IWqALFspKopksTD90aC0qyRC4EDpBtzAS6X6zqBVXgywEBuWwx
         rmfhDDyk/vGC6GYMWxmywFTdjC/lnP+9oLAYU=
MIME-Version: 1.0
In-Reply-To: <8855.1294927436@jrobl>
References: <8855.1294927436@jrobl>
Date: Fri, 14 Jan 2011 13:57:55 +1100
Message-ID: <AANLkTik1bj=Z9xFv8JfYrxqefFL1owmH=Rctj=XnH4Mp@mail.gmail.com>
Subject: Re: vfs-scale, d_revalidate from nfsd
From: Nick Piggin <npiggin@gmail.com>
To: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 14, 2011 at 1:03 AM, J. R. Okajima <hooanon05@yahoo.co.jp> wrote:
>
> NFSD calls filesystem's ->d_revalidate() with the parameter nd == NULL.
> So every
>        if (nd->flags & LOOKUP_RCU)
>                return -ECHILD;
> code which was added to ->d_revalidate() of FS which supports NFS
> exporting will crash.
>
> If we rewrite it as
>        if (nd && (nd->flags & LOOKUP_RCU))
>                return -ECHILD;
> the problem may not occur.
> But I am not sure whether lookup_one_len() call in NFSD support rcu-walk.

Ah, good catch.

I'm going to change the d_revalidate API so it takes and inode and rcu-walk
flag parameter to make it easier for filesystems to implement rcu-walk.

That will take care of this NULL nd case.

Thanks,
Nick
