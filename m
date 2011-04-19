Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753090Ab1DSGNT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 02:13:19 -0400
Received: from mga02.intel.com ([134.134.136.20]:47430 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752942Ab1DSGNN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 02:13:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,237,1301900400"; 
   d="scan'208";a="735386310"
From: "Koul, Vinod" <vinod.koul@intel.com>
To: Viresh Kumar <viresh.kumar@st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "armando.visconti@st.com" <armando.visconti@st.com>,
        "shiraz.hashim@st.com" <shiraz.hashim@st.com>,
        "amit.goel@st.com" <amit.goel@st.com>,
        "viresh.linux@gmail.com" <viresh.linux@gmail.com>,
        "jamie@jamieiles.com" <jamie@jamieiles.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>
Date: Tue, 19 Apr 2011 11:42:24 +0530
Subject: RE: [PATCH 2/6] dmaengine/dw_dmac: Enable resubmission from
 callback routine.
Thread-Topic: [PATCH 2/6] dmaengine/dw_dmac: Enable resubmission from
 callback routine.
Thread-Index: Acv9tn8oiZQTLYmHSB2SSmZWwMOeiAAoYM/w
Message-ID: <438BB0150E931F4B9CE701519A44630108519E1BE6@bgsmsx502.gar.corp.intel.com>
References: <e52c8e679fbf3007cf7e5e4bcfc86ea208a09d7c.1303123511.git.viresh.kumar@st.com>
 <cf350c267897bd4eaf5a027c659771eee117ac74.1303123511.git.viresh.kumar@st.com>
In-Reply-To: <cf350c267897bd4eaf5a027c659771eee117ac74.1303123511.git.viresh.kumar@st.com>
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

On 04/18/2011 04:20 PM, viresh kumar wrote:
> 
> Resubmission of new transfer must be allowed from callbacks. For this release
> lock before calling callback routine and enable them again.
Why would you like to do that?

IMO it's not a good thing as you are essentially doing it in your tasklet...
Make sure the submit() is done by client before this and you use it to start
next transaction in you tasklet and let client know in callback txn is
finished.

~Vinod

