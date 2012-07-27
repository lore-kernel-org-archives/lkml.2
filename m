Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751604Ab2G0Gk7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 02:40:59 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:63547 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049Ab2G0Gk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 02:40:57 -0400
MIME-Version: 1.0
X-Originating-IP: [115.42.131.38]
In-Reply-To: <20120727061430.GC11608@xanatos>
References: <1343361824-11417-1-git-send-email-daniel@quora.org>
	<20120727061430.GC11608@xanatos>
Date: Fri, 27 Jul 2012 14:40:56 +0800
Message-ID: <CAMVG2sv1vDe-jmS+U-6QCLX67S57zxkAk-jYiFX59jcOEEGfPA@mail.gmail.com>
Subject: Re: [PATCH] Add Etron XHCI quirk to avoid warning spam
From: Daniel J Blueman <daniel@quora.org>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 July 2012 14:14, Sarah Sharp <sarah.a.sharp@linux.intel.com> wrote:
> On Fri, Jul 27, 2012 at 12:03:44PM +0800, Daniel J Blueman wrote:
>> When various USB3 devices with Etron XHCI controllers, we see a bunch of
>> warnings:
>> xhci_hcd 0000:02:00.0: WARN Successful completion on short TX: needs
>> XHCI_TRUST_TX_LENGTH quirk?
>>
>> Acknowledge the issue by adding the quirk.
>>
>> Signed-off-by: Daniel J Blueman <daniel@quora.org>
[]
> I already have a patch in my queue for this.  However, it keys off the
> PCI_DEVICE_ID_ASROCK_P67 PCI device ID.  Do you have another Etron
> device with a different device ID that needs this quirk?

Yes, the subsystem ID is different [1] (but Zotac program it the same
as the vendor and device IDs here), however what you say suggests the
problem is general to this Etron XHCI controller (1b6f:7023), as we'd
suspect anyway.

Thus the more general patch I posted makes better sense perhaps?

Thanks,
  Daniel

--- [1]

# lspci -vs 02:00.0
02:00.0 USB controller: Etron Technology, Inc. EJ168 USB 3.0 Host
Controller (rev 01) (prog-if 30 [XHCI])
	Subsystem: Etron Technology, Inc. EJ168 USB 3.0 Host Controller
[]
# lspci -vns 02:00.0
02:00.0 0c03: 1b6f:7023 (rev 01) (prog-if 30 [XHCI])
	Subsystem: 1b6f:7023
-- 
Daniel J Blueman
