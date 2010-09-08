Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878Ab0IHREg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 13:04:36 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39453 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718Ab0IHREc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 13:04:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ksj9SljmpwT0B02uMASl39sMriXeSi+EllzHsLqdUD0mGB3Fa21z4PfU2aWW18Neyf
         +Y1aN+ZKiHARPH88qd2SeJYkaLpZV8Z9JY8EdTwbRFqywR/bq38yB5rho4mq51hxs3Mc
         3kQ48ER9VSoZL1DDGMMHtbuLPjOIQ9/7g+DY4=
MIME-Version: 1.0
In-Reply-To: <20100908170320.GA4888@srcf.ucam.org>
References: <1283963539-4039-1-git-send-email-mjg@redhat.com>
	<1283963539-4039-3-git-send-email-mjg@redhat.com>
	<AANLkTi=kDXwRPxfbLv=EGEqARfTkhuhRBrXUL9DOQ_zw@mail.gmail.com>
	<20100908170320.GA4888@srcf.ucam.org>
Date: Wed, 8 Sep 2010 13:04:31 -0400
Message-ID: <AANLkTinmUDmsS7bJOzfv3TayeTOOLzT_POQQ+BmksSgS@mail.gmail.com>
Subject: Re: [PATCH] radeon: Expose backlight class device for legacy LVDS encoder
From: Alex Deucher <alexdeucher@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-kernel@vger.kernel.org,
        =?ISO-8859-1?Q?Michel_D=E4nzer?= <michel@daenzer.net>,
        dri-devel@lists.freedesktop.org,
        =?ISO-8859-1?Q?Michel_D=E4nzer?= <daenzer@vmware.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 8, 2010 at 1:03 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Wed, Sep 08, 2010 at 12:58:32PM -0400, Alex Deucher wrote:
>
>> The only problem with this is that not all oems use the internal
>> backlight controller; systems that don't need to use the acpi methods.
>
> That's why we expose the backlight type. Userspace should use the acpi
> or platform mechanism when available, with this being a last-ditch
> fallback.

Ah, gotcha.

>
>>  On atombios systems there is a bit in the
>> ATOM_FIRMWARE_CAPABILITY_ACCESS struct in the FirmwareInfo data table
>> to determine whether the backlight is controlled by the GPU or some
>> external mechanism.  Combios may have something similar.  If the
>> backlight is controlled via the GPU, it can be adjusting using the
>> atom OutputControl and TransmitterControl control tables depending on
>> the GPU family.  However, if the driver chooses to control the
>> backlight itself, it needs to set the appropriate bit in the bios
>> scratch regs to tell the firmware not to attempt to change the
>> backlight itself.
>
> If there's support for probing this more reliably then I'm all for that,
> but I'm not keen on taking over control if the BIOS has previous
> asserted it.

Agreed.

Alex
