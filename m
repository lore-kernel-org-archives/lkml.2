Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751441Ab1GTMaz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 08:30:55 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60599 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936Ab1GTMay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 08:30:54 -0400
Subject: Re: Regression in handling of unsafe UBI shutdown
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Daniel Mack <zonque@gmail.com>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Sven Neumann <s.neumann@raumfeld.com>
Date: Wed, 20 Jul 2011 15:32:16 +0300
In-Reply-To: <CACTFLANrd0FO9GNJpvS+MxnQgLLtXpA-sai30oYN90cjEFOErA@mail.gmail.com>
References: <CACTFLANAFT=G4kFvHUqvLrt=MxgpJnJ-EeHY8zd49pZvsNRejw@mail.gmail.com>
	 <1311139283.20738.150.camel@sauron>
	 <CACTFLANrd0FO9GNJpvS+MxnQgLLtXpA-sai30oYN90cjEFOErA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1311165141.20738.171.camel@sauron>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-07-20 at 11:18 +0200, Daniel Mack wrote:
> On Wed, Jul 20, 2011 at 7:21 AM, Artem Bityutskiy <dedekind1@gmail.com> wrote:
> > On Tue, 2011-07-19 at 15:57 +0200, Daniel Mack wrote:
> >> UBIFS: recovery needed
> >> Error reading superblock on volume 'ubi:RootFS'!
> >> UBIFS not mounted, use ubifs mount to mount volume first!
> >> Wrong Image Format for bootm command
> >> ERROR: can't get kernel image!
> >>
> >>
> >> Hence my question is: were there any radical changes in the UBI/UBIFS
> >> code on the kernel side that make older code not like the new content
> >> anymore?
> >
> > Daniel, sorry, I have no time to look at this now, could you please try
> > to bisect the issue?
> 
> It's not really easy to bisect as the issue is not always fully
> reproducable, and also because the flash needs to be re-initialized
> after it happened.
> 
> Also note that it's not the kernel itself that complains about the
> state of the file system in this case but U-Boot. If we boot a 3.0-rc7
> kernel in such a situation (via USB for example), the kernel will
> recover the FS and continue.
> 
> I don't know how many people use the UBI code in U-Boot, and I don't
> know either whether it was a good idea to go this way in the first
> place, but we didn't want to waste much space on the NAND for a
> fixed-size partition just for the kernel, and have a hard limit for it
> in the future. And as I said, this approach has worked just fine in
> the past.
> 
> So, let me re-phrase my question: is anyone aware of changes in the
> UBIFS code between 2.6.36 and 3.0 that might cause trouble to U-Boot's
> UBI code from 2009?

I guess that would be an on-flash format change? I am not aware of such
changes, and if there were such - this is a big issue which we wound
need to fix.

-- 
Best Regards,
Artem Bityutskiy

