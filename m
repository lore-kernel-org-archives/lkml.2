Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752594Ab0IMPCe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 11:02:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52090 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751836Ab0IMPCd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 11:02:33 -0400
Date: Mon, 13 Sep 2010 17:02:32 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: anil joshi <anilsjoshi123@gmail.com>
Cc: Jiri Slaby <jslaby@suse.cz>, arnd@arndb.de,
        =?ISO-8859-15?Q?Peter_J=FAno=A8?= <petoju@gmail.com>,
        linux-input@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        markus@trippelsdorf.de
Subject: Re: HIDDEV: potential NULL dereference
In-Reply-To: <AANLkTik0hZzwKU6QokgA5B7GzWtTDQWxhfog902ZS9XZ@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1009131701590.26813@pobox.suse.cz>
References: <4C82419C.3050903@suse.cz> <AANLkTikyW6q3tufYwwX4QEAkV0JGCWcvGr4EJyNGJOpk@mail.gmail.com> <AANLkTik0hZzwKU6QokgA5B7GzWtTDQWxhfog902ZS9XZ@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Sep 2010, anil joshi wrote:

> 
> 
> On Thu, Sep 9, 2010 at 7:59 PM, anil joshi <anilsjoshi123@gmail.com> wrote:
>        hid->dev.parent is "usb_interfae"  pointer is kfree  in  usb_release_interfece 
> hid_to_usb_dev(dev) accessing hid->dev.parent 
> 
> I have tested this,while removing  hid device  
> 
> usb_release_interfece is belonging to khubd  process 
> 
> I get many use full information  from  Jiri Kosina, Markus Trippelsdorf, regarding this issue
> from http://kerneltrap.org/mailarchive/linux-kernel/2010/8/12/4606155/thread#mid-4606155
> 
> To avoid  NULL deference problem 
> 
> hiddev->exist is zero before usb_deregister_dev  call in  hiddev_disconnected  function there fore
> we could use
> static long hiddev_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
> {
> 
> 
>      if (hiddev->exist) {
>          hid_to_usb_dev(dev);
>        } else {
>             return -EIO
>    }
> 
> 
> Thanks to Markus Trippelsdorf , Jiri Kosina 

Hi Anil,

could you please send a proper patch (diff against current kernel) and a 
short changelog entry with the explanation, so that I could easily 
understand what you are proposing?

Thanks!

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
