Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777Ab1EECEX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 22:04:23 -0400
Received: from mga09.intel.com ([134.134.136.24]:50771 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752237Ab1EECEU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 22:04:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,318,1301900400"; 
   d="scan'208";a="638177246"
Message-Id: <20110505015932.306763905@sli10-conroe.sh.intel.com>
User-Agent: quilt/0.48-1
Date: Thu, 05 May 2011 09:59:32 +0800
From: shaohua.li@intel.com
To: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Cc: jaxboe@fusionio.com, htejun@gmail.com, hch@infradead.org,
        jgarzik@pobox.com, djwong@us.ibm.com, sshtylyov@mvista.com
Subject: [patch v3 0/3] block: optimize flush for non-queueable flush drive
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Flush request isn't queueable. When it's running, other request
can't. We can optimize flush performance according to this knowledge
In my test, I got about 20% performance boost.

v2->v3: mainly adds more comments to explain the optimization and changes
the code position to enable the optimization in SATA.
