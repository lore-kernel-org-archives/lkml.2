Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755093Ab1HYRxd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 13:53:33 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:46683 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755066Ab1HYRxb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 13:53:31 -0400
MIME-Version: 1.0
Message-ID: <75ecaef7-054a-4acd-b1c5-8041ccde3501@default>
Date: Thu, 25 Aug 2011 10:52:18 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, jeremy@goop.org,
        hughd@google.com, ngupta@vflare.org,
        Konrad Wilk <konrad.wilk@oracle.com>, JBeulich@novell.com,
        Kurt Hackel <kurt.hackel@oracle.com>, npiggin@kernel.dk,
        akpm@linux-foundation.org, riel@redhat.com, hannes@cmpxchg.org,
        matthew@wil.cx, Chris Mason <chris.mason@oracle.com>,
        jackdachef@gmail.com, cyclonusj@gmail.com
Subject: RE: Subject: [PATCH V7 2/4] mm: frontswap: core code
References: <20110823145815.GA23190@ca-server1.us.oracle.com>
 <20110825150532.a4d282b1.kamezawa.hiroyu@jp.fujitsu.com
 4E564E4D.4030302@linux.vnet.ibm.com>
In-Reply-To: <4E564E4D.4030302@linux.vnet.ibm.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.4.1.0  (410211) [OL
 12.0.6557.5001]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090205.4E568C07.0066,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Seth Jennings [mailto:sjenning@linux.vnet.ibm.com]
> To: KAMEZAWA Hiroyuki
> 
> On 08/25/2011 01:05 AM, KAMEZAWA Hiroyuki wrote:
> <cut>
> >
> >
> > I'm sorry if I miss codes but.... is an implementation of frontswap.ops included
> > in this patch set ? Or how to test the work ?
> 
> The zcache driver (in drivers/staging/zcache) is the one that registers frontswap ops.
> 
> You can test frontswap by enabling CONFIG_FRONTSWAP and CONFIG_ZCACHE, and putting
> "zcache" in the kernel boot parameters.

Also see Xen tmem (in drivers/xen).  I am also working on a related project
called RAMster that uses frontswap.  And someone has started code for KVM
to work with transcendent memory (including frontswap).  But for now zcache
is the only non-virtualization in-kernel user for frontswap.

Dan

P.S. A recent build fix for zcache is necessary for it to work without
manual modification to the zcache Makefile.
See 8c70aac04e01a08b7eca204312946206d1c1baac in Linus's tree.
