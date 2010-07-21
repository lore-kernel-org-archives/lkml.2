Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758833Ab0GUTCV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 15:02:21 -0400
Received: from mga01.intel.com ([192.55.52.88]:12936 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752774Ab0GUTCT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 15:02:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,239,1278313200"; 
   d="scan'208";a="588402427"
From: "Rose, Gregory V" <gregory.v.rose@intel.com>
To: David Miller <davem@davemloft.net>
CC: "leedom@chelsio.com" <leedom@chelsio.com>,
        "shemminger@vyatta.com" <shemminger@vyatta.com>,
        "andy@greyhouse.net" <andy@greyhouse.net>,
        "harald@redhat.com" <harald@redhat.com>,
        "bhutchings@solarflare.com" <bhutchings@solarflare.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gospo@redhat.com" <gospo@redhat.com>,
        "Duyck, Alexander H" <alexander.h.duyck@intel.com>
Date: Wed, 21 Jul 2010 12:02:17 -0700
Subject: RE: [PATCH net-next] sysfs: add entry to indicate network
 interfaces with random MAC address
Thread-Topic: [PATCH net-next] sysfs: add entry to indicate network
 interfaces with random MAC address
Thread-Index: AcspBYpZ1AeaLD8aT0ax61eRIXKFvgAAI+pw
Message-ID: <43F901BD926A4E43B106BF17856F0755F1846247@orsmsx508.amr.corp.intel.com>
References: <201007211129.48288.leedom@chelsio.com>
	<43F901BD926A4E43B106BF17856F0755F184620A@orsmsx508.amr.corp.intel.com>
	<20100721.114851.200597269.davem@davemloft.net>
 <20100721.115023.69942880.davem@davemloft.net>
In-Reply-To: <20100721.115023.69942880.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: David Miller [mailto:davem@davemloft.net]
>Sent: Wednesday, July 21, 2010 11:50 AM
>To: Rose, Gregory V
>Cc: leedom@chelsio.com; shemminger@vyatta.com; andy@greyhouse.net;
>harald@redhat.com; bhutchings@solarflare.com; sassmann@redhat.com;
>netdev@vger.kernel.org; linux-kernel@vger.kernel.org; gospo@redhat.com;
>Duyck, Alexander H
>Subject: Re: [PATCH net-next] sysfs: add entry to indicate network
>interfaces with random MAC address
>
>From: David Miller <davem@davemloft.net>
>Date: Wed, 21 Jul 2010 11:48:51 -0700 (PDT)
>
>> You could do things like have the PF controller use the root
>filesystem
>> ID label to construct the VF's MAC address, or something like that.
>
>And here I of course mean the root filesystem of the guest the VF will
>be given to.

I suppose you could do that but then the VM is going to have to be allowed to set its own MAC address.  There is a lot of opposition and concern about allowing VMs to set their own MAC address.

Then there's also support in the kernel now for assigning VF MAC and VLAN via the iproute2 package "ip link" commands.  The administrative SW that controls VMs should be assigning MAC addresses to VFs as needed.  When the VF is de-assigned from the guest because the VM is migrating then the administrative SW can assign another VF to the VM at the migration target machine and assign the same MAC address then.  This way it is all done administratively from the (supposedly) secure host VMM domain and we're not allowing VMs to set their own MAC address.

Ultimately I think I agree that some sort of approach such as you and others have been suggesting should be taken.  I'm agnostic about which one because my view of how things should work is a bit different.  But if the community thinks that finding some way to set a persistent MAC address for a VF is useful then I'd more than happy to make sure our drivers support that also.

As soon as it is decided what that is of course.

;-)

- Greg

