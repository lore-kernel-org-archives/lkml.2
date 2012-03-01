Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932236Ab2CATTL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 14:19:11 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:47667 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964801Ab2CATTI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 14:19:08 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of yhlu.kernel@gmail.com designates 10.100.244.26 as permitted sender) smtp.mail=yhlu.kernel@gmail.com; dkim=pass header.i=yhlu.kernel@gmail.com
MIME-Version: 1.0
In-Reply-To: <20120301190323.GA5155@xanatos>
References: <1330622227-4209-1-git-send-email-yinghai@kernel.org>
	<20120301172435.GA8505@kroah.com>
	<20120301190323.GA5155@xanatos>
Date: Thu, 1 Mar 2012 11:19:06 -0800
X-Google-Sender-Auth: mU3S5D8gobIGFz73J9mP8xgnwUA
Message-ID: <CAE9FiQXPi2VY+cVOxaQr=MBy_m3Dr0BKG6DRTCP1TrbuDcMCfg@mail.gmail.com>
Subject: Re: [RFC PATCH] usb, PCI: split quirk for usb host controller to three
From: Yinghai Lu <yinghai@kernel.org>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, linux-usb@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 1, 2012 at 11:03 AM, Sarah Sharp
<sarah.a.sharp@linux.intel.com> wrote:
> On Thu, Mar 01, 2012 at 09:24:35AM -0800, Greg Kroah-Hartman wrote:
>> On Thu, Mar 01, 2012 at 09:17:07AM -0800, Yinghai Lu wrote:
>> > so we avoid checking class again and again in that quirk.
>> >
>> > need to be applied after pci/linux-next and usb/usb-next
>>
>> As those are two independant trees, this needs to wait until after
>> 3.4-rc1 is out.
>>
>> > Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>> >
>> > ---
>> >  drivers/usb/host/pci-quirks.c |   42 ++++++++++++++++++++++++++++--------------
>> >  1 file changed, 28 insertions(+), 14 deletions(-)
>>
>> Is this really helping anything here?  You added code overall :(
>
> I agree with Greg.  Why change this?  Does it shave off any boot time?
> Please show hard numbers for what improvements this makes.  I really
> don't want to change PCI init and break people's systems.

but your code make pci init change to call disable/enable for non-xhci
for fixing xhci problem.

| commit cab928ee1f221c9cc48d6615070fefe2e444384a
| Author: Sarah Sharp <sarah.a.sharp@linux.intel.com>
| Date:   Tue Feb 7 15:11:46 2012 -0800
|
|    USB: Fix handoff when BIOS disables host PCI device.

Yinghai
