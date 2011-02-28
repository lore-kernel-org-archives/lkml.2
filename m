Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313Ab1B1WEy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 17:04:54 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53809 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752420Ab1B1WEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 17:04:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=X+DQPO2o+wDMXLdF7oiSJilAkAInFI+6rNTanqBuYaKOeCP/2lSb73H4FYoRf2lBom
         NNZNfLQMkXfLESeKhitxGD2+JfnBEn63mIYk5oHZj9R0pPtdxSNCmq2CjRWmR/vtq2GO
         A1wbTl1qLm1TLNAQLes9ywX3W5ComGLTFuq8E=
Date: Tue, 1 Mar 2011 00:04:47 +0200
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.38-rc6: SysRq broken?
Message-ID: <20110228220447.GB18538@p183.telecom.by>
References: <20110228214054.GA18538@p183.telecom.by>
 <201102281357.21747.dmitry.torokhov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201102281357.21747.dmitry.torokhov@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 28, 2011 at 01:57:21PM -0800, Dmitry Torokhov wrote:
> On Monday, February 28, 2011 01:40:54 pm Alexey Dobriyan wrote:
> > It just strikes me that SysRq is broken here:
> > Alt+SysRq+h doesn't print anything
> > 
> > CONFIG_MAGIC_SYSRQ=y
> > CONFIG_INPUT_EVDEV=y
> > kernel.sysrq=1
> > echo h >/proc/sysrq-trigger works
> > 
> > Keyboard is USB one, "Logitech HID compliant keyboard".
> 
> What does /proc/bus/input/devices show?

I: Bus=0019 Vendor=0000 Product=0001 Version=0000
N: Name="Power Button"
P: Phys=PNP0C0C/button/input0
S: Sysfs=/devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
U: Uniq=
H: Handlers=kbd event0 
B: PROP=0
B: EV=3
B: KEY=10000000000000 0

I: Bus=0019 Vendor=0000 Product=0001 Version=0000
N: Name="Power Button"
P: Phys=LNXPWRBN/button/input0
S: Sysfs=/devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
U: Uniq=
H: Handlers=kbd event1 
B: PROP=0
B: EV=3
B: KEY=10000000000000 0

I: Bus=0003 Vendor=093a Product=2510 Version=0111
N: Name="PIXART USB OPTICAL MOUSE"
P: Phys=usb-0000:00:1d.0-1.1/input0
S: Sysfs=/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.1/2-1.1:1.0/input/input2
U: Uniq=
H: Handlers=mouse0 event2 
B: PROP=0
B: EV=17
B: KEY=70000 0 0 0 0
B: REL=103
B: MSC=10

I: Bus=0003 Vendor=046d Product=c30e Version=0110
N: Name="Logitech HID compliant keyboard"
P: Phys=usb-0000:00:1d.0-1.2/input0
S: Sysfs=/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.2/2-1.2:1.0/input/input3
U: Uniq=
H: Handlers=sysrq kbd event3 
B: PROP=0
B: EV=120013
B: KEY=1000000000007 ff800000000007ff febeffdff3cfffff fffffffffffffffe
B: MSC=10
B: LED=7

I: Bus=0003 Vendor=046d Product=c30e Version=0110
N: Name="Logitech HID compliant keyboard"
P: Phys=usb-0000:00:1d.0-1.2/input1
S: Sysfs=/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.2/2-1.2:1.1/input/input4
U: Uniq=
H: Handlers=kbd event4 
B: PROP=0
B: EV=13
B: KEY=fff ffffffffffffffff 2000000 387ad800d001 1e000000000000 0
B: MSC=10

