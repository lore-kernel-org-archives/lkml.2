Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935835Ab1KJEjo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 23:39:44 -0500
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:42546 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S935810Ab1KJDfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:35:41 -0500
Date: Thu, 10 Nov 2011 04:35:20 +0100
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jean Delvare <khali@linux-fr.org>, LKML <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] Make dmi_name_in_vendors more focused
Message-ID: <20111110043520.47e78e9c@jbarnes-x220>
In-Reply-To: <20111109142557.70cb43cb.akpm@linux-foundation.org>
References: <20111104102647.0b3eba22@endymion.delvare>
	<20111109142557.70cb43cb.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Nov 2011 14:25:57 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Fri, 4 Nov 2011 10:26:47 +0100
> Jean Delvare <khali@linux-fr.org> wrote:
> 
> > The current implementation of dmi_name_in_vendors() is an invitation
> > to lazy coding and false positives [1]. Searching for a string in 8
> > different DMI fields is something nobody should ever need to do. You
> > know what you're looking for, so you should know where to look.
> > strstr isn't fast, especially when it fails, so we should avoid
> > calling it when it just can't succeed.
> > 
> > Looking at the current users of the function, it seems clear to me
> > that they are looking for a system or board vendor name, so let's
> > limit dmi_name_in_vendors to these two DMI fields. This much better
> > matches the function name, BTW.
> > 
> > [1] We currently have code looking for short names in DMI data, such
> > as "IBM" or "ASUS". I let you guess what will happen the day other
> > vendors ship products named, for example, "SCHREIBMEISTER" or
> > "PEGASUS".
> > 
> > Signed-off-by: Jean Delvare <khali@linux-fr.org>
> > Cc: Andi Kleen <andi@firstfloor.org>
> > ---
> > This patch was already sent on 2011-05-15. I thought Andrew had
> > picked it up but apparently not, otherwise it should already be
> > upstream by now.
> 
> I did merge it in May and have carried it in -mm (and hence in
> linux-next) since then.  I have sent it to Jesse at least twice, with
> no effect.

I don't generally look after DMI stuff... I can queue it though if you
want.  My only worry is potential breakage for existing DMI matches,
but it looks like Jean already did the audit for that.

Jesse
