Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758773Ab1EMKqh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 06:46:37 -0400
Received: from mail-px0-f173.google.com ([209.85.212.173]:35280 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758368Ab1EMKqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 06:46:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=bncN+DTwdNgdhpPCwUCm5WZe4pLSlGn4Jd39vgprpzLZzTKjyXbXcUbhF0UPKJEtAm
         gwSOtUma8JVWp2EkcXXNQp5oqLchjTJE+n8iG0jchXQAVQtsw/2RozT2vJGwEilXaxNh
         Mnh8M9Cxv2QAc6W+wnNJIJtYlo//IEZCI37Ts=
From: Jason Stubbs <jasonbstubbs@gmail.com>
To: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] platform: fix samsung brightness min/max calculations
Date: Fri, 13 May 2011 20:44:25 +1000
User-Agent: KMail/1.13.7 (Linux/2.6.38-gentoo-r5; KDE/4.6.3; x86_64; ; )
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
References: <201104201358.50443.jasonbstubbs@gmail.com> <201105121214.00015.jasonbstubbs@gmail.com> <20110512164402.GD26585@kroah.com>
In-Reply-To: <20110512164402.GD26585@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201105132044.25928.jasonbstubbs@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 May 2011 02:44:02 Greg KH wrote:
> On Thu, May 12, 2011 at 12:13:59PM +1000, Jason Stubbs wrote:
> > On Wed, 11 May 2011 23:51:14 Greg KH wrote:
> > > On Wed, May 11, 2011 at 02:47:49PM +1000, Jason Stubbs wrote:
> > > > The patch doesn't apply cleanly on top of the nc210/nc110 patch
> > > > though as they both modify set_brightness(). It might apply with a
> > > > higher fuzz factor as the changes don't actually clash. Should I
> > > > redo the patch?
> > > 
> > > Please do.
> > 
> > Will send seperately. Doing this though, I found a problem with the
> > nc210/nc110 patch in that (user_level == read_brightness()) check should
> > actually be (user_brightness == read_brightness()). What should I do
> > about this?
> 
> I don't know, as you seem to understand this better than I do at this
> point, I'll trust your changes :)

I meant that patch A is broken but (working) patch B applies on top of patch
A so should I submit a patch C to fix patch A, submit a fixed patch A and
then resubmit a patch B against that, or... I'm just unsure of the
development process.

As far as I can tell, the patches aren't applied to any trees yet and are
just sitting in .../gregkh/patches.git. If that's the case, what I would like
is for fix-samsung-brightness-min-max-calculations.patch to be replaced with
the version in https://lkml.org/lkml/2011/4/20/1 and I resubmit a fixed (and
enhanced) add-support-for-samsung-nc210-nc110.patch that applies on top of
it. That way an enhancement patch won't hold up a bugfix patch should there
be any further issues.

I actually wasn't particularly happy with the nc210-n110 patch and was hoping
for some guidance but I think I've managed to implement the workaround
cleanly now so I'll post it in a sec. If you take it and the 2011/4/20/1 one,
great! Otherwise, please let me know what to do. (and sorry for the bother!)

Regards,
Jason Stubbs
