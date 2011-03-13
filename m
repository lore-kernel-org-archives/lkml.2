Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755526Ab1CMLWr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 07:22:47 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40104 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755041Ab1CMLWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 07:22:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:reply-to:user-agent:mime-version:to:cc
         :subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        b=hksodlkJU177NKitW7D6eFpvvWdGnSnR+igIPb4Dq97Lcx2JCztVdcFFvjYLnbl/K0
         YK6U+FI4Bg/Eoj2Gmm30X5lzfCVKj5DeVheXSpZ8lDco8gbyftAn3iVAq4a8xREFzTO4
         gglJRexhMfrLTFgymTgK7EVtM+yI3XhzvjwqA=
Message-ID: <4D7CA900.2070302@linaro.org>
Date: Sun, 13 Mar 2011 11:22:40 +0000
From: Andy Green <andy@warmcat.com>
Reply-To: andy.green@linaro.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110302 Fedora/3.1.8-3.fc16 Thunderbird/3.1.8
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, patches@linaro.org
Subject: Re: [RFC PATCH 1/4] PLATFORM: introduce structure to bind async platform
 data to a dev path name
References: <20110312222633.27020.19543.stgit@otae.warmcat.com> <20110312223212.27020.9839.stgit@otae.warmcat.com> <201103130029.38458.rjw@sisk.pl> <4D7C0423.9020204@linaro.org> <20110313010329.GB20396@kroah.com>
In-Reply-To: <20110313010329.GB20396@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13/2011 01:03 AM, Somebody in the thread at some point said:

>>> Using device paths for this purpose seems to be very fragile to me.  Isn't
>>> there any better solution?
>>
>> Given that this targets board definition files which commonly do the
>> platform_add_device for the USB bus controller synchronously, and
>> the bus-connected devices it is aimed at are soldered on to the
>> board connected to specific bus controllers, the bus paths are
>> completely deterministic.
>
> No they are not.
>
> The physical layout is deterministic, but the bus number, and device
> number, is not.  You are using the bus number here in this path, so that
> is not going to work, sorry.

Okay.  This is not a PC we are talking about.

If the platform / board definition file is registering the USB hosts 
synchronously at boot time, the driver is composed into the monolithic 
kernel, there are no PCI busses or whatever on the SoC, the bus indexing 
is totally deterministic.  This is extremely common in the platform / 
SoC case and is the case the patchset is targeted at.  Even further, the 
only time you'd use it is to reach a USB asset that is wired up the same 
board permanently as well.

Anyway this seems moot by now.

-Andy
