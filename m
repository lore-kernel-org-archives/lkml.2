Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751798Ab1CJLZ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 06:25:57 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:54437 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925Ab1CJLZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 06:25:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=PZL0mZFbfpjcM4xtoafcfrQ+BO1cCwIH1/DbtcTPx99TXQKGn9nyJb6I3LmQ3vvVMe
         RGBR34NpIhOYpp8stX4CnqKLA0uWSU1BgdFFOUr8pf7+j+F/kywvkboTl9y1OywrfHNp
         HAVpFgKAHyPPpRexR+6f9OBqrnJ40uP7+gAOM=
Date: Thu, 10 Mar 2011 12:25:38 +0100
From: Johan Hovold <jhovold@gmail.com>
To: NeilBrown <neilb@suse.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: MD-raid broken in 2.6.37.3?
Message-ID: <20110310112538.GD14009@localhost>
References: <20110309090622.GA3570@localhost>
 <20110309210251.744ef954@notabene.brown>
 <20110309192642.GA4098@localhost>
 <20110310092837.7b52cccd@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110310092837.7b52cccd@notabene.brown>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 10, 2011 at 09:28:37AM +1100, NeilBrown wrote:
> On Wed, 9 Mar 2011 20:26:42 +0100 Johan Hovold <jhovold@gmail.com> wrote:
> 
> > On Wed, Mar 09, 2011 at 09:02:51PM +1100, NeilBrown wrote:
> > > On Wed, 9 Mar 2011 10:06:22 +0100 Johan Hovold <jhovold@gmail.com> wrote:

[...]

> > It's the whole array that is missing. The raid-1 arrays appear but the
> > raid-0 does not.
> 
> Based on that I am very confident that the problem is not related to
> an md patches in 2.6.37.3 - and your own testing below seems to confirm that.
> 
> > > If you still have the boot-log from when you booted 2.6.37.3 (or can
> > > recreated) and can get a similar log for 2.6.37.2, then it might be useful to
> > > compare them.
> > 
> > Attaching two boot logs for 2.6.37.3 with /dev/md6 missing, and one for
> > 2.6.37.2.
> > 
> > Note that md1, md2, and md3 have v0.90 superblocks, whereas md5 and md6 have
> > v1.20 ones and are assembled later.
> > 
> > When /dev/md6 is successfully assembled, through the gentoo init scripts
> > calling "mdadm -As", the log contains:
> > 
> > 	messages.2:Mar  8 20:44:19 xi kernel: md: bind<sda6>
> > 	messages.2:Mar  8 20:44:19 xi kernel: md: bind<sda5>
> > 	messages.2:Mar  8 20:44:19 xi kernel: md: bind<sdb5>
> > 	messages.2:Mar  8 20:44:19 xi kernel: md: bind<sdb6>
> 
> This doesn't look like the output that would be generated if
> "mdadm -As" were used.
> in that case you would expect to see the two '5' devices together and the
> two '6' devices together.
> e.g
>    sda5
>    sdb5
>    sda6
>    sdb6
> 
> This looks more like the result of "mdadm -I" being called on various devices
> as udev discovers them and gives them to mdadm (it could be "mdadm
> --incremental" rather than "-I").
> 
> This suggests that there is some race somewhere that is causing either a6 or
> b6 to be missed, either by udev or by mdadm - probably mdadm.
> 
> I would suggest that you check if "mdadm -I" is being called by some
> udev rules.d files (/liub/udev/rules.d/*.rules or /etc/udev/rules.d/*.rules)
> 
> Then maybe try to enable some udev tracing to get a log of everything it
> does.  Then if this is something that you want to pursue, post to
>   linux-raid@vger.kernel.org
> with as many details as you can.

You're right about mdadm --incremental, of course.

Since I'm not able to reproduce it reliably (and adding udev tracing
could probably make it even harder to due to changed timings) and I'm
basically only cold booting on kernel updates these days, I think I'll
have to let this one be for now. At least now I know it's not hurting
my disks.

For reference, I'm using udev-151 and mdadm-3.1.4.

Thanks for you help,
Johan
