Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615Ab1FUHyJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 03:54:09 -0400
Received: from nat13.teradata.com ([153.65.16.13]:23153 "EHLO
	rpc7152.teradata.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751276Ab1FUHyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 03:54:06 -0400
X-Greylist: delayed 643 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 Jun 2011 03:54:06 EDT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
Subject: RE: Linux 3.0-rc4 - fail to compile...
Date: Tue, 21 Jun 2011 03:43:19 -0400
Message-ID: <CA6D5843B7A98C46A33D67C6B6640E4A065E2DAE@sushdc7898.TD.teradata.com>
In-Reply-To: <20110621091335.49bc46df@tux.DEF.witbe.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Linux 3.0-rc4 - fail to compile...
Thread-Index: Acwv4tPHru3iSwNbS/WXj625H11X7wAA1QYg
References: <BANLkTimiVpKavmKY=rsJP34dMQSq__Xn7g@mail.gmail.com> <20110621091335.49bc46df@tux.DEF.witbe.net>
From: "Deng, Xuyue" <Deng.Xuyue@Teradata.com>
To: =?iso-2022-jp?B?UGF1bCBSb2xsYW5kICgbJEIlXSE8JWshJiVtJWklcxsoQik=?= 
	<rol@witbe.net>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
X-TM-AS-Product-Ver: IMSS-7.0.0.3390-6.5.0.1024-18212.005
X-TM-AS-Result: No--9.449-5.0-31-1
X-imss-scan-details: No--9.449-5.0-31-1;No--9.449-5.0-31-1
X-TM-AS-User-Approved-Sender: No;No
X-TM-AS-User-Blocked-Sender: No
X-TM-AS-Result-Xfilter: Match text exemption rules:No;Match text exemption rules:No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, the same issue occurs on my machine.

But I cannot find any explict configuration option to enable CONFIG_NUMA. 
Did you place "CONFIG_NUMA=y" in the .config anyway? 


Best Regards
Deng, xuyue

-----Original Message-----
From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Paul Rolland (???・???)
Sent: Tuesday, June 21, 2011 3:14 PM
To: Linus Torvalds
Cc: Linux Kernel Mailing List; rol@witbe.net
Subject: Re: Linux 3.0-rc4 - fail to compile...

Hello,

On Mon, 20 Jun 2011 21:02:56 -0700
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> Mostly the usual small driver one- (or few-) liners, and some bigger
> changes to drm (and md). But also two new smallish drivers
> (net/usb/kalmia.c, and the ADP8870 backlight driver). Some filesystem
> fixes (btrfs, cifs, afs, xfs, nfsd).

This is failing to compile on my machine :
...
  CC      mm/page_cgroup.o
  CC      fs/direct-io.o
mm/page_cgroup.c: In function ‘page_cgroup_init’:
mm/page_cgroup.c:308: error: implicit declaration of function ‘node_start_pfn’
mm/page_cgroup.c:309: error: implicit declaration of function ‘node_end_pfn’
make[1]: *** [mm/page_cgroup.o] Error 1
make: *** [mm] Error 2
make: *** Waiting for unfinished jobs....
  CC      fs/mpage.o
  CC      fs/ioprio.o

This seems to be caused by arch/x86/include/asm/mmzone_64.h which only defines
node_start_pfn and node_end_pfn if CONFIG_NUMA is set.

Adding CONFIG_NUMA to my .config fixes the issue.

Paul


