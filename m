Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464Ab0HSTEF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 15:04:05 -0400
Received: from orford.cim.mcgill.ca ([132.206.73.2]:50687 "EHLO
	orford.cim.mcgill.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754430Ab0HSTEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 15:04:02 -0400
X-Greylist: delayed 510 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Aug 2010 15:04:02 EDT
Message-ID: <4C6D7E1E.4020207@cim.mcgill.ca>
Date: Thu, 19 Aug 2010 14:55:26 -0400
From: Patrick McLean <patrick@cim.mcgill.ca>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100807 Lightning/1.0b2pre Thunderbird/3.1.2
MIME-Version: 1.0
To: bridge@lists.linux-foundation.org
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Jan Binder <jan@cim.mcgill.ca>
Subject: [Bug #16572][REGRESSION, bisected] random panics in bridging on 2.6.34+
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am getting random panics with KVM/bridging on 2.6.34+ (including
latest git as of this morning).

There is a screenshot of the panic message in bugzilla at
https://bugzilla.kernel.org/show_bug.cgi?id=16572

It seems to happen when I have KVM virtual machines running with
bridging mode, most often when any of the virtual machines talk to the
network, or sometimes when they are brought up or down.

I bisected it down to this commit:

commit 68b7c895be336b19f4c38d7cb500132fabba0afd
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Sat Feb 27 19:41:40 2010 +0000

    bridge: Allow tail-call on br_pass_frame_up

    This patch allows tail-call on the call to br_pass_frame_up
    in br_handle_frame_finish.  This is now possible because of the
    previous patch to call br_pass_frame_up last.

    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
    Signed-off-by: David S. Miller <davem@davemloft.net>

