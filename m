Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759967Ab2EDU4E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 16:56:04 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:54072 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760006Ab2EDUzs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 16:55:48 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [RFC v2 2/5] PM, Add sysfs file power_off to control device power off policy
Date: Fri, 4 May 2012 23:00:33 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: Huang Ying <ying.huang@intel.com>, ming.m.lin@intel.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Zheng Yan <zheng.z.yan@intel.com>, Lan Tianyu <tianyu.lan@intel.com>
References: <1336119221-21146-1-git-send-email-ying.huang@intel.com> <1336119221-21146-3-git-send-email-ying.huang@intel.com> <CAErSpo7yRWCWKrd93AJ3b1VZW-_gWeJgru4cfHN7cp3wFmW96w@mail.gmail.com>
In-Reply-To: <CAErSpo7yRWCWKrd93AJ3b1VZW-_gWeJgru4cfHN7cp3wFmW96w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205042300.33976.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, May 04, 2012, Bjorn Helgaas wrote:
> On Fri, May 4, 2012 at 2:13 AM, Huang Ying <ying.huang@intel.com> wrote:
> > From: Lan Tianyu <tianyu.lan@intel.com>
> >
> > Some devices can be powered off to save more power via some platform
> > mechanism, e.g., ACPI.  But that may not work as expected for some
> > device or platform.  So, this patch adds a sysfs file named power_off
> > under <device>/power directory to provide a mechanism for user to control
> > whether to allow the device to be power off.
> >
> > power_off => "enabled" means allowing the device to be powered off if
> > possible.
> >
> > power_off => "disabled" means the device must be power on anytime.
> >
> > Also add flag power_off_user to struct dev_pm_info to record users'
> > choice. The bus layer can use this field to determine whether to
> > power off the device.
> 
> My first thought was that writing to "power_off" would actually turn
> the power off, which isn't true.  Maybe something like
> "poweroff_allowed" would work.
> 
> I think there's only one use of this new field, in
> pci_pm_runtime_suspend().  Maybe you could pull out that hunk from
> patch 5, combine it with this one, and move it to after patch 5?

Well, please see my comment.

First, it doesn't make sense to export a sysfs file to control a feature that
the given device doesn't have.

Second, if such a file is exported _at_ _this_ _level_, the sysfs setting
should affect every situation in which power may be removed from devices, not
just the PCIe D3cold damned thing.

If this is going to be PCIe-specific, the flag should go into struct pci_dev,
and the sysfs file accordingly.

Thanks,
Rafael
