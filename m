Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934315Ab0J2WeD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 18:34:03 -0400
Received: from smtp12.ono.com ([62.42.230.20]:25909 "EHLO resmaa12.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932865Ab0J2Wd7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 18:33:59 -0400
Date: Sat, 30 Oct 2010 00:33:57 +0200
From: "J.A. =?ISO-8859-1?B?TWFnYWxs824=?=" <jamagallon@ono.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux CIFS <linux-cifs@vger.kernel.org>
Subject: Re: CIFS is slooow, gvfs is fast
Message-ID: <20101030003357.029b4e02@werewolf.home>
In-Reply-To: <4CC55894.5040509@suse.de>
References: <20101022013544.0fdab0e0@werewolf.home>
 <4CC16B1E.4060709@suse.de>
 <20101023004636.1acdd81c@werewolf.home>
 <20101024013038.057442c0@werewolf.home>
 <4CC55894.5040509@suse.de>
X-Mailer: Claws Mail 3.7.6cvs54 (GTK+ 2.22.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Oct 2010 15:44:44 +0530, Suresh Jayaraman <sjayaraman@suse.de> wrote:

> On 10/24/2010 05:00 AM, J.A. Magallón wrote:
> > On Sat, 23 Oct 2010 00:46:36 +0200, "J.A. Magall�n" <jamagallon@ono.com> wrote:
> > 
> >>
> >> If you mean hardware network path (cabling, router), yes.
> >> For file paths, CIFS fs is under /net/htpc/media, and gvfs uses a mount
> >> point on '~/.gvfs/media on htpc'.
> >>
> >> And here comes the weird part. To rule out the desktop environment factor,
> >> I tried a dd in both paths. On /net, I get 16.6 MB/s, and on
> >> ~/.gvfs/xxx, I just get 5.5 MB/s. I really don't understand anything...
> >> things get reversed depending if you use a gui or commandline.
> >>update
> >> Weird, really weird...
> >>
> > 
> > Well, to sort things out, I did some more tests (this does not mean things
> > get any closer to be clear for me at least...).
> > 
> > Can anybody tell me whats going here...??
> > It looks just like gui tools behave just in reverse of cli, and that a plain
> > smbclient is faster that cifs. I'm really confused...
> > 
> 
> Could you try mounting from commandline with something like
>   `mount -t cifs //server/share /mnt/point -o user=user1`
> (commenting out the fstab entry) and try copying the file?
> 
> 

Same results, cli copy takes about 7.5 seconds (thats around 40MB/s), and
gui copy says it runs at 7.8 MB/s.
This could be the normal behaviour I could expect, gui is slower as it has to
update progress bars, move flying sheets, or even does a sync from time to
time.

The misbehaviour I see is the other way aroung, FUSE/GVFS is fast from GUI
and slow from CLI. And, the best, why are there any difference ???

-- 
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
