Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755669Ab0ELODM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 10:03:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42178 "EHLO mx2.suse.de"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751923Ab0ELODL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 10:03:11 -0400
Date: Wed, 12 May 2010 16:03:07 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
       mdpoole@troilus.org
Subject: Re: [PATCH] HID:magicmouse: This fixes a connection problem with
 the magicmouse.
In-Reply-To: <4BEAB3AF.6020909@gmail.com>
Message-ID: <alpine.LNX.2.00.1005121602240.28092@pobox.suse.cz>
References: <1273595363-4020-1-git-send-email-justinmattock@gmail.com> <alpine.LNX.2.00.1005121456150.28092@pobox.suse.cz> <4BEAAF9C.909@gmail.com> <alpine.LNX.2.00.1005121540340.28092@pobox.suse.cz> <4BEAB3AF.6020909@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 May 2010, Justin P. Mattock wrote:

> > > > > --- a/drivers/hid/hid-magicmouse.c
> > > > > +++ b/drivers/hid/hid-magicmouse.c
> > > > > @@ -354,7 +354,7 @@ static int magicmouse_probe(struct hid_device
> > > > > *hdev,
> > > > >    		goto err_free;
> > > > >    	}
> > > > > 
> > > > > -	ret = hid_hw_start(hdev, HID_CONNECT_DEFAULT&
> > > > > ~HID_CONNECT_HIDINPUT);
> > > > > +	ret = hid_hw_start(hdev, HID_CONNECT_DEFAULT);
> > > > > 
> > > > >          
> > > > This is not particularly right, as we'll end up having dangling 
> > > > input device.
> > > > 
> > > > The problem is, that when HIDRAW is not set, hid_hw_start() 
> > > > returns ENODEV as no subsystem has claimed the device, and probe 
> > > > routine bails out. Which is not what we want.
> > > > 
> > > > Does the testing patch below fix the problems you are seeing?
> > > >        
> > > works good.. rebooted a few times mouse connects. suspended a few times
> > > mouse reconnects.
> > >      
> > I'd be glad if you could also double-check that device removal and
> > re-connecting it works well as well with this patch.
> > 
> with  test I did different techniques,
> 1) regular suspend(leave device on)
> 2)suspend then shut off device
> 3)shut off device then suspend
> all of these techniques work properly

Thanks for reporting and testing, I have queued the patch.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
