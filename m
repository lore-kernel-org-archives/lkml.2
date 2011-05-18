Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846Ab1ERHVw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 03:21:52 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:53126 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767Ab1ERHVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 03:21:51 -0400
X-IronPort-AV: E=Sophos;i="4.65,230,1304294400"; 
   d="scan'208";a="5813561"
Subject: Re: [PATCH V3] xen/balloon: Memory hotplug support for Xen balloon
 driver
From: Ian Campbell <Ian.Campbell@eu.citrix.com>
To: "v.tolstov@selfip.ru" <v.tolstov@selfip.ru>
CC: Daniel Kiper <dkiper@net-space.pl>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "andi.kleen@intel.com" <andi.kleen@intel.com>,
        "haicheng.li@linux.intel.com" <haicheng.li@linux.intel.com>,
        "fengguang.wu@intel.com" <fengguang.wu@intel.com>,
        "jeremy@goop.org" <jeremy@goop.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "Dan Magenheimer" <dan.magenheimer@oracle.com>,
        "pasik@iki.fi" <pasik@iki.fi>,
        "dave@linux.vnet.ibm.com" <dave@linux.vnet.ibm.com>,
        "wdauchy@gmail.com" <wdauchy@gmail.com>,
        "rientjes@google.com" <rientjes@google.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
In-Reply-To: <1305701868.28175.1.camel@vase>
References: <20110517214421.GD30232@router-fw-old.local.net-space.pl>
	 <1305701868.28175.1.camel@vase>
Content-Type: text/plain; charset="ISO-8859-1"
Organization: Citrix Systems, Inc.
Date: Wed, 18 May 2011 08:21:49 +0100
Message-ID: <1305703309.7738.23.camel@dagon.hellion.org.uk>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-18 at 07:57 +0100, Vasiliy G Tolstov wrote:
> On Tue, 2011-05-17 at 23:44 +0200, Daniel Kiper wrote:
> > +	  Memory could be hotplugged in following steps:
> > +
> > +	    1) dom0: xl mem-max <domU> <maxmem>
> > +	       where <maxmem> is >= requested memory size,
> > +
> > +	    2) dom0: xl mem-set <domU> <memory>
> > +	       where <memory> is requested memory size; alternatively memory
> > +	       could be added by writing proper value to
> > +	       /sys/devices/system/xen_memory/xen_memory0/target or
> > +	       /sys/devices/system/xen_memory/xen_memory0/target_kb on dumU,
> > +
> > +	    3) domU: for i in /sys/devices/system/memory/memory*/state; do \
> > +	               [ "`cat "$i"`" = offline ] && echo online > "$i"; done
> > +

> Very good. Is that possible to eliminate step 3 ? And do it automatic if
> domU runs with specific xen balloon param?

When we faced the same question WRT VCPU hotplug we ended up using a
udev rule. Presumably the same could be done here. In the VCPU case the
rule is:

ACTION=="add", SUBSYSTEM=="cpu", RUN+="/bin/sh -c '[ ! -e /sys$devpath/online ] || echo 1 > /sys$devpath/online'"

Presumably the memory one will be broadly similar.

Ian.

