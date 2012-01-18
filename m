Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962Ab2ARWTT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 17:19:19 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:65435 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753615Ab2ARWTR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 17:19:17 -0500
MIME-Version: 1.0
In-Reply-To: <20120118221255.5c14f382@pyramind.ukuu.org.uk>
References: <1326826563-32215-1-git-send-email-sjg@chromium.org>
	<1326826563-32215-3-git-send-email-sjg@chromium.org>
	<20120117201036.6d99f98f@pyramind.ukuu.org.uk>
	<20120118041720.GA2431@linux.vnet.ibm.com>
	<CAPnjgZ1GJatR15dVsq-+hAWhD7eaLhtN737QvBaor_=0+K+6wA@mail.gmail.com>
	<20120118221255.5c14f382@pyramind.ukuu.org.uk>
Date: Wed, 18 Jan 2012 14:19:16 -0800
X-Google-Sender-Auth: Y7y6TfM5k71zfV5KKtO-ijueBCg
Message-ID: <CAPnjgZ0pUC5wNwSZ0Tj77dNVENNpQgAguiihboK159-ZU9DH0g@mail.gmail.com>
Subject: Re: [PATCH 3/3] serial: 8250: Add a wakeup_capable module param
From: Simon Glass <sjg@chromium.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: paulmck@linux.vnet.ibm.com, LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-serial@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

On Wed, Jan 18, 2012 at 2:12 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> Let me provide a bit of context. The serial_core code seems to be the
>> only place in the kernel that does this:
>>
>>               device_init_wakeup(tty_dev, 1);
>>               device_set_wakeup_enable(tty_dev, 0);
>>
>> The first call makes the device wakeup capable and enables wakeup, The
>> second call disabled wakeup.
>
>> I assume we can't and shouldn't change device_init_wakeup() . We could
>> add a call like device_init_wakeup_disabled() which makes the device
>> wakeup capable but does not actually enable it. Does that work?
>
> Is that not
>
>        device_init_wakeup(tty_dev, 0)
>
> or am I missing something ?

Bearing in mind that I know very little about this, I think
serial_core wants to have the device wakeup capable in any case, but
not actually enable wakeup on the device until requested. It seems
that drivers rely on that behaviour too.

device_init_wakeup(tty_dev, 0) calls device_set_wakeup_capable(dev,
false) which I think is not what we want.

Regards,
Simon
