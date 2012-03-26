Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932584Ab2CZOb2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 10:31:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6721 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932473Ab2CZOb1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 10:31:27 -0400
Date: Mon, 26 Mar 2012 16:31:00 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: J Freyensee <james_p_freyensee@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Null pointer dereference in pti_exit()
Message-ID: <20120326143059.GA4051@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

We have this bug report:
https://bugzilla.redhat.com/show_bug.cgi?id=783561

Crash when someone load module and do not have actual pti device.
Then misc_deregister(&pti_char_driver) called from pti_exit() will be
done without misc_register(&pti_char_driver), which is called from
pti_pci_probe().

It is not super critical issue since if somebody who do not have
pti device have no reason to load modules, but I guess would be
good to fix this.

Thanks
Stanislaw
