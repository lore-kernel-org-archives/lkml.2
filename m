Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755136Ab2HRLBx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 07:01:53 -0400
Received: from www17.your-server.de ([213.133.104.17]:43030 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754936Ab2HRLBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 07:01:50 -0400
Message-ID: <1345287638.19305.4.camel@localhost.localdomain>
Subject: Re: [UDL] general protection fault in fb_deferred_io_mkwrite()
From: Thomas Meyer <thomas@m3y3r.de>
To: Bernie Thompson <bernie@plugable.com>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        airlied@linux.ie, dri-devel@lists.freedesktop.org
Date: Sat, 18 Aug 2012 13:00:38 +0200
In-Reply-To: <CAO1w=s8AdkbSNMe8v0HqkosYNKp05+Udk4d-r1TbRb3GMC-MNw@mail.gmail.com>
References: <1344767672.1272.7.camel@localhost.localdomain>
	 <CAO1w=s8AdkbSNMe8v0HqkosYNKp05+Udk4d-r1TbRb3GMC-MNw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3 (3.4.3-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, den 12.08.2012, 14:22 -0700 schrieb Bernie Thompson:
> On Sun, Aug 12, 2012 at 3:34 AM, Thomas Meyer <thomas@m3y3r.de> wrote:
>         guilty driver is probably udl_fb.c
>         any ideas?
> 
> 
> Hi Thomas,

Hi Bernie!


> We were seeing similar issues in udlfb (the original fbdev version of
> this driver), which were fixed earlier this year by getting all
> rendering operations out of probe/disconnect -- those which might
> trigger fb_defio page faults in an inappropriate context, or be
> long-running. Here's some more detail:
> http://plugable.com/2012/06/21/displaylink-usb-devices-on-linux-kernel-3-4-0/comment-page-1/#comment-5896 
> 
> 
> Unfortunately, I haven't had time to get going with udl myself, so
> haven't been able to port and confirm.  Thanks for raising and staying
> on this.

Okay, I see. I'll switch to FB_UDL for now and remove DRM_UDL from my
config.

Is somebody working on porting commit
https://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commitdiff;h=8d21547d3c9c3bc653261f26d554cfabc4a083de to the DRM_UDL driver?

In Airlie's tree seems to be no commit related to this:

http://cgit.freedesktop.org/~airlied/linux/

with kind regards
thomas

> 
> 
> Best wishes,
> Bernie 
> 
> 
>         [   45.633336] RIP  [<ffffffff8123becc>]
>         fb_deferred_io_mkwrite+0xdc/0xf0
>         [   45.633336]  RSP <ffff880126559c98>
>         [   45.711547] ---[ end trace d4732d5a0bf375fb ]---
>         [   45.720961] released /dev/fb1 user=1 count=0
>         
> 



