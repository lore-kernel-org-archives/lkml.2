Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762329Ab2FHSDB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 14:03:01 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:61162 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394Ab2FHSC7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 14:02:59 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo5DHQv0wuipPWGd5nwzui1C3-ucWCuppe0Zpww55u4pxQ@mail.gmail.com>
References: <1339142492-13625-1-git-send-email-xudong.hao@intel.com>
	<CAErSpo5DHQv0wuipPWGd5nwzui1C3-ucWCuppe0Zpww55u4pxQ@mail.gmail.com>
Date: Fri, 8 Jun 2012 12:02:55 -0600
Message-ID: <CAL-B5D2o55Xf6E4scGu9ibbQx=9_CJD7qLsBxhUnyVSw6kEYhA@mail.gmail.com>
Subject: Re: [PATCH 0/4] PCI: Enable LTR/OBFF before device is used by driver
From: Myron Stowe <myron.stowe@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Xudong Hao <xudong.hao@intel.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org, avi@redhat.com,
        alex.williamson@redhat.com, ddutile@redhat.com, myron.stowe@redhat.com,
        xiantao.zhang@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 8, 2012 at 11:31 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Fri, Jun 8, 2012 at 1:01 AM, Xudong Hao <xudong.hao@intel.com> wrote:
>> The series of patches enable LTR and OBFF before device is used by driver, and
>> introduce a couple of functions to save/restore LTR latency value.
>>
>> Patch 1/4 introduce new function pci_obff_supported() as pci_ltr_support().
>>
>> Patch 2/4 enable LTR(Latency tolerance reporting) before device is used by
>> driver.
>>
>> Patch 3/4 enable OBFF(optimized buffer flush/fill) before device is used by
>> driver.
>>
>> Patch 4/4 introduce a couple of functions pci_save_ltr_value() and
>> pci_restore_ltr_value() to save and restore LTR latency value, while device is
>> reset.
>
> We need some justification for these patches.  Why do we want them?
> Do they improve performance?  Reduce power consumption?  How have they
> been tested?  How can we be confident that these features work
> correctly on hardware in the field?  Should or could the BIOS enable
> them itself, based on OEM testing and desire to support these
> features?

I too am a little nervous about these changes due to Jesse's earlier response
(see http://marc.info/?l=linux-pci&m=133372610102933&w=2) where he indicated:
  "Given how device specific these extensions are, I'd expect you'd need
   to know about each specific device anyway, which is why I think the
   control belongs in the driver."

Having these features enabled by default may be too aggressive.  Not saying it
is not correct - something you may be able to inform us about, especially since
you are with Intel - just make me nervous without further information.

Myron

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
