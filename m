Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150Ab2BAAne (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 19:43:34 -0500
Received: from mga14.intel.com ([143.182.124.37]:18718 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752541Ab2BAAnd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 19:43:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="61876692"
From: "Rose, Gregory V" <gregory.v.rose@intel.com>
To: David Ahern <daahern@cisco.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: RE: VFs go missing with latest kernel
Thread-Topic: VFs go missing with latest kernel
Thread-Index: AQHM4Gs6ffY5XbLoAUGa1L3askdwe5YnFpYAgACgHID//3peYA==
Date: Wed, 1 Feb 2012 00:43:07 +0000
Message-ID: <C5551D9AAB213A418B7FD5E4A6F30A0702F64AF6@ORSMSX106.amr.corp.intel.com>
References: <4F287102.3060600@cisco.com>
 <C5551D9AAB213A418B7FD5E4A6F30A0702F6489B@ORSMSX106.amr.corp.intel.com>
 <4F2887AB.8070005@cisco.com>
In-Reply-To: <4F2887AB.8070005@cisco.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: David Ahern [mailto:daahern@cisco.com]
> Sent: Tuesday, January 31, 2012 4:31 PM
> To: Rose, Gregory V
> Cc: LKML
> Subject: Re: VFs go missing with latest kernel
> 
> On 01/31/2012 03:58 PM, Rose, Gregory V wrote:
> >> I am hitting some other problem trying to use the VF on 3.3.0-rc1 --
> KVM
> >> fails the KVM_CAP_IOMMU check though the server has one (works fine
> with
> >> the older kernel) and it is built into the kernel. Debugging that
> >> problem now.
> 
> second problem was due to a CONFIG setting.
> 
> Back to the missing VF problem: reverting the patch I mentioned before
> and my VM boots up fine with the even-numbered VFs assigned to it.

OK, thanks... I was staring at the dmesg output you sent me and it is odd because the even numbered VFs that go missing are there when you set their MAC addresses.  See output below the dotted line after my reply.

Also, the dmesg output indicates 28 VFs are created but the lspci output you've sent only shows 14, even from the stock FC 14 kernel.  So even in that case you seem to be missing 14 VFs from the lspci output.

So they're there at one point but then disappear.  Very odd.  I'm finishing up a few other things but will try to repro ASAP and get back to you with my results.

- Greg

------------
[   81.432421] igb 0000:07:00.0: setting MAC 02:12:34:56:79:41 on VF 1
[   81.432550] igb 0000:07:00.0: Reload the VF driver to make this change effective.
[   81.432667] igb 0000:07:00.0: The VF MAC address has been set, but the PF device is not up.
[   81.432942] igb 0000:07:00.0: Bring the PF device up before attempting to use the VF device.
[   81.434947] igb 0000:07:00.0: setting MAC 02:12:34:56:79:42 on VF 2
[   81.435060] igb 0000:07:00.0: Reload the VF driver to make this change effective.
[   81.435174] igb 0000:07:00.0: The VF MAC address has been set, but the PF device is not up.
[   81.435450] igb 0000:07:00.0: Bring the PF device up before attempting to use the VF device.
[   81.437429] igb 0000:07:00.0: setting MAC 02:12:34:56:79:43 on VF 3
[   81.437555] igb 0000:07:00.0: Reload the VF driver to make this change effective.
[   81.437670] igb 0000:07:00.0: The VF MAC address has been set, but the PF device is not up.
[   81.437937] igb 0000:07:00.0: Bring the PF device up before attempting to use the VF device.
[   81.439904] igb 0000:07:00.0: setting MAC 02:12:34:56:79:44 on VF 4
[   81.440016] igb 0000:07:00.0: Reload the VF driver to make this change effective.
[   81.440132] igb 0000:07:00.0: The VF MAC address has been set, but the PF device is not up.
[   81.440400] igb 0000:07:00.0: Bring the PF device up before attempting to use the VF device.
[   81.442328] igb 0000:07:00.0: setting MAC 02:12:34:56:79:45 on VF 5
[   81.442453] igb 0000:07:00.0: Reload the VF driver to make this change effective.
[   81.442567] igb 0000:07:00.0: The VF MAC address has been set, but the PF device is not up.
[   81.442837] igb 0000:07:00.0: Bring the PF device up before attempting to use the VF device.
[   81.444921] igb 0000:07:00.0: setting MAC 02:12:34:56:79:46 on VF 6
[   81.445035] igb 0000:07:00.0: Reload the VF driver to make this change effective.
[   81.445149] igb 0000:07:00.0: The VF MAC address has been set, but the PF device is not up.
[   81.445417] igb 0000:07:00.0: Bring the PF device up before attempting to use the VF device.
-------------------

> 
> David
