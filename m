Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756282Ab1HVA7H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Aug 2011 20:59:07 -0400
Received: from mx.treblig.org ([80.68.94.177]:35085 "EHLO mx.treblig.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752486Ab1HVA7F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Aug 2011 20:59:05 -0400
Date: Mon, 22 Aug 2011 01:59:02 +0100
From: "Dr. David Alan Gilbert" <linux@treblig.org>
To: Witold.Szczeponik@gmx.net
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: 'flags' in rsparser.c change from 'register disabled resources'
	patch
Message-ID: <20110822005902.GA30602@gallifrey>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/2.6.32.27-kvm-i386-20110114 (i686)
X-Uptime: 01:50:04 up 185 days,  2:22,  1 user,  load average: 0.00, 0.00,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Witold,
  'sparse' is giving me the following set of warnings in the latest
kernel:

  CHECK   drivers/pnp/pnpacpi/rsparser.c
drivers/pnp/pnpacpi/rsparser.c:515:26: warning: cast truncates bits from constant value (10000000 becomes 0)
drivers/pnp/pnpacpi/rsparser.c:533:26: warning: cast truncates bits from constant value (10000000 becomes 0)
drivers/pnp/pnpacpi/rsparser.c:553:26: warning: cast truncates bits from constant value (10000000 becomes 0)
drivers/pnp/pnpacpi/rsparser.c:578:26: warning: cast truncates bits from constant value (10000000 becomes 0)
drivers/pnp/pnpacpi/rsparser.c:593:26: warning: cast truncates bits from constant value (10000000 becomes 0)
drivers/pnp/pnpacpi/rsparser.c:606:26: warning: cast truncates bits from constant value (10000000 becomes 0)
drivers/pnp/pnpacpi/rsparser.c:621:26: warning: cast truncates bits from constant value (10000000 becomes 0)
drivers/pnp/pnpacpi/rsparser.c:636:26: warning: cast truncates bits from constant value (10000000 becomes 0)
drivers/pnp/pnpacpi/rsparser.c:660:26: warning: cast truncates bits from constant value (10000000 becomes 0)
drivers/pnp/pnpacpi/rsparser.c:682:26: warning: cast truncates bits from constant value (10000000 becomes 0)

these all seem to come from the 'flags' variables you added
as part of patch 29df8d8f being char's and IORESOURCE_DISABLED 
being 0x10000000 so lines like:

+       unsigned char flags = 0;

+               flags |= IORESOURCE_DISABLED;

shouldn't work.

Dave

-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    |       Running GNU/Linux       | Happy  \ 
\ gro.gilbert @ treblig.org |                               | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/
