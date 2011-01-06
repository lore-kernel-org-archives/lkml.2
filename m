Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019Ab1AFBAE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 20:00:04 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:40221 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753945Ab1AFBAA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 20:00:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=tuJCBBldQ9+v4XXMwoCYOBjjIVrl1WxLWydxN/01DfKEsNz0x2sQvMZ//0VeTZrC48
         wtOUPaSPvsaeAKpzE/5l0jPVB+noBvBRTa2rtaHnJD1U58+YwdMmVzcy4dcx4qBCUCyd
         B4/5ObZcH/BKhQjihtp34wJLnIGrtjhvHouX4=
MIME-Version: 1.0
In-Reply-To: <20110106003003.GA3337@suse.de>
References: <4D250B2B.8090901@gmail.com>
	<20110106003003.GA3337@suse.de>
Date: Wed, 5 Jan 2011 18:59:59 -0600
Message-ID: <AANLkTi=a=ARbmr6e9KvuNdtLWkQyfecrQOPeTHze5=Xf@mail.gmail.com>
Subject: Re: Sleeping function called from invalid context in 2.6.37 xhci_hcd
From: Robert Hancock <hancockrwd@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Linux-usb <linux-usb@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 5, 2011 at 6:30 PM, Greg KH <gregkh@suse.de> wrote:
> On Wed, Jan 05, 2011 at 06:22:03PM -0600, Robert Hancock wrote:
>> Just saw this on booting up on the latest Fedora Rawhide kernel
>> based on 2.6.37. Looks like we were trying to do a runtime suspend
>> on the xHCI USB controller and it disabled MSI-X while interrupts
>> were disabled?
>
> Known issue, patches came in too late to make it for .37, hopefully will
> show up in .38-rc and then get backported to .37.  They are on the
> linux-usb mailing list if you need them now.

Not sure if it's related to this issue or not, but I also noticed the
USB 3.0 card wasn't detecting any connected devices until I disabled
USB autosuspend on the controller through sysfs (which is enabled by
default in that Fedora Rawhide kernel)..
