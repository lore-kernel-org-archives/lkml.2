Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933514Ab0HNI5z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Aug 2010 04:57:55 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:50063 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932985Ab0HNI5y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Aug 2010 04:57:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=CvaxVMepKjYN43Z0Y6sNQohE1e77Xsuk0tbV4GS8uUazvGsDjye+SCWtvOIDIxVwsP
         JJO0VEEOMqfiiP7TooPzMlIqUeNBNeF0MffVF3Xn00oXmUiFdeSbHUQhMNj2Sy4gFdmn
         hjYFlEBAP0h8enseTv0KgBDxTiNSfQ4EhsNNA=
MIME-Version: 1.0
In-Reply-To: <87r5i1h9lh.fsf@erwin.mina86.com>
References: <1281691874-8154-1-git-send-email-dries.vanpuymbroeck@dekimo.com>
	<AANLkTikk7T6v8zwzEQuZ7yDgf6AcdEfNJr7BG+z1O02n@mail.gmail.com>
	<87sk2i45es.fsf@erwin.mina86.com>
	<AANLkTin_o36qmavka+aJaDOBpNRGc=xxKdPdtWWUcVG8@mail.gmail.com>
	<87r5i1h9lh.fsf@erwin.mina86.com>
Date: Sat, 14 Aug 2010 16:57:53 +0800
Message-ID: <AANLkTi=5+SEZ-=UCv8Oisgq==pyJpsgJ3tFKc0CdyXLw@mail.gmail.com>
Subject: Re: [PATCH] USB: Gadget: g_multi: added INF file for gadget with
 multiple configurations
From: Xiaofan Chen <xiaofanc@gmail.com>
To: Michal Nazarewicz <mina86@mina86.com>
Cc: Dries Van Puymbroeck <dries.van.puymbroeck@gmail.com>,
        linux-usb@vger.kernel.org, Greg KH <greg@kroah.com>,
        =?ISO-8859-2?Q?Micha=B3_Nazarewicz?= <m.nazarewicz@samsung.com>,
        Dries Van Puymbroeck <dries.vanpuymbroeck@dekimo.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 14, 2010 at 4:39 PM, Michal Nazarewicz <mina86@mina86.com> wrote:
> <http://msdn.microsoft.com/en-us/library/ff537109(v=VS.85).aspx>
> specifies that for a device to be identified as composite it (among
> other things) "must have a single configuration".  The page has also
> a passage which seems to indicate that the INF is needed:
>
>" If you want the generic parent driver to manage your device, but your
> device does not have the characteristics necessary to ensure that the
> system will generate a compatible ID of USB\COMPOSITE, you will have
> to provide an INF file that loads the generic parent driver."
>
> Selecting of the configuration is also mentioned as a requirement, and
> the next paragraph points to a web page you've cited:
>
>" If your composite device has multiple configurations, the INF file you
> provide must specify which configuration the generic parent should use
> in the registry. The necessary registry keys are described in
> Selecting the Configuration for a Composite USB Device."

Thanks. Now it is clear. The patch is correct after all.

Somehow I forgot the following blog entry again. This blog entry
seems to be more clear than the MSDN entries.
http://blogs.msdn.com/b/usbcoreblog/archive/2010/05/19/multi-config-usb-devices-and-windows.aspx

+++++++++++++++++
The USBCCGP composite device driver has support for multiple device
configurations, with a few caveats.
http://msdn.microsoft.com/en-us/library/ff539242(VS.85).aspx

   1. USBCCGP will not load on a multi-config device by default because
the hub driver doesn't create a "USB\COMPOSITE" PNP ID for a composite
device if it has multiple configurations. However, you can write your own INF
that matches a device-specific PNP ID to get USBCCGP to load as your
device's function driver.

   2. To select a configuration other than index 0, you must set registry
settings as specified in "Selecting the Configuration for a Composite
USB Device".
http://msdn.microsoft.com/en-us/library/ff538059(VS.85).aspx

During enumeration, USBCCGP will first attempt to select the
configuration whose descriptor is found at the specified "original" index. If
the attempt fails, normally due to the configuration requiring more than
100mA while the device's upstream hub has only bus power, then
USBCCGP attempts to select the configuration found at the specified
"alternate" index instead.

   3. Drivers that are clients of USBCCGP cannot change the device's
configuration value.
+++++++++++++++++



-- 
Xiaofan
