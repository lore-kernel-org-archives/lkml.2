Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753708Ab0HBMrO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 08:47:14 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:37406 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753527Ab0HBMrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 08:47:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=qqZ2FMy4jhcp2AkQdYuyMGjZPbSPQFJmC+/1jbu8zV2NhavyjYkCWgi2PovjKv2cep
         757J27y25adugmHflEaxHV3Gbl4O3iwUGh/Giz2WtxnZG+teltkrV+tgDv+ckM4Mvy45
         E9oDyWQ2uAGuhkaHC34EVhrSb2TbL6D1FCh6w=
Date: Mon, 2 Aug 2010 16:47:04 +0400
From: Vasiliy Kulikov <segooon@gmail.com>
To: Jesper Nilsson <Jesper.Nilsson@axis.com>
Cc: "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        Mikael Starvik <mikael.starvik@axis.com>,
        linux-cris-kernel <linux-cris-kernel@axis.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cris: gpio: do not call
 copy_to_user()/copy_from_user() while holding spinlocks
Message-ID: <20100802124704.GA6050@albatros>
References: <1280410338-21501-1-git-send-email-segooon@gmail.com>
 <20100802113316.GJ9784@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100802113316.GJ9784@axis.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 02, 2010 at 13:33 +0200, Jesper Nilsson wrote:
> On Thu, Jul 29, 2010 at 03:32:18PM +0200, Kulikov Vasiliy wrote:
> > copy_to_user()/copy_from_user() must not be used with spinlocks held.
> > Move all cases of interaction with userspace out of global switch and
> > lock spinlocks only where they are needed.
> 
> Thanks, but I'm thinking we should move the spinlock inside each case instead,
> as in the below patch.
> Unless there's any protests I'll add it to the cris-tree in the next couple of days:

I'm fine with this.

> 
> CRIS: gpio: don't call copy_to_user()/copy_from_user() while holding spinlocks
> 
> copy_to_user()/copy_from_user() must not be used with spinlocks held.
> Move locks inside each case so we have better control of when the locks
> are held.
> 
> Also, since we use spinlocks, we don't need to hold the BKL, so remove it.
> 
> Reported-by: Kulikov Vasiliy <segooon@gmail.com>
> Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
...
