Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758661Ab0GHWH3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 18:07:29 -0400
Received: from exprod6og115.obsmtp.com ([64.18.1.35]:35343 "HELO
	exprod6og115.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755983Ab0GHWH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 18:07:28 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Subject: RE: nic enumeration
Date: Thu, 8 Jul 2010 18:07:24 -0400
Message-ID: <D3F292ADF945FB49B35E96C94C2061B90C317F5F@nsmail.netscout.com>
In-Reply-To: <AANLkTilLL-NwIISVg8XmwlWDarzzixiYaVNj8hPnc1kn@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: nic enumeration
Thread-Index: Acse5HJkaTf/he5oTpSCNzgReQlGAgAAgRog
References: <AANLkTimvsaoOm_QEUnvlZf2EKuiMpOr9PdQt_Ga0Z97D@mail.gmail.com> <20100708012120.GB11419@auslistsprd01.us.dell.com> <D3F292ADF945FB49B35E96C94C2061B90C317EA2@nsmail.netscout.com> <AANLkTikazGZZ6dDLpGQaRH7j-_M7hzinxmAP0TD84G2n@mail.gmail.com> <AANLkTilLL-NwIISVg8XmwlWDarzzixiYaVNj8hPnc1kn@mail.gmail.com>
From: "Loke, Chetan" <Chetan.Loke@netscout.com>
To: "Kay Sievers" <kay.sievers@vrfy.org>, "Andrew Fong" <ayf@youtube.com>
Cc: "Matt Domsch" <Matt_Domsch@dell.com>,
       "Michael Di Domenico" <mdidomenico4@gmail.com>,
       <linux-net@vger.kernel.org>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 08 Jul 2010 22:07:25.0506 (UTC) FILETIME=[F282C220:01CB1EE9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o68M7YV6031949

> -----Original Message-----
> From: Kay Sievers [mailto:kay.sievers@vrfy.org]
> Sent: July 08, 2010 5:28 PM
> To: Andrew Fong
> Cc: Loke, Chetan; Matt Domsch; Michael Di Domenico; linux-
> net@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: nic enumeration
> 
> On Thu, Jul 8, 2010 at 22:47, Andrew Fong <ayf@youtube.com> wrote:
> > On Thu, Jul 8, 2010 at 1:36 PM, Loke, Chetan
> <Chetan.Loke@netscout.com> wrote:
> >>> -----Original Message-----
> >>> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> >>> owner@vger.kernel.org] On Behalf Of Matt Domsch
> >>> Sent: July 07, 2010 9:21 PM
> >>>
> >>> http://lwn.net/Articles/356900/
> >>>
> >>> And on a system where you can use udev rules, the
> >>> 70-persistent-net.rules file can be used to make them constant, by
> >>> using the MAC address to force the names to be what you want.
> >>
> >> Ok, but can we achieve the renaming w/o a reboot?
> >
> > You probably can restart the udev subsystem.
> 


> No, udev has not really a concept of being restarted, it will not do
> anything. You can only synthesize events, so it looks like the device
> is just plugged in. For that, you need to make sure the interface is
> not busy, otherwise renaming will fail in interesting ways, especially
> if names need to be swapped between several devices.
> 

I'm not a udev guru so I don't know how will renaming a simple net_device->name work?
What about the msi-x queues created by the driver? May be I missed it but I don't see a single driver tearing apart everything and restarting unless a NETDEV_RENAME somehow automagically reloads the driver. I know it's silly for the driver to tear apart the whole world. But then why allow renaming in the first place, correct?


> Live renaming of interfaces is something you really need to know what
> you are doing, especially on remote machines.
> 

I agree, I wanted someone to say 'try the symlink attrib'. I really need to create a 'symlink' or a reference to the newly added 'ethX' interface. I have to support 75+ VMs(each w/ 5+ vNICs) and I can't [re]name the newly added vNIC and then reboot. Rebooting 75+ VMs is non-practical. Adding a new vNIC is as simple as point-and-click and the guest sees the new vNIC. The VM doesn't need to reboot.

How do I achieve this 'symlinking' effect minus the reboot?

> Kay

Regards
Chetan Loke
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
