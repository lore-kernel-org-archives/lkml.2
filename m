Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932609Ab2DKQZ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 12:25:28 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:47876 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932471Ab2DKQZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 12:25:26 -0400
Date: Wed, 11 Apr 2012 09:25:19 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: =?utf-8?B?5p6X5b2l5L2R?= <tom_lin@emc.com.tw>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        djkurtz@chromium.org, Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH v3] Input: Elan HID-I2C device driver
Message-ID: <20120411162519.GA27562@core.coreip.homeip.net>
References: <1334061766-20577-1-git-send-email-tom_lin@emc.com.tw>
 <20120411071212.GB6894@core.coreip.homeip.net>
 <4F85583F.6050008@emc.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4F85583F.6050008@emc.com.tw>
X-KMail-SignatureActionEnabled: false
X-KMail-EncryptActionEnabled: false
X-KMail-CryptoMessageFormat: 15
X-KMail-Identity: 579597780
X-KMail-Transport: 2086860242
X-KMail-Fcc: 11
X-KMail-Drafts: 19
X-KMail-Templates: 38
X-KMail-Link-Message: 603189
X-KMail-Link-Type: reply
User-Agent: KMail/4.8.1 (Linux/3.3.1-3.fc16.x86_64; KDE/4.8.1; x86_64; ; )
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, April 11, 2012 06:09:03 PM 林彥佑 wrote:
> Hi Daniel
> 
> On 04/11/2012 03:12 PM, Dmitry Torokhov wrote:
> > Hi Tom,
> > 
> > On Tue, Apr 10, 2012 at 08:42:46PM +0800, Tom Lin wrote:
> >> This patch adds driver for Elan I2C touchpad. These protocol of HID-I2C
> >> was
> >> defined by Microsoft. The kernel driver would use the multi-touch
> >> protocol
> >> format B.
> > 
> > If this device truly supports HID protocol shouldn't we define i2c-hid
> > transport, similar to usbhid?
> 
> I merely follow defined by Microsoft.
> It was called "HID OVER I2C" by Microsoft.
> (http://msdn.microsoft.com/en-us/library/windows/hardware/hh825917(v=vs.85).
> aspx) But I agree to change from hid i2c to i2chid.
> Do you have any better opinions?

I am not sure we are talking about same thing... I do not really care
whether it is named "hid i2c" or "i2chid". What I meant if the device
really speaks HID protocol, except that the transport is not USB or
bluetooth but I2C, then instead of writing a custom driver for this
particular part we need to add a new HID transport into
drivers/hid/i2c-hid that is similar to drivers/hid/usbhid/ and reuse the
rest of HID framework along with hid- multitouch.c which handles
HID-compliant multitouch devices.

I am CCing Jiri (HID maintainer) for additional input.

Thanks.

-- 
Dmitry
