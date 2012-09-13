Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757619Ab2IMOas (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 10:30:48 -0400
Received: from shetland.sei.cmu.edu ([192.58.107.44]:38061 "EHLO
	shetland.sei.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754184Ab2IMOaq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 10:30:46 -0400
From: "Jonathan M. Foote" <jmfoote@cert.org>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 13 Sep 2012 10:31:01 -0400
Subject: Re: [PATCH 2/2] coredump: add a new elf note with siginfo fields of
 the signal
Thread-Topic: Re: [PATCH 2/2] coredump: add a new elf note with siginfo
 fields of the signal
Thread-Index: Ac2RvD5I9gzZ7f8ZSSOQTnsoCACSjA==
Message-ID: <A32A045574615B4FAB96C4952BA5768BB9A1746DE9@EXCHANGE.sei.cmu.edu>
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

Hello,

I am the author of the CERT 'exploitable' GDB extension (code here: http://www.cert.org/vuls/discovery/triage.html). The extension uses GDB to give developers information about how exploitable an application crash might be. Right now the extension can only supply useful information for live GDB targets. Denys's patches will allow the extension to work on core files as well, which will enable more teams performing crash triage to use the tool.

As a specific example of how this is useful, in the case of an access violation the extension applies heuristics that try to determine if the access violation was due to a read (si_addr == op.source) or a write (si_addr == op.dest). Write access violations _generally_ require less effort to exploit than read access violations, so, depending on what other heuristics can be applied, the extension may consider a write access violation to be more "more exploitable" than a read access violation. This information is helpful to developers who may have large numbers of crashing test cases to deal with and need to decide which ones to address first. 

As it stands, core files do not include si_addr, and so the 'exploitable' GDB extension is unable to produce even the most basic analysis when applied to them. Denys's patch aims to address this issue, and will therefore allow the 'exploitable' extension to produce some useful information when executed against core files. Since core files have become the standard method of communicating crash information in many contexts, these patches will allow for increased application of the 'exploitable' extension and in a small way promote greater software security for Linux applications.

Please consider accepting these patches.

Thanks,
Jonathan

