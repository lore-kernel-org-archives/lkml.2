Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757505Ab0ITUfx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 16:35:53 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:48529 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753042Ab0ITUfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 16:35:51 -0400
Authentication-Results: sj-iport-6.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-AV: E=Sophos;i="4.56,395,1280707200"; 
   d="scan'208";a="592247779"
From: Roland Dreier <rdreier@cisco.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: linux-kernel@vger.kernel.org,
        "Jean Delvare \(PC drivers\, core\)" <khali@linux-fr.org>,
        "Ben Dooks \(embedded platforms\)" <ben-linux@fluff.org>,
        Roland Dreier <rolandd@cisco.com>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        Steve Wise <swise@chelsio.com>, Neil Brown <neilb@suse.de>,
        Paul Mackerras <paulus@samba.org>, linux-i2c@vger.kernel.org,
        linux-rdma@vger.kernel.org, dm-devel@redhat.com,
        linux-raid@vger.kernel.org, linux-ppp@vger.kernel.org,
        netdev@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: idr_get_new_exact ?
References: <AANLkTi=ZLupVyFR0e2v-TLpeNWdw1bVMZUAhgyxLJ7OV@mail.gmail.com>
X-Message-Flag: Warning: May contain useful information
Date: Mon, 20 Sep 2010 13:35:42 -0700
In-Reply-To: <AANLkTi=ZLupVyFR0e2v-TLpeNWdw1bVMZUAhgyxLJ7OV@mail.gmail.com>
	(Ohad Ben-Cohen's message of "Mon, 20 Sep 2010 16:11:31 +0200")
Message-ID: <adaiq20f90h.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > Occasionally, drivers care about the value that idr associates with
 > their pointers.
 > 
 > Today we have idr_get_new_above() which allocates a new idr entry
 > above or equal to a given starting id, but sometimes drivers need to
 > force an exact value.
 > 
 > To overcome this small API gap, drivers are wrapping idr_get_new_above
 > and then either BUG_ON() or just call idr_remove() and returns -EBUSY
 > when idr allocates them an id which is different than their requested
 > value.

Looks fine to me as an improvement over the status quo, but I wonder how
many of these places could use the radix_tree stuff instead?  If you're
not using the ability of the idr code to assign an id for you, then it
seems the radix_tree API is a better fit.

 - R.
