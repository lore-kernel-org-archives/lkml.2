Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755590Ab1KIRL4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 12:11:56 -0500
Received: from g1t0027.austin.hp.com ([15.216.28.34]:4330 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285Ab1KIRLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 12:11:55 -0500
Subject: ip_local_deliver_finish: proto 108 (IPComp) isn't netns-ready
From: Dilip Daya <dilip.daya@hp.com>
Reply-To: dilip.daya@hp.com
To: linux-kernel@vger.kernel.org
Cc: ebiederm@xmission.com, jmorris@namei.org
Content-Type: text/plain; charset="UTF-8"
Organization: Hewlett-Packard Company
Date: Wed, 09 Nov 2011 12:11:46 -0500
Message-ID: <1320858706.2531.45.camel@pro6455b.example.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

LTP-network tests produced:

	"ip_local_deliver_finish: proto 108 (IPComp) isn't netns-ready"

Question:
Is the above a bug or feature (IPComp, mode: transport) not netns
enabled?

Environment:

* v3.1-stable kernel.

* Configured two network-namespaces via "ip netns add ...".
  on a single system: netns0 (assigned as server) and
  netns1 (assigned as client).
  - assigned multiple physical NICs to netns0 and netns1.

* Entered netns1 (ip netns exec netns1 bash) to execute
  ltp-network suite of tests between netns1 and netns0.

* The following LTP tests produced messages:

  "kernel: ip_local_deliver_finish: proto 108 isn't netns-ready"

   - /usr/lib/ltp/testcases/bin/icmp4-multi-diffip06
   - /usr/lib/ltp/testcases/bin/tcp4-multi-diffip13
   - /usr/lib/ltp/testcases/bin/udp4-multi-diffip06
   - /usr/lib/ltp/testcases/bin/udp4-multi-diffnic06
   - /usr/lib/ltp/testcases/bin/udp4-multi-diffport06

* I also noticed missing ".netns_ok = 1" in:
  - http://lxr.linux.no/linux+v3.1/net/ipv4/ipcomp.c#L150


-DilipD.



