Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756264Ab1D2B0G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 21:26:06 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47636 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753026Ab1D2B0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 21:26:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=r+tZG5fuDnU5FzECs3/8IK7Md3px9sWEc/cgjlYBQpVIrp44YwcD1xLe990ULFrGGw
         AmwvcEloGqSnPKTJH2yiQ5Js3Vu+i7yexm8HUpMmhI+Xvl7PCj7ISrETKUksM3IARcg9
         PSmSg/gHIuDxCrCVgBIh9WhyjyqP/BYtxVNVQ=
MIME-Version: 1.0
In-Reply-To: <201104290154.56145.rjw@sisk.pl>
References: <201104290154.12966.rjw@sisk.pl>
	<201104290154.56145.rjw@sisk.pl>
Date: Fri, 29 Apr 2011 10:26:01 +0900
Message-ID: <BANLkTinsKELoZAZgu0wzT_fQc1kWnd-EVg@mail.gmail.com>
Subject: Re: [linux-pm] [RFC][PATCH 1/2] PM / Runtime: Support for generic I/O
 power domains
From: MyungJoo Ham <myungjoo.ham@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        linux-sh@vger.kernel.org, Greg KH <gregkh@suse.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 29, 2011 at 8:54 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
>
> Introcude common headers, helper functions and callbacks allowing
> platforms to use simple generic power domains for runtime power
> management.
>
> Introduce struct generic_power_domain to be used for representing
> power domains that each contain a number of devices and may be
> master domains or subdomains with respect to other power domains.
> Among other things, this structure includes callbacks to be
> provided by platforms for performing specific tasks related to
> power management (i.e. ->stop_device() may disable a device's
> clocks, while ->start_device() may enable them, ->power_on() is
> supposed to remove power from the entire power domain
> and ->power_off() is supposed to restore it).
>
> Introduce functions that can be used as power domain runtime PM
> callbacks, pm_genpd_runtime_suspend() and pm_genpd_runtime_resume(),
> as well as helper functions for the initialization of a power
> domain represented by a struct generic_power_domain object,
> adding a device to or removing a device from it and adding or
> removing subdomains.
>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Hi!

The pm_domain is assuming that there is at most one powerdomain per
device, which is perfectly fine with my machines and the concept of
in-SoC powerdomains.

However, if so, wouldn't it be possible to simply set powerdomain by
setting a device's parent?
For example, for a device, struct device *dev, and a powerdomain,
struct device *pd, use
 "dev.parent = pd;", and let runtime-pm handle including the
"dev_power_governor" in the pm_domain's pm related code.


Cheers!

- MyungJoo

-- 
MyungJoo Ham, Ph.D.
Mobile Software Platform Lab,
Digital Media and Communications (DMC) Business
Samsung Electronics
cell: 82-10-6714-2858
