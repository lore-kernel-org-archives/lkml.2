Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755226Ab1BHRLU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 12:11:20 -0500
Received: from mail-yi0-f46.google.com ([209.85.218.46]:63687 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755205Ab1BHRLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 12:11:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=p6He5R1jjcBbm2PftbsjT6o+ySxszdpUXkTbrb7K6AIQlk4jtw+kX1Ob+BQiL4zvw8
         4rlbKjUhOMplcm2vYaDOO2dZbLgM/WDuEN7zi+laS0+FPY2Losom0qj9AWKtPZn4N8sM
         W3QL1a1F/s82YAoEiIf5UckeCwpK6P89GU5tI=
Date: Tue, 8 Feb 2011 09:11:05 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Corentin Chary <corentin.chary@gmail.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, platform-driver-x86@vger.kernel.org,
        linux acpi <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: What's part of the ABI (breaking eeepc-wmi)
Message-ID: <20110208171104.GC4476@core.coreip.homeip.net>
References: <AANLkTim5kG-pZRpj+6ckOvuk5ZSJ_O7zbwBnC4JNQPtS@mail.gmail.com>
 <20110208145301.GA12930@srcf.ucam.org>
 <AANLkTin5_jqEc3hxh02n7PU5C0BGXah=n_Bj9cN1Yar1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTin5_jqEc3hxh02n7PU5C0BGXah=n_Bj9cN1Yar1@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 08, 2011 at 03:17:35PM +0000, Corentin Chary wrote:
> On Tue, Feb 8, 2011 at 2:53 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> > On Tue, Feb 08, 2011 at 08:51:27AM +0000, Corentin Chary wrote:
> >
> >> A first solution is to rename eeepc-wmi asus-wmi, and create an alias
> >> to make eeepc-wmi work. Then this driver would handle asus-wmi and
> >> eeepc-wmi platform drivers (it could also be splitted in 3
> >> files/modules, common/notebook/eeepc).
> >> But then, is it important to keep these strings ?
> >> - hotplug string ("eeepc-wifi")
> >> - rfkill names ("eeepc-xxxxx")
> >> - input strings (.phys and .name)
> >
> > I think that, realistically, these changes should be fine but may break
> > some user code. We don't have a good way of enforcing proper sysfs
> > usage.
> 
> Unfortunatly, it would break udev (well.. only the touchpad key, which
> probably never worked, does it really matters ?) ...
> 
> http://git.kernel.org/?p=linux/hotplug/udev.git;a=blobdiff;f=extras/keymap/95-keymap.rules;h=9059a8c41e4505f0d8088a90fc0c3a64fe8d5f2d;hp=053838d803d7142dd80fbca361ef65565c6189f2;hb=0d8b6be5f5238360d2d8e220d6da280f842c5358;hpb=e99cc72398d1d5057cc6d1e4c065799f8daaf29e
> 
> But your probably right for rfkill and hotplug slot name.
> 

As we can't be sure about individual user's set ups (they might very
well use their own rules and maps) we should try to keep the existign
setups intact, if at all possible.

Thanks.

-- 
Dmitry
