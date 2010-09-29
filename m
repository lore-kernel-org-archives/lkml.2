Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850Ab0I2XkQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 19:40:16 -0400
Received: from mga02.intel.com ([134.134.136.20]:24057 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751071Ab0I2XkP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 19:40:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,257,1283756400"; 
   d="scan'208";a="559196982"
From: "Tantilov, Emil S" <emil.s.tantilov@intel.com>
To: Sami Farin <safari-kernel@safari.iki.fi>,
        Sami Farin <hvtaifwkbgefbaei@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>
Date: Wed, 29 Sep 2010 17:40:08 -0600
Subject: RE: [E1000-devel] Linux 2.6.35.6/e1000e does not receive replies
 from DHCP server, 2.6.33 works
Thread-Topic: [E1000-devel] Linux 2.6.35.6/e1000e does not receive replies
 from DHCP server, 2.6.33 works
Thread-Index: ActeXlX/E96ZVtyxRs+U906aZlPgfwBz/Qag
Message-ID: <EA929A9653AAE14F841771FB1DE5A13660222E867B@rrsmsx501.amr.corp.intel.com>
References: <20100927131935.d5f2ghpfaufiq6yx@m.safari.iki.fi>
 <20100927160731.ehcljyewa5b5wrbm@m.safari.iki.fi>
In-Reply-To: <20100927160731.ehcljyewa5b5wrbm@m.safari.iki.fi>
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

Sami Farin wrote:
> False alarm, 2.6.35.6+latest git e1000e does not work any better.
> I was just lucky.

Is your `latest git` from Linus or net-next tree? All of our latest patches go into net-next, so if you haven't already - give it a try and see if it resolves your issue.

> 
> One thing what was common, when it works, I get this line a little
> time before dhclient start working:
> 
> eth0: IPv6 duplicate address fe80::219:d1ff:fe00:5f01 detected!

I have a system with the same device ID (it is not the same board) and could not reproduce any issues with DHCP on 2.6.35.6 kernel. 

Aside from checking the latest net-next tree, there are some other things to look into:

1. Is AMT enabled - there is usually a manageability tab/option in the BIOS. If you have that option try enabling/disabling it and see if it makes a difference.

2. Make sure your BIOS is up to date.

If any of the above does not help your situation please file a bug at e1000.sf.net and include the following information:

1. lspci -vvv
2. ethtool -e eth0
3. there is a tool call ethregs which you can download from this site. If you can include the output of ethregs -s 00:19.0 
4. kernel config
5. anything that you think may be related - like setup, type of traffic etc.

Thanks,
Emil