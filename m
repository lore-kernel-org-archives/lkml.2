Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752700Ab0JVWqk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 18:46:40 -0400
Received: from smtp13.ono.com ([62.42.230.16]:43293 "EHLO resmaa13.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751718Ab0JVWqj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 18:46:39 -0400
Date: Sat, 23 Oct 2010 00:46:36 +0200
From: "J.A. =?ISO-8859-1?B?TWFnYWxs824=?=" <jamagallon@ono.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>, linux-cifs@vger.kernel.org
Subject: Re: CIFS is slooow, gvfs is fast
Message-ID: <20101023004636.1acdd81c@werewolf.home>
In-Reply-To: <4CC16B1E.4060709@suse.de>
References: <20101022013544.0fdab0e0@werewolf.home>
 <4CC16B1E.4060709@suse.de>
X-Mailer: Claws Mail 3.7.6cvs54 (GTK+ 2.22.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Oct 2010 16:14:46 +0530, Suresh Jayaraman <sjayaraman@suse.de> wrote:

> (Cc linux-cifs@vger.kernel.org)
> 
> On 10/22/2010 05:05 AM, J.A. Magallón wrote:
> 
> > I have a very strange behaviour with windows networking.
> > I have an HTPC, which I access from my Linux desktop. It runs Windows 7.
> > Network is GigaBit, routed by a Linksys WRT320N running latest DD-WRT.
> > I setup an automount path under /net/htpc with CIFS filesystem.
> > I can also access the drives in HTPC via gvfs from Gnome DE.
> > 
> > Problem: speed is _VERY_ different.
> > R/W through the automount point (CIFS fs), is roughly 7-8 MB/s (ridiculous
> > for gigabit speeds).
> > R/W through Gnome/gvfs (kind of fuse) goes around 35 - 40 MB/s (400 Mbits/s),
> > that look much better.
> 
> What is the kernel version In which you are seeing the problem? I'm not

Its just new 2.6.36 final, mandriva distro kernel.

> seeing this on 2.6.36-rc4. Do you have a wired interface as well? Are

Yes, boxes are all wired to the 320N router, at gigabit speeds.
Just to double check, I also probed with my netbook with 100Mb ehternet.
The effect is less obvious, but writing to the Win7 box through the
cifs automount path goes at 3.5-4.0 Mb/s, and with gvfs it reaches
7.5 Mb/s.

> you sure that both are using the same network path?
> 

If you mean hardware network path (cabling, router), yes.
For file paths, CIFS fs is under /net/htpc/media, and gvfs uses a mount
point on '~/.gvfs/media on htpc'.

And here comes the weird part. To rule out the desktop environment factor,
I tried a dd in both paths. On /net, I get 16.6 MB/s, and on
~/.gvfs/xxx, I just get 5.5 MB/s. I really don't understand anything...
things get reversed depending if you use a gui or commandline.

Weird, really weird...

-- 
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
