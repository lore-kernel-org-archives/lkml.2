Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884Ab0CRWaM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 18:30:12 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:42035 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068Ab0CRWaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 18:30:09 -0400
Authentication-Results: sj-iport-6.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAN5FokurRN+K/2dsb2JhbACbLnOjbph9hHkEgx0
X-IronPort-AV: E=Sophos;i="4.51,269,1267401600"; 
   d="scan'208";a="499130192"
From: Roland Dreier <rdreier@cisco.com>
To: Greg KH <greg@kroah.com>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>, Alex Chiang <achiang@hp.com>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] small xhci cleanups
References: <20100316204845.GJ8278@ldl.fc.hp.com>
	<20100309184723.GA31374@kroah.com> <20100316212445.GA15729@xanatos>
	<20100316214014.GA8839@kroah.com> <20100318213308.GA5461@xanatos>
	<20100318221958.GB3299@kroah.com>
X-Message-Flag: Warning: May contain useful information
Date: Thu, 18 Mar 2010 15:30:05 -0700
In-Reply-To: <20100318221958.GB3299@kroah.com> (Greg KH's message of "Thu, 18
	Mar 2010 15:19:58 -0700")
Message-ID: <ada1vfh6z6a.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > > I think the end user doesn't want to see anything from the driver unless
 > > something serious has gone wrong.  But those cases use xhci_warn(),
 > > which translates down to dev_warn(), instead of xhci_dbg().
 > 
 > Yes, that's fine.  But you need/want something for when a user reports a
 > problem, and they can't rebuild their kernel.

Yes, just to be clear (and I'm pretty sure I'm agreeing with Greg here)
any warnings that you want always enabled to show something in the
kernel log whenever there's a problem should be dev_warn() or
equivalent.

Things that produce too much output and that you only want on when
you're debugging a problem are probably best done via trace events.

 - R.
-- 
Roland Dreier  <rolandd@cisco.com>
For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
