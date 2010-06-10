Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759775Ab0FJVvN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 17:51:13 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40206 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497Ab0FJVvL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 17:51:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:references
         :in-reply-to:mime-version:content-type:content-transfer-encoding
         :message-id;
        b=VvvpHHLbmGTO0/b+SmrA/vIAq902lf1E6m2BP/RPiiuMFyxODgRczhSfpygOEsZEFn
         REZWxYhjqHSGbujsCLtyu/NMxYaLXt2ozP0DDcFaF8f39FAR7sq/FM2s/CBE2Lq2LnZl
         swK1rZSHtudeDETXqCdoDaB9w5gYv7lpX0P8k=
From: Marek Vasut <marek.vasut@gmail.com>
Organization: Hack&Dev
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] sa1111: Prevent deadlock in resume path
Date: Thu, 10 Jun 2010 23:49:12 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.33-2-amd64; KDE/4.4.3; x86_64; ; )
Cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>, julia@diku.dk,
       linux-arm-kernel@lists.infradead.org,
       kernel list <linux-kernel@vger.kernel.org>
References: <1274901104-22133-1-git-send-email-marek.vasut@gmail.com> <20100526201824.GA16418@n2100.arm.linux.org.uk> <20100610135609.GC4514@ucw.cz>
In-Reply-To: <20100610135609.GC4514@ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201006102349.12849.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne Čt 10. června 2010 15:56:10 Pavel Machek napsal(a):
> On Wed 2010-05-26 21:18:24, Russell King - ARM Linux wrote:
> > On Wed, May 26, 2010 at 09:15:57PM +0200, Marek Vasut wrote:
> > > Dne St 26. května 2010 21:14:25 Russell King - ARM Linux napsal(a):
> > > > On Wed, May 26, 2010 at 09:11:44PM +0200, Marek Vasut wrote:
> > > > > This patch reorganises the sa1111_resume() function in a manner the
> > > > > spinlock happens after calling the sa1111_wake(). This fixes two
> > > > > bugs:
> > > > > 
> > > > > 1) This function called sa1111_wake() which tried to claim the same
> > > > > spinlock
> > > > > 
> > > > >    the sa1111_resume() already claimed. This would result in
> > > > >    certain deadlock.
> > > > >    
> > > > >    Original idea for this part: Russell King
> > > > >    <linux@arm.linux.org.uk>
> > > > > 
> > > > > 2) The function didn't unlock the spinlock in case the chip didn't
> > > > > report
> > > > > 
> > > > >    correct ID.
> > > > >    
> > > > >    Original idea for this part: Julia Lawall <julia@diku.dk>
> > > > > 
> > > > > Signed-off-by: Marek Vasut <marek.vasut@gmail.com>
> > > > 
> > > > Yea, good enough.
> > > 
> > > You want me to fight your patch tracking system or will you just merge
> > > it into your tree ?
> > 
> > What do you mean "fight" ?  Just send a standard git formatted patch
> > to the email address with an additional KernelVersion: tag.  It's
> > not at all hard.
> 
> You are linux kernel maintainer. Start acting as one. It is not at all
> hard.
> 
> Alternatively, just remove KernelVersion: checking in  your
> scripts.
> 
> 									Pavel

Even though my problem was fixed (yeah, sorry Russell, I didn't know the patch 
tracker was updated to support git-send-email), I have a question though.

I believe that Kernel-version is unnecessary. Isn't this information already 
encoded in the git-send-emailed patch?

btw. guys, before another burning discussion emerges, if you two plan to make 
your fights into a new sports discipline, I won't mind taking the role of a 
spectator ;-) Some possible criteria would be a length of the replying email or 
number of rough words ;-)
