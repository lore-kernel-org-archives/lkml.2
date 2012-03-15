Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031091Ab2COWW7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 18:22:59 -0400
Received: from usindpps06.hds.com ([207.126.252.19]:37490 "EHLO
	usindpps06.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965291Ab2COWW4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 18:22:56 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Daniel Walker <dwalker@fifo99.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Avery Pennarun <apenwarr@gmail.com>, Josh Triplett <josh@joshtriplett.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, "David S. Miller" <davem@davemloft.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Fabio M. Di Nitto" <fdinitto@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Olaf Hering <olaf@aepfle.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Tejun Heo <tj@kernel.org>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Yinghai LU <yinghai@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>
Date: Thu, 15 Mar 2012 18:10:29 -0400
Subject: RE: [PATCH 0/5] Persist printk buffer across reboots.
Thread-Topic: [PATCH 0/5] Persist printk buffer across reboots.
Thread-Index: Ac0BiN3Gzmq9d4F2RW6+WuXPAR90dgBbfklQ
Message-ID: <5C4C569E8A4B9B42A84A977CF070A35B2E31C6F891@USINDEVS01.corp.hds.com>
References: <1331617001-20906-1-git-send-email-apenwarr@gmail.com>
 <20120313170851.GA5218@fifo99.com>
 <20120313151049.fa33d232.akpm@linux-foundation.org>
 <20120314021906.GC5218@fifo99.com>
In-Reply-To: <20120314021906.GC5218@fifo99.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ja-JP, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=2 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1203120001
 definitions=main-1203150245
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> There is also this series,
> 
> http://lists.infradead.org/pipermail/kexec/2011-July/005258.html
> 
> It seems awkward that pstore is in fs/pstore/ then pstore ends up as the "back end" where it could just be the whole solution.

I just wanted to avoid deadlocks of pstore and its drivers such as mtdoops, ramoops, and efi_pstore in panic case.
That is still under discussion in lkml.

I have no objection to modifying mtdoops/ram_console to use pstore.

>pstore does seems to have the nicest user interface (might be better in debugfs tho). If someone wanted to move forward with pstore they would have to write some some sort of,
>
>int pstore_register_simple(unsigned long addr, unsigned long size);
>
>to cover all the memory areas that aren't transaction based, or make pstore accept a platform_device.

If you would like to introduce new feature to pstore, Tony Luck is the appropriate person to discuss.

Seiji
