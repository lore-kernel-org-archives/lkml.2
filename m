Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158Ab2G3Iwt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 04:52:49 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:62728 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462Ab2G3Iwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 04:52:47 -0400
MIME-Version: 1.0
X-Originating-IP: [115.42.131.38]
In-Reply-To: <20120727171011.GF11608@xanatos>
References: <1343361824-11417-1-git-send-email-daniel@quora.org>
	<20120727061430.GC11608@xanatos>
	<CAMVG2sv1vDe-jmS+U-6QCLX67S57zxkAk-jYiFX59jcOEEGfPA@mail.gmail.com>
	<20120727171011.GF11608@xanatos>
Date: Mon, 30 Jul 2012 16:52:46 +0800
Message-ID: <CAMVG2suG2Bde72EzWBE59fWC=VdkZjdXDftbbC_fRmbxJoujYg@mail.gmail.com>
Subject: Re: [PATCH] Add Etron XHCI quirk to avoid warning spam
From: Daniel J Blueman <daniel@quora.org>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28 July 2012 01:10, Sarah Sharp <sarah.a.sharp@linux.intel.com> wrote:
> On Fri, Jul 27, 2012 at 02:40:56PM +0800, Daniel J Blueman wrote:
>> On 27 July 2012 14:14, Sarah Sharp <sarah.a.sharp@linux.intel.com> wrote:
>> > On Fri, Jul 27, 2012 at 12:03:44PM +0800, Daniel J Blueman wrote:
>> >> When various USB3 devices with Etron XHCI controllers, we see a bunch of
>> >> warnings:
>> >> xhci_hcd 0000:02:00.0: WARN Successful completion on short TX: needs
>> >> XHCI_TRUST_TX_LENGTH quirk?
>> >>
>> >> Acknowledge the issue by adding the quirk.
>> >>
>> >> Signed-off-by: Daniel J Blueman <daniel@quora.org>
>> []
>> > I already have a patch in my queue for this.  However, it keys off the
>> > PCI_DEVICE_ID_ASROCK_P67 PCI device ID.  Do you have another Etron
>> > device with a different device ID that needs this quirk?
>>
>> Yes, the subsystem ID is different [1] (but Zotac program it the same
>> as the vendor and device IDs here), however what you say suggests the
>> problem is general to this Etron XHCI controller (1b6f:7023), as we'd
>> suspect anyway.
>>
>> Thus the more general patch I posted makes better sense perhaps?
>
> I'd really like to keep this quirk specific to the particular PCI vendor
> and device ID.  It's possible that their next chip version will have the
> opposite issue (short TX completion code and bad untransferred length).
>
> Your patch turned it on for all Etron hosts, so I would rather keep my
> version:
>
> http://git.kernel.org/?p=linux/kernel/git/sarah/xhci.git;a=commit;h=12751f75720391bb2b607acdb2537f02e313251e
[]

Ok, the patch is correct since PCI_DEVICE_ID_ASROCK_P67 evaluates to
0x7023, which is the Etron EJ168 device ID.

Board-specific IDs (as the definition name suggests) are used for the
subsystem IDs, so this name is misleading (and misled me at least).

Can you fix this up with a patch to change PCI_DEVICE_ID_ASROCK_P67 to
PCI_DEVICE_ID_ETRON_EJ168, else I can cook and test a patch?

Thanks,
  Daniel
-- 
Daniel J Blueman
