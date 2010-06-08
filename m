Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756663Ab0FHVgU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 17:36:20 -0400
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:34010 "HELO
	cpoproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755330Ab0FHVgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 17:36:18 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=hWVxPUzA/W2dgdyH1kphGLQ1GW8ZCzDGtAhcj90AIk7qQK8SgfZcReoTutW1qbgkYgc8NUMVu6DsWTtgJBYvz7M7H3Fq1YDypkJSOn+psFYSi2aOLThP0NvQwxp6k3vH;
Date: Tue, 8 Jun 2010 14:35:14 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Frank Pan <frankpzh@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Yu Zhao <yu.zhao@intel.com>, Chris Wright <chrisw@sous-sol.org>,
       Mitch Williams <mitch.a.williams@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "David S. Miller" <davem@davemloft.net>,
       Matt Carlson <mcarlson@broadcom.com>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Add a helper function in PCI IOV to get VF device
Message-ID: <20100608143514.740f8095@virtuousgeek.org>
In-Reply-To: <AANLkTimTm57fvumRXo9pegOY2M78mduBsClwYlmAOzpo@mail.gmail.com>
References: <AANLkTimTm57fvumRXo9pegOY2M78mduBsClwYlmAOzpo@mail.gmail.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Jun 2010 13:05:25 +0800
Frank Pan <frankpzh@gmail.com> wrote:

> Greetings,
> 
> The motivation is make VF device visible to PF driver. PF driver
> may need this to access VF's PCI configuration.
> Another use case is in sysfs symbolic linking. Some of VF's sysfs
> entries are created by PF driver. For example, /sys/class/net/ethx/vfx
> in Intel 82576 NIC driver. Makeing a symbolic link from VF's pci device
> to this path also must be done in PF's driver.
> 
> Currently, there is no hint about VF's bus/devfn in PF's pci_dev.
> The offset and stride entries(which are used to calculate bus/devfn
> of VF devices) in VF's PCI configuration is also invisible in PF's
> driver. So IMO this helper function is needed.
> 
> Any reply is appreciated, THX.
> 
> (ps: gmail will do line wrap/tab replace, use attachment instead to patch)

Per the discussion in this thread it sounds like this really has
nothing to do with sysfs and more to do with being a convenient API for
drivers.

Is that correct?  If so, and assuming there's not some other way of
getting this info from a driver, I'm ok with it, but it should be
submitted as part of a patchset including driver code that uses it.

-- 
Jesse Barnes, Intel Open Source Technology Center
