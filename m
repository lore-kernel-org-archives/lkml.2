Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757123Ab0GNSTw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 14:19:52 -0400
Received: from mga01.intel.com ([192.55.52.88]:7848 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756680Ab0GNSTv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 14:19:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,202,1278313200"; 
   d="scan'208";a="586103780"
From: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
To: Ben Greear <greearb@candelatech.com>
CC: Robert Hancock <hancockrwd@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Date: Wed, 14 Jul 2010 11:19:45 -0700
Subject: RE: Regression: 2.6.34 boot fails on E5405 system, bisected:
 	de08e2c26
Thread-Topic: Regression: 2.6.34 boot fails on E5405 system, bisected:
 	de08e2c26
Thread-Index: Acsjdvppx/jJO+oeTY63+nLsCJ5gJgACW8ag
Message-ID: <43F901BD926A4E43B106BF17856F0755EA8EEA18@orsmsx508.amr.corp.intel.com>
References: <4C3D067C.10507@candelatech.com>
	<4C3D101E.5010605@candelatech.com>	<4C3D1942.1090207@gmail.com>
	<4C3D1F82.1040907@candelatech.com>
 <AANLkTinDv7I4v51j-Lev9Ry_3DyVVv58lAyCQXZV1CwB@mail.gmail.com>
 <4C3DC64F.5040505@candelatech.com>
 <43F901BD926A4E43B106BF17856F0755EA8EE7E2@orsmsx508.amr.corp.intel.com>
 <4C3DEEAB.8090106@candelatech.com>
In-Reply-To: <4C3DEEAB.8090106@candelatech.com>
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
>From: Ben Greear [mailto:greearb@candelatech.com]
>Sent: Wednesday, July 14, 2010 10:07 AM
>To: Pan, Jacob jun
>Cc: Robert Hancock; linux-kernel; jbarnes@virtuousgeek.org
>Subject: Re: Regression: 2.6.34 boot fails on E5405 system, bisected:
>de08e2c26
>
>On 07/14/2010 08:36 AM, Pan, Jacob jun wrote:
>> what is the config size of 10.1?
>> ls -l /sys/bus/pci/devices/0000:00:10.1/config
>>
>> if that is 256, it might be related to this patch.
>
>That patch is already in 2.6.34.y (with slight white-space
>change it seems:  space before <).
>
>I just posted a patch to lkml that fixes the problem for me,
>based on a suggestion by Robert Hancock.
>
>I think this or something similar should to go 2.6.34.y stable
>as well.
> 


I have not seen the patch yet, but there is no guarantee that
capabilities are always laid out in ascending address. So I think
we cannot bail out when
	pcie_cap >> 20 <= pos

If that is some bug in the config space, can we fix it with some quirks?

Thanks,

Jacob

