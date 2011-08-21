Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752397Ab1HUFxA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Aug 2011 01:53:00 -0400
Received: from mga11.intel.com ([192.55.52.93]:29017 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750819Ab1HUFw6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Aug 2011 01:52:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,258,1312182000"; 
   d="scan'208";a="43468680"
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Jeff Chua <jeff.chua.linux@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
CC: Daniel Halperin <dhalperi@cs.washington.edu>,
        "Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>
Date: Sun, 21 Aug 2011 08:52:27 +0300
Subject: RE: WARNING: at lib/iomap.c:43 0xffffffffa00ac458()
Thread-Topic: WARNING: at lib/iomap.c:43 0xffffffffa00ac458()
Thread-Index: AcxfTwPIPydSeHn+Q46aFkFjrtiu8AAdncww
Message-ID: <4825B8A2C4E264489E57869F0DCFB2234456628564@hasmsx502.ger.corp.intel.com>
References: <Pine.LNX.4.64.1108181259020.4357@boston.corp.fedex.com>
 <Pine.LNX.4.64.1108202327480.7271@boston.corp.fedex.com>
In-Reply-To: <Pine.LNX.4.64.1108202327480.7271@boston.corp.fedex.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix is on the way:

commit 4eb60d869fdad7acd098b53bfd1863c311d8933d
Author: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Date:   Sat Aug 13 09:02:43 2011 -0700

    Revert "iwlagn: sysfs couldn't find the priv pointer"

    This reverts commit cc1a93e68f6c0d736b771f0746e8e4186f483fdc.

    This fix introduced a bug: bad pointer in unload.

    Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

And 

commit 16a9d06c753abc44f66f88e03bbecb3f1e45d71b
Author: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Date:   Sat Aug 13 09:02:44 2011 -0700

    iwlagn: sysfs couldn't find the priv pointer

    This bug has been introduced by:
    d593411084a56124aa9d80aafa15db8463b2d8f7
    Author: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    Date:   Mon Jul 11 10:48:51 2011 +0300

        iwlagn: simplify the bus architecture

    Revert part of the buggy patch: dev_get_drvdata will now return
    iwl_priv as it did before the patch.

    Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>


You can cherry-pick these and give it a try
I removed Linus from this thread, since I am pretty sure he doesn't need to be on that one, and I guess he receives many mails... I may be wrong though...

> 
> I bisected it further and it came down to this commit. Reverting it
> solves
> the problem. Now I'm on linux-3.1.0-rc2
> (bed8cad9593974a46de5c8aa3d2ee7c49c17182f) with the patch reverted and
> system
> is stable once again. modprobe -r iwlagn no longer hangs the system.
> 
> commit cc1a93e68f6c0d736b771f0746e8e4186f483fdc
> Author: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> Date:   Mon Aug 1 12:46:57 2011 -0700
> 
>      iwlagn: sysfs couldn't find the priv pointer
> 
>      This bug has been introduced by:
>      d593411084a56124aa9d80aafa15db8463b2d8f7
>      Author: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
>      Date:   Mon Jul 11 10:48:51 2011 +0300
> 
>          iwlagn: simplify the bus architecture
> 
>      Revert part of the buggy patch: dev_get_drvdata will now return
>      iwl_priv as it did before the patch.
> 
>      Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
>      Tested-by: Daniel Halperin <dhalperi@cs.washington.edu>
>      Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
>      Signed-off-by: John W. Linville <linville@tuxdriver.com>
> 
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

