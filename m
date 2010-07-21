Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758883Ab0GUSsg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 14:48:36 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37858
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756708Ab0GUSse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 14:48:34 -0400
Date: Wed, 21 Jul 2010 11:48:51 -0700 (PDT)
Message-Id: <20100721.114851.200597269.davem@davemloft.net>
To: gregory.v.rose@intel.com
Cc: leedom@chelsio.com, shemminger@vyatta.com, andy@greyhouse.net,
        harald@redhat.com, bhutchings@solarflare.com, sassmann@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org, gospo@redhat.com,
        alexander.h.duyck@intel.com
Subject: Re: [PATCH net-next] sysfs: add entry to indicate network
 interfaces with random MAC address
From: David Miller <davem@davemloft.net>
In-Reply-To: <43F901BD926A4E43B106BF17856F0755F184620A@orsmsx508.amr.corp.intel.com>
References: <20100721.103249.107094774.davem@davemloft.net>
	<201007211129.48288.leedom@chelsio.com>
	<43F901BD926A4E43B106BF17856F0755F184620A@orsmsx508.amr.corp.intel.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Rose, Gregory V" <gregory.v.rose@intel.com>
Date: Wed, 21 Jul 2010 11:43:19 -0700

> Intel's view of things is that we don't use persistent MAC addresses
> in our VFs because the MAC address belongs to the VM and when it
> migrates it's going to want to use another VF with the same MAC
> address.  If they're persistent I'm wondering how that can be done.
> 
> This discussion has come about because some folks want to use the VF
> in the Host VMM.  The original design goal for Intel was that VFs
> would be assigned to VMs and that VMM vendors would want to assign
> MAC addresses with their own assigned OUI's.

If the VM itself is the "physical entity" of the system, the logical
conclusion I come to is that some kind of key should be obtained
through the VM to uniquely give the device a persistent MAC.

You could do things like have the PF controller use the root filesystem
ID label to construct the VF's MAC address, or something like that.
