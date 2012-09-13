Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974Ab2IMDBd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 23:01:33 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:61180 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021Ab2IMDBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 23:01:30 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CAErSpo6RbLF1KTs8sHyJCu2NX7u4BRwFp0NQCtaXSiq-bUEThg@mail.gmail.com>
References: <CA+icZUUj1u6YwpkzXOsUVJ4p5t-qrCWVDoaFoDbAbMT2EbEwWw@mail.gmail.com>
	<CA+icZUXh1Vh=ojJKd34Cnm+sO+U1OqrcSk=5-EwXd22oB5Jw9Q@mail.gmail.com>
	<CA+icZUVSWBLrRu_vOcGurp=x-Bb1dBv1Tfdf8P8LiPNM1SuR8Q@mail.gmail.com>
	<CAErSpo6RbLF1KTs8sHyJCu2NX7u4BRwFp0NQCtaXSiq-bUEThg@mail.gmail.com>
Date: Thu, 13 Sep 2012 05:01:29 +0200
Message-ID: <CA+icZUWK2C_r33EjRG_WOx8Y=n6nzyVP_QJkr-EUzdHNT3u4=g@mail.gmail.com>
Subject: Re: linux-next: Tree for Sept 11 (drm related: boot problems on amd64)
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Dave Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2012 at 9:52 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Tue, Sep 11, 2012 at 4:04 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>> On Tue, Sep 11, 2012 at 8:29 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>>> On Tue, Sep 11, 2012 at 8:12 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>>>> On Tue, Sep 11, 2012 at 8:31 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>>>>> Hi all,
>>>>>
>>>>> Changes since 201209010:
>>>>>
>>>>> New tree: ixp4xx
>>>>>
>>>>> The pci tree gained a build failure so I used the version from
>>>>> next-20120910.
>>>>>
>>>>> The regulator tree lost its build failure.
>>>>>
>>>>> The staging tree lost its build failure.
>>>>>
>>>>> The akpm tree lost a few patches that turned up elsewhere.
>>>>>
>>>>> ----------------------------------------------------------------------------
>>>>>
>>>>
>>>> Hi,
>>>>
>>>> today's and yesterday's Linux-Next is broken for me again.
>>>> I tried with systemd and upstart on Ubuntu/precise, with nomodeset and
>>>> rescue boot-option.
>>>>
>>>> With rescue boot-option I see this in my logs (Intel sandy-bridge
>>>> ultrabook here):
>>>>
>>>> Sep 11 18:43:36 fambox kernel: [    9.654972] [drm:drm_pci_agp_init]
>>>> *ERROR* Cannot initialize the agpgart module.
>>>> Sep 11 18:43:36 fambox kernel: [    9.654980] DRM: Fill_in_dev failed.
>>>>
>>>> I have not checked any MLs... coming from hospital right now.
>>>>
>>>
>>> More ERRORs:
>>>
>>> # grep -A1 "ERROR" /var/log/kern.log
>>> Sep 10 17:51:29 fambox kernel: [   10.205818]
>>> [drm:i915_get_bridge_dev] *ERROR* bridge device not found
>>> Sep 10 17:51:29 fambox kernel: [   10.206055] i915: probe of
>>> 0000:00:02.0 failed with error -5
>>> --
>>> Sep 10 15:53:00 fambox kernel: [   10.500387]
>>> [drm:i915_get_bridge_dev] *ERROR* bridge device not found
>>> Sep 10 15:53:00 fambox kernel: [   10.500602] i915: probe of
>>> 0000:00:02.0 failed with error -5
>>> --
>>> Sep 11 20:41:01 fambox kernel: [    9.636010]
>>> [drm:i915_get_bridge_dev] *ERROR* bridge device not found
>>> Sep 11 20:41:01 fambox kernel: [    9.636202] i915: probe of
>>> 0000:00:02.0 failed with error -5
>>> --
>>> Sep 11 18:42:18 fambox kernel: [   10.132229]
>>> [drm:i915_get_bridge_dev] *ERROR* bridge device not found
>>> Sep 11 18:42:18 fambox kernel: [   10.132433] i915: probe of
>>> 0000:00:02.0 failed with error -5
>>> --
>>> Sep 11 18:43:36 fambox kernel: [    9.654972] [drm:drm_pci_agp_init]
>>> *ERROR* Cannot initialize the agpgart module.
>>> Sep 11 18:43:36 fambox kernel: [    9.654980] DRM: Fill_in_dev failed.
>>> --
>>> Sep 11 19:52:10 fambox kernel: [    9.545562]
>>> [drm:i915_get_bridge_dev] *ERROR* bridge device not found
>>> Sep 11 19:52:10 fambox kernel: [    9.545798] i915: probe of
>>> 0000:00:02.0 failed with error -5
>>> --
>>> Sep 11 20:04:09 fambox kernel: [    9.798233]
>>> [drm:i915_get_bridge_dev] *ERROR* bridge device not found
>>> Sep 11 20:04:09 fambox kernel: [    9.798557] i915: probe of
>>> 0000:00:02.0 failed with error -5
>>>
>>
>> [ CC Bjorn (pci maintainer) ]
>>
>> I pulled in pci.git#next up to commit
>> 9c33332178e6ba49fe48c468edc08ad94b53e1b1 ("Merge branch
>> 'pci/gavin-window-alignment' into next") on top of next-20120911.
>> This lets my machine boot, but freezes somewhere else.
>
> We had a PCI bug in an earlier version of this patch:
> http://git.kernel.org/?p=linux/kernel/git/helgaas/pci.git;a=commitdiff;h=b9443f401bb20ae6414e3e68bca0413bad28b689
> that caused lspci to fail.
>

I retested with next-20120912 and my machine boots, so no more
drm-related errors causing boot-failures.

> I suspect this also caused the issue you saw.  We've since fixed it,
> but let me know if you see a PCI-related issue again.
>

Immediately after pressing any single key at X-login (Ubuntu/precise
IIRC uses lightdm + unity-greeter), my machine produces a
kernel-panic.
I have taken a photo and will send a separate email on this.
Can't say ATM what is the root-cause for it.
But that is what I have seen after my merging of the "clean"
pci.git/next into yesterday's "nine-eleven" release.

Further questions (not issue related):

While doing a simple grepping for new "pcie-cap" patterns (a list at
[1]) came with commit 8c0d3a02c1309eb6112d2e7c8172e8ceb26ecfca ("PCI:
Add accessors for PCI Express Capability") on drivers/gpu/
directory...more simplifications possible (I had only a quick view)?

- Sedat -

[1] http://git.kernel.org/?p=linux/kernel/git/helgaas/pci.git;a=commitdiff;h=8c0d3a02c1309eb6112d2e7c8172e8ceb26ecfca#patch2

> Bjorn
