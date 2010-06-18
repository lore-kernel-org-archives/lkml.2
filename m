Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761144Ab0FRQOB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 12:14:01 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:55297 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758041Ab0FRQN7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 12:13:59 -0400
From: Scott Goldman <scottjg@vmware.com>
To: Andy Whitcroft <apw@canonical.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 18 Jun 2010 09:11:27 -0700
Subject: RE: [PATCH] checkpatch: fix false positive on casting to double
 	pointer
Thread-Topic: [PATCH] checkpatch: fix false positive on casting to double
 	pointer
Thread-Index: AcsO6OdbwDD7SPG1QsyOmVSyV3VxbgAGABgV
Message-ID: <F78BCF638F95D74A99D036114107EDB50235BBE9B3@EXCH-MBX-3.vmware.com>
References: <1276806411-15176-1-git-send-email-scottjg@vmware.com>
	<AANLkTilrWSOoias64UGAnkV1RtIkVKiwapCnOYc2cS0_@mail.gmail.com>,<AANLkTinhcJAphiOo6Gj3pl7NY2oGkAwEw3xJZY_nvOxw@mail.gmail.com>
In-Reply-To: <AANLkTinhcJAphiOo6Gj3pl7NY2oGkAwEw3xJZY_nvOxw@mail.gmail.com>
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

> > Hrm, I would expect any number of levels of pointers to be detected
> > already correctly.
> >
> > /me goes check.
>
> We already have tests for both types which are passing generally, in
> t730-* and t7020-* so I think this is more likely a failure to detect
> the type as a type.  If you could send on the sample that triggers
> this I will have a look.
> 
> -apw

Yikes! you're right, lousy tests on my part. The part of my patch that triggered it was:
+  return snmp_fold_field((void __percpu **)net->mib.udp_statistics,
+           UDP_MIB_RCVBUFERRORS) +
+     snmp_fold_field((void __percpu **)net->mib.udplite_statistics,
+           UDP_MIB_RCVBUFERRORS);


ERROR: need consistent spacing around '*' (ctx:WxO)
#115: FILE: drivers/net/vmxnet3/vmxnet3_drv.c:1784:
+       return snmp_fold_field((void __percpu **)net->mib.udp_statistics,
                                              ^
Maybe caused by the __percpu attr?