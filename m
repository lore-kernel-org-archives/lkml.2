Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756873Ab2HFWJS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 18:09:18 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40068 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756660Ab2HFWJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 18:09:11 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Yann Cantin <yann.cantin@laposte.net>, linux-input@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC ebeam PATCH v3 0/2]
Date: Mon, 06 Aug 2012 15:09:01 -0700
Message-ID: <1743577.8bRY3CPqxH@dtor-d630.eng.vmware.com>
User-Agent: KMail/4.8.4 (Linux/3.5.0-2.fc17.x86_64; KDE/4.8.4; x86_64; ; )
In-Reply-To: <20120806214423.GC30355@kroah.com>
References: <1344288104-20731-1-git-send-email-yann.cantin@laposte.net> <20120806214423.GC30355@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, August 06, 2012 02:44:23 PM Greg KH wrote:
> On Mon, Aug 06, 2012 at 11:21:42PM +0200, Yann Cantin wrote:
> > Hi,
> > 
> > New USB input driver for eBeam devices.
> > 
> > Currently, only the Luidia eBeam classic projection model is supported.
> > Edge model and a NEC interactive video-projector support planned for the
> > end of the mounth.
> > 
> > Patch 1 to blacklist the device for hid generic-usb.
> > 
> > Patch 2 is the actual driver.
> > 
> > Changes from previous :
> > - switch to div64_s64 for portable 64/64-bits divisions

Do you really need this much precision? It will be slower on 32 bits..

> > - some cosmetics in device name
> > - unused include and def removed
> > - variables name changes for readability
> > 
> > Pending issues :
> > 
> > - sysfs custom files : need to pass 13 parameters for calibration :
> >   choice is between lots of simply-handled, or few with a big sscanf.
> 
> sysfs is "one value per file", so use lots of different files please.

This is kind of a "one value" though - it is a transformation matrix.
Maybe switch it to binary - 9 s32?

-- 
Dmitry
