Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933469Ab1FBLW6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 07:22:58 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:54195 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752534Ab1FBLW4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 07:22:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=jrJlvPmxWiolMethV+O70J+Em6napFdIWzT76NjpRKFKSlb9czZpiwfI3bQc/3Y1m1
         hI/Gz/3Gif6qpEmN2GSpRdk2LxrjPmhmDRhS9bRJdbb/erSSwkdr8ICgau1582/r0Itd
         IdUOh4iA58v43HMFwaPF4eB+wspr6ns0RRI5Y=
MIME-Version: 1.0
In-Reply-To: <4DE7629D.80205@canonical.com>
References: <1307006553-12667-1-git-send-email-ike.pan@canonical.com>
	<1307006645-12702-1-git-send-email-ike.pan@canonical.com>
	<BANLkTik+-wMXcCgSb8cCWx6wxrT0JgAbpnbGqizCpk+3F6Wx_g@mail.gmail.com>
	<4DE7629D.80205@canonical.com>
Date: Thu, 2 Jun 2011 13:22:54 +0200
Message-ID: <BANLkTinEu20oGdX+9LwM7fswzgZaVkuf3yEfip-p9gTkUTzu5g@mail.gmail.com>
Subject: Re: [PATCH 2/3] ideapad: Add nodes in sysfs
From: Corentin Chary <corentin.chary@gmail.com>
To: Ike Panhc <ike.pan@canonical.com>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, Matthew Garrett <mjg@redhat.com>,
        Randy Dunlap <rdunlap@xenotime.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 2, 2011 at 12:14 PM, Ike Panhc <ike.pan@canonical.com> wrote:
> On 06/02/2011 05:48 PM, Corentin Chary wrote:
>> Hi Ike,
>> Why do you want to add /sys/devices/platform/ideapad/brightness and
>>     /sys/devices/platform/ideapad/backlight ?
>> Both of these files should be handled by the generic backlight class
>> (using brightness and bl_power).
>
> This is within VPC2004. In DSDT they are different device from generic
> backlight.
>
> and I try bl_power but can not turning off power of whole LCD. No idea
> how screensaver do it, looks like just cut off video signal.

What I wanted to say is that you should use the generic backlight
class (!=driver) to expose these. You can look at asus-wmi.c to see
how it's done.
Then users will be able to choose the backlight implementation using
acpi_backlight=vendor or acpi_backlight=video.

-- 
Corentin Chary
http://xf.iksaif.net
