Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753783Ab0CRR6y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 13:58:54 -0400
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:44010 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753675Ab0CRR6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 13:58:53 -0400
Date: Thu, 18 Mar 2010 12:58:48 -0500 (CDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: David Miller <davem@davemloft.net>, netdev@vger.kernel.org
cc: linux-kernel@vger.kernel.org
Subject: Add PGM protocol support to the IP stack
Message-ID: <alpine.DEB.2.00.1003181245050.23010@router.home>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is there any work in progress on including PGM support (RFC 3208) in the
kernel?

I know about the openpgm implementation. Openpbm does this at the user
level and requires linking to a library. It is essentially a communication
protocol done in user space. It has privilege issues because it has to
create PGM packets via a raw socket. Which also has implications for the
possible performance. Openpgm seems to be able to interact with major
commercial implementations of PGM.

I am looking at openpgm right now and it seems that there are a number of
useful files and functions in there that could be used to implement PGM
support in the kernel.

There is also an existing socket API for handling PGM available in another
operating system whose name we rather avoid mentioning. That socket API
could be used as the basic. PGM use would then be possible without a
library and without privilege and performance issues.

PGM support would support two different modes of communication


1. Native PGM (allows NAK suppression by Cisco routers to be used)

	socket(AF_INET, SOCK_RDM, IPPROTO_RM)

(SOCK_RDM is defined in the kernel sources but not implemented. PGM
support would implement SOCK_RDM, IPPROTO_RM would need to be defined
according to the IANA protocol number for PGM).


2. PGM over UDP (which is used by many commercial product but not by the
unspeakable OS). No router support for NAK suppression is available. For
this I guess we would have to support

	socket(AF_INET, SOCK_RDM, IPPROTO_UDP)

I would be interested to find others who are interested in such a project
or maybe there is already a project in the works? If not then I will try
to come up with some code to get this going. Any help you could offer
would be appreciated.
