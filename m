Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752228Ab0KDC01 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 22:26:27 -0400
Received: from mga09.intel.com ([134.134.136.24]:63743 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751287Ab0KDC0Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 22:26:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,292,1286175600"; 
   d="scan'208";a="674108008"
Subject: Re: [E1000-devel] 2.6.36 abrupt total e1000e carrier loss (cured
 by reboot)
From: "\"Brandeburg, Jesse\"" <jesse.brandeburg@intel.com>
To: Nix <nix@esperi.org.uk>
Cc: "Tantilov, Emil S" <emil.s.tantilov@intel.com>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <87zktsskua.fsf@spindle.srvr.nix>
References: <87ocaaszx1.fsf@spindle.srvr.nix>
	 <EA929A9653AAE14F841771FB1DE5A136602815A3C7@rrsmsx501.amr.corp.intel.com>
	 <87zktsskua.fsf@spindle.srvr.nix>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 03 Nov 2010 22:26:26 -0400
Message-ID: <1288837586.2835.3.camel@jbrandeb-mobl2>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.0 (2.32.0-2.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-01 at 16:08 -0700, Nix wrote:
> 03:00.0 Ethernet controller: Intel Corporation 82574L Gigabit Network
> Connection

> LnkCtl: ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
>         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-

This is a problem, L0s and L1 don't work on these adapters, make sure
that the patches to the driver to disable ASPM upon load are in place
and working (by the ASPM value above indicating ASPM Disabled)

The above could be responsible for your issue.  If you don't want to
disable ASPM system wide, then you could just make sure to run a recent
kernel with the ASPM patches, or get our e1000.sf.net e1000e driver and
try it, as it will work around the issue whether or not aspm is enabled.


Jesse


