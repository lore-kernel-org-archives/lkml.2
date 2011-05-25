Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933002Ab1EYI21 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 04:28:27 -0400
Received: from smtp.nokia.com ([147.243.128.26]:21949 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757382Ab1EYI2Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 04:28:24 -0400
Date: Wed, 25 May 2011 11:27:44 +0300
From: Ville Tervo <ville.tervo@nokia.com>
To: ext Ed Tomlinson <edt@aei.ca>
Cc: Milan Oravec <moravec@ukf.sk>, linux-kernel@vger.kernel.org,
        Hui Zhu <teawater@gmail.com>, Dave Young <hidave.darkstar@gmail.com>,
        Bluettooth Linux <linux-bluetooth@vger.kernel.org>,
        "Gustavo F. Padovan" <padovan@profusion.mobi>
Subject: Re: Linux 2.6.39
Message-ID: <20110525082744.GP2480@null>
References: <BANLkTikB37AvEgh1MAFBbYvFaxsL6W11OQ@mail.gmail.com>
 <loom.20110521T194736-595@post.gmane.org>
 <201105211631.00804.edt@aei.ca>
 <201105231808.37369.edt@aei.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201105231808.37369.edt@aei.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 23, 2011 at 06:08:36PM -0400, ext Ed Tomlinson wrote:
> On Saturday 21 May 2011 16:31:00 Ed Tomlinson wrote:
> > On Saturday 21 May 2011 13:56:20 Milan Oravec wrote:
> > > Hi Linus, I'm sorry bothering you, but my usb-bluetooth dongle stop working in
> > > 2.6.39 kernel series. 
> > > I know it is nothing ground breaking but it is bug. 
> > > I'm using this hardware from 2.6.11 kernel series. 
> > > Details are included in this thread:
> > > 
> > > https://lkml.org/lkml/2011/4/18/481
> > > 
> > > I hope I'm doing nothing false writing this email. 
> > 
> > Same device, same problem here.
> > 
> > You are not alone
> 
> I had some time this afternood so I tried bisecting without much luck.  I ended up somewhere rc1 ish with a system
> that would paniced during boot.  Here is the bisect log incase it helps:
> 
> # bad: [61c4f2c81c61f73549928dfd9f3e8f26aa36a8cf] Linux 2.6.39
> # good: [521cb40b0c44418a4fd36dc633f575813d59a43d] Linux 2.6.38
> git bisect start 'v2.6.39' 'v2.6.38' '--' 'drivers/bluetooth'
> # bad: [7a6362800cb7d1d618a697a650c7aaed3eb39320] Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next-2.6
> git bisect bad 7a6362800cb7d1d618a697a650c7aaed3eb39320
> # bad: [0a0e9ae1bd788bc19adc4d4ae08c98b233697402] Merge branch 'master' of master.kernel.org:/pub/scm/linux/kernel/git/davem/net-2.6
> git bisect bad 0a0e9ae1bd788bc19adc4d4ae08c98b233697402
> # skip: [03c2d0e89409b59c1ec9d9511533cedc0b7aaa69] Bluetooth: Use usb_fill_int_urb()
> git bisect skip 03c2d0e89409b59c1ec9d9511533cedc0b7aaa69
> # skip: [7f4b2b04c88377af30c022f36c060190182850fb] Bluetooth: Make hci a child of the corresponding tty device.
> git bisect skip 7f4b2b04c88377af30c022f36c060190182850fb
> # skip: [84f0e17f78471857104a20dfc57711409f68d7bf] Bluetooth: ath3k: Avoid duplication of code
> git bisect skip 84f0e17f78471857104a20dfc57711409f68d7bf
> 
> Ring any bells for anyone?
> 
> Probably should open a regression bug for this too....

I think this is regression with d5859e22cd40b73164b3e5d8d5d796f96edcc6af
commit. Probably the code tries to enable something that is not supported.

Could you pastebin hcidump while doing hciconfig hci0 up? 

-- 
Ville

