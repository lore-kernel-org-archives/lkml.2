Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756814Ab2BGTt4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 14:49:56 -0500
Received: from mga01.intel.com ([192.55.52.88]:26985 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756574Ab2BGTtx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 14:49:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="122129735"
From: "Kay, Allen M" <allen.m.kay@intel.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: "linux-pci-owner@vger.kernel.org" <linux-pci-owner@vger.kernel.org>,
        "Barnes, Jesse" <jesse.barnes@intel.com>,
        "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jean.guyader@eu.citrix.com" <jean.guyader@eu.citrix.com>,
        "eric.chanudet@citrix.com" <eric.chanudet@citrix.com>
Subject: RE: [PATCH 1/1][resend]  check for pci bar restore completion and
 retry
Thread-Topic: [PATCH 1/1][resend]  check for pci bar restore completion and
 retry
Thread-Index: AQHM3SwUTYf8DQbgm0uQULr8/d/8npYx4fhA
Date: Tue, 7 Feb 2012 19:49:48 +0000
Message-ID: <003AAFE53969E14CB1F09B6FD68C3CD409A8B4F2@ORSMSX105.amr.corp.intel.com>
References: <1327602353-30966-1-git-send-email-allen.m.kay@intel.com>
 <20120127114416.2621963a@jbarnes-desktop>
In-Reply-To: <20120127114416.2621963a@jbarnes-desktop>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry Jesse, I did not see this until now.  There is some problem with my email I was not aware of - many emails did not go into my inbox.

Given there are many reset methods, checking for actual BAR restore is more reliable and less testing for a various reset methods.  We can potentially add checks for completion in pcie_flr() since that's easy to do.

Eric/Jean, do you have other comments? 

Allen

-----Original Message-----
From: Jesse Barnes [mailto:jbarnes@virtuousgeek.org] 
Sent: Friday, January 27, 2012 11:44 AM
To: Kay, Allen M
Cc: linux-pci-owner@vger.kernel.org; Barnes, Jesse; Wilcox, Matthew R; linux-kernel@vger.kernel.org; jean.guyader@eu.citrix.com; eric.chanudet@citrix.com
Subject: Re: [PATCH 1/1][resend] check for pci bar restore completion and retry

On Thu, 26 Jan 2012 10:25:53 -0800
"Kay, Allen M" <allen.m.kay@intel.com> wrote:

> On some OEM systems, pci_restore_state() is called while FLR has not 
> yet completed.  As a result, PCI BAR register restore is not 
> successful.  This fix reads back the restored value and compares it 
> with saved value and re-tries 10 times before giving up.

Applied, but I don't think I got an answer as to why we don't do this delay/check when we perform the FLR in the first place?

--
Jesse Barnes, Intel Open Source Technology Center
