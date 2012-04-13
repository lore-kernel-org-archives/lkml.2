Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756313Ab2DMTNw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 15:13:52 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41946 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755065Ab2DMTNu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 15:13:50 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mikko Vinni <mmvinni@yahoo.com>
Subject: Re: [linux-pm] "i8042: Can't reactivate AUX port" after s2ram on 3.4-rc2
Date: Fri, 13 Apr 2012 21:18:21 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc2+; KDE/4.6.0; x86_64; ; )
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Allen Kay <allen.m.kay@intel.com>,
        Jean Guyader <jean.guyader@eu.citrix.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org
References: <1334310754.17013.YahooMailNeo@web161804.mail.bf1.yahoo.com>
In-Reply-To: <1334310754.17013.YahooMailNeo@web161804.mail.bf1.yahoo.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201204132118.22074.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, April 13, 2012, Mikko Vinni wrote:
> Bug report:
>     https://bugzilla.kernel.org/show_bug.cgi?id=43099
> 
> Briefly:
> 
> After s2ram the touchpad on a HP dv5 laptop doesn't work anymore.
> 
> dmesg contains this about the touchpad
> Apr 11 18:00:05 koni kernel: i8042: Can't write CTR while closing AUX port
> Apr 11 18:00:08 koni kernel: i8042: Can't reactivate AUX port
> 
> 
> Full log in bugzilla with PCI and i8042 debug turned on.
> 
> Bisected to:
> 
> commit 26f41062f28de65e11d3cf353e52d0be73442be1
> Author: Kay, Allen M <allen.m.kay@intel.com>
> Date:   Thu Jan 26 10:25:53 2012 -0800
> 
>     PCI: check for pci bar restore completion and retry
>     
>     On some OEM systems, pci_restore_state() is called while FLR has not yet
>     completed.  As a result, PCI BAR register restore is not successful.  This fix
>     reads back the restored value and compares it with saved value and re-tries 10
>     times before giving up.

Does reverting the above commit on top of the current Linus' tree fix the
problem for you?

Rafael
