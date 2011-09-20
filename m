Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752255Ab1ITS3i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 14:29:38 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:19649 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023Ab1ITS3h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 14:29:37 -0400
MIME-Version: 1.0
Message-ID: <a7471ea9-1d24-452a-8e3b-eb5836e8e7d5@default>
Date: Tue, 20 Sep 2011 11:28:21 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, jeremy@goop.org,
        hughd@google.com, ngupta@vflare.org,
        Konrad Wilk <konrad.wilk@oracle.com>, JBeulich@novell.com,
        Kurt Hackel <kurt.hackel@oracle.com>, npiggin@kernel.dk,
        akpm@linux-foundation.org, riel@redhat.com, hannes@cmpxchg.org,
        matthew@wil.cx, Chris Mason <chris.mason@oracle.com>,
        kamezawa.hiroyu@jp.fujitsu.com, jackdachef@gmail.com,
        cyclonusj@gmail.com, levinsasha928@gmail.com
Subject: RE: [PATCH V10 3/6] mm: frontswap: core frontswap functionality
References: <20110915213406.GA26369@ca-server1.us.oracle.com
 4E73674B.6090901@linux.vnet.ibm.com>
In-Reply-To: <4E73674B.6090901@linux.vnet.ibm.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.4.1.0  (410211) [OL
 12.0.6557.5001]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090206.4E78DB78.006C,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Seth Jennings [mailto:sjenning@linux.vnet.ibm.com]
> Sent: Friday, September 16, 2011 9:12 AM
> To: Dan Magenheimer
> Cc: linux-kernel@vger.kernel.org; linux-mm@kvack.org; jeremy@goop.org; hughd@google.com;
> ngupta@vflare.org; Konrad Wilk; JBeulich@novell.com; Kurt Hackel; npiggin@kernel.dk; akpm@linux-
> foundation.org; riel@redhat.com; hannes@cmpxchg.org; matthew@wil.cx; Chris Mason;
> kamezawa.hiroyu@jp.fujitsu.com; jackdachef@gmail.com; cyclonusj@gmail.com; levinsasha928@gmail.com
> Subject: Re: [PATCH V10 3/6] mm: frontswap: core frontswap functionality
> 
> On 09/15/2011 04:34 PM, Dan Magenheimer wrote:
> > From: Dan Magenheimer <dan.magenheimer@oracle.com>
> > Subject: [PATCH V10 3/6] mm: frontswap: core frontswap functionality
> >
> > [v10: sjenning@linux.vnet.ibm.com: fix debugfs calls on 32-bit]
> ...
> > +#ifdef CONFIG_DEBUG_FS
> > +	struct dentry *root = debugfs_create_dir("frontswap", NULL);
> > +	if (root == NULL)
> > +		return -ENXIO;
> > +	debugfs_create_u64("gets", S_IRUGO, root, &frontswap_gets);
> > +	debugfs_create_u64("succ_puts", S_IRUGO, root, &frontswap_succ_puts);
> > +	debugfs_create_u64("puts", S_IRUGO, root, &frontswap_failed_puts);
> 
> Sorry I didn't see this one before :-/  This should be "failed_puts",
> not "puts".

Oops, thought I had replied to this but hadn't.

Thanks for catching that typo.  Unless someone reports something
else that needs fixing, I will likely just fix that in my git tree
rather than post a V11.
 
> Other than that, it compiles cleanly here and runs without issue when
> applied on 3.1-rc4 + fix for cleancache crash.

Thanks for the testing!

Dan
