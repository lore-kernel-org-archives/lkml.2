Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757475Ab1KJINt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 03:13:49 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:48919 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757394Ab1KJINr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 03:13:47 -0500
Date: Thu, 10 Nov 2011 09:13:40 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] Make dmi_name_in_vendors more focused
Message-ID: <20111110091340.71e11192@endymion.delvare>
In-Reply-To: <20111109142557.70cb43cb.akpm@linux-foundation.org>
References: <20111104102647.0b3eba22@endymion.delvare>
	<20111109142557.70cb43cb.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Nov 2011 14:25:57 -0800, Andrew Morton wrote:
> On Fri, 4 Nov 2011 10:26:47 +0100
> Jean Delvare <khali@linux-fr.org> wrote:
> 
> > The current implementation of dmi_name_in_vendors() is an invitation
> > to lazy coding and false positives [1]. Searching for a string in 8
> > different DMI fields is something nobody should ever need to do. You
> > know what you're looking for, so you should know where to look. strstr
> > isn't fast, especially when it fails, so we should avoid calling it
> > when it just can't succeed.
> > 
> > Looking at the current users of the function, it seems clear to me
> > that they are looking for a system or board vendor name, so let's
> > limit dmi_name_in_vendors to these two DMI fields. This much better
> > matches the function name, BTW.
> > 
> > [1] We currently have code looking for short names in DMI data, such
> > as "IBM" or "ASUS". I let you guess what will happen the day other
> > vendors ship products named, for example, "SCHREIBMEISTER" or "PEGASUS".
> > 
> > Signed-off-by: Jean Delvare <khali@linux-fr.org>
> > Cc: Andi Kleen <andi@firstfloor.org>
> > ---
> > This patch was already sent on 2011-05-15. I thought Andrew had picked
> > it up but apparently not, otherwise it should already be upstream by
> > now.
> 
> I did merge it in May and have carried it in -mm (and hence in
> linux-next) since then.  I have sent it to Jesse at least twice, with
> no effect.
> 
> I'll send it to Linus for 3.3-rc1, OK?

If you want, sure. Note however that it might be less risky to send it
now, as I just audited the code. By 3.3-rc1, new callers might have
appeared and nobody may remember to audit again. Committing this kind
of change right after rc1 seems better than during the merge window, as
it lets us ensure that no new use case sneaked it.


-- 
Jean Delvare
