Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756756Ab0IUO4C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 10:56:02 -0400
Received: from cantor.suse.de ([195.135.220.2]:59009 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755527Ab0IUOz7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 10:55:59 -0400
Date: Tue, 21 Sep 2010 16:55:58 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Heinz Diehl <htd@fritha.org>
Cc: Phil Turmel <philip@turmel.org>, Mat <jackdachef@gmail.com>,
        Guillaume Chazarain <guichaz@gmail.com>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oliver@neukum.org>, Alan Ott <alan@signal11.us>,
        linux-usb@vger.kernel.org, linux-input@vger.kernel.org,
        Andreas Bombe <aeb@debian.org>, Alex Riesen <raa.lkml@gmail.com>,
        Gabriel C <nix.or.die@googlemail.com>
Subject: Re: [BUG, Regression, bisected] USB mouse causes bug on 1st insert,
 ignored on 2nd insert, lsusb stuck at usbdev_open
In-Reply-To: <20100921144814.GA6484@fritha.org>
Message-ID: <alpine.LNX.2.00.1009211655190.26813@pobox.suse.cz>
References: <4C96B9DB.8030403@turmel.org> <AANLkTi=1zh4hD-1uzpgjAsnKZBE=qi_ZAX-ug=2XMkW0@mail.gmail.com> <alpine.LNX.2.00.1009201440140.26813@pobox.suse.cz> <4C975F79.9060609@turmel.org> <alpine.LNX.2.00.1009201524340.26813@pobox.suse.cz>
 <AANLkTim6PBGEBz8_PVpK2YajgtejsbAgL11i+DMN-7jh@mail.gmail.com> <alpine.LNX.2.00.1009201708340.26813@pobox.suse.cz> <4C979C79.9090901@turmel.org> <alpine.LNX.2.00.1009211156520.26813@pobox.suse.cz> <alpine.LNX.2.00.1009211556200.26813@pobox.suse.cz>
 <20100921144814.GA6484@fritha.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Sep 2010, Heinz Diehl wrote:

> > > I have just found out that it's actually CONFIG_USB_DYNAMIC_MINORS which 
> > > makes the difference. When unset, the problem doesn't trigger, and 
> > > usb_find_interface() always returns the proper interface. When 
> > > CONFIG_USB_DYNAMIC_MINORS is being used, the oops happen.
> 
> I don't have it set in my .config:
> 
> liesel:/usr/src/linux-2.6.36-rc4-git5 # cat .config | grep DYNAMIC_MINORS
> CONFIG_SND_DYNAMIC_MINORS=y
> # CONFIG_USB_DYNAMIC_MINORS is not set
> 
> > Could you guys please verify whether the patch below fixes the issues you 
> > were seeing and puts everything back into shape again? Thanks.
> 
> Your patch applies cleanly to 2.6.36-rc4-git5, however, it doesn't fix the
> problem for me. 
> 
> My .config is attached.

OK, so that is likely something completely different (and you even don't 
have NULL pointer dereference).

Let's not hijack this thread for this different problem of yours, and 
let's continue in the original one.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
