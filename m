Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824Ab2DSLS0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 07:18:26 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:55835 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245Ab2DSLSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 07:18:25 -0400
MIME-Version: 1.0
In-Reply-To: <D854C92F57B1B347B57E531E78D05EAD10E4C0@BGSMSX102.gar.corp.intel.com>
References: <1334310292-22289-1-git-send-email-ramakrishna.pallala@intel.com>
	<20120419071104.GG18520@mwesterb-mobl.lan>
	<D854C92F57B1B347B57E531E78D05EAD10E4C0@BGSMSX102.gar.corp.intel.com>
Date: Thu, 19 Apr 2012 14:18:24 +0300
X-Google-Sender-Auth: IYyg4FdMOqG7JFchS66PJJLFe9w
Message-ID: <CALp=xyOJpP=cioeNN4YqOYeDEt3Lz-fviVffmR_7AD5jf2Zc+g@mail.gmail.com>
Subject: Re: [PATCH] smb347_charger: Cleanup power supply registration code in probe
From: Mika Westerberg <mika.westerberg@iki.fi>
To: "Pallala, Ramakrishna" <ramakrishna.pallala@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2012 at 2:10 PM, Pallala, Ramakrishna
<ramakrishna.pallala@intel.com> wrote:
>> Sent: Thursday, April 19, 2012 12:41 PM
>> To: Pallala, Ramakrishna
>> Cc: linux-kernel@vger.kernel.org; Anton Vorontsov; Anton Vorontsov
>> Subject: Re: [PATCH] smb347_charger: Cleanup power supply registration code in probe
>>
>> On Fri, Apr 13, 2012 at 03:14:52PM +0530, Ramakrishna Pallala wrote:
>> > This patch checks if the usb or mains charging is enabled by the
>> > platform before registering with the power supply class.
>>
>> Can you describe why this change is needed? The current code always registers all the
>> power-supplies but if we haven't enabled for example USB charging, then the online
>> property for USB ps is set to 0.
>
> If we haven't enabled USB charging then why to waste kernel resources?
> What we will gain by registering with power supply class if USB charging is not enabled?

For one we have a consistent interface to userspace regardless of how
the platform has configured the driver. For example if USB charging is
not enabled userspace can still see the 'smb347-usb' directory but
'online' attribute is always set to zero.
