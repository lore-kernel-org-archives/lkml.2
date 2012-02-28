Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030473Ab2B1XmE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 18:42:04 -0500
Received: from gate.crashing.org ([63.228.1.57]:42880 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757484Ab2B1XmC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 18:42:02 -0500
Message-ID: <1330472496.11728.31.camel@pasglop>
Subject: Re: [PATCH 08/18] PCI, powerpc: Register busn_res for root buses
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Tony Luck <tony.luck@intel.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org
Date: Wed, 29 Feb 2012 10:41:36 +1100
In-Reply-To: <CAErSpo72_JnUkWXrzbNdbX9wiWZtQdX2tuNjEpYrSd+sGzxfzA@mail.gmail.com>
References: <1330395009-29260-1-git-send-email-yinghai@kernel.org>
	 <1330395009-29260-9-git-send-email-yinghai@kernel.org>
	 <CAErSpo4bw-V=SM+h5iP4nfv3HaAnHjwvNwu+4Oz8iyQcY_3gOQ@mail.gmail.com>
	 <CAErSpo72_JnUkWXrzbNdbX9wiWZtQdX2tuNjEpYrSd+sGzxfzA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-02-28 at 16:31 -0700, Bjorn Helgaas wrote:
> We may need mechanism to say "don't trust this info from the
> firmware," but we should be able to figure out a way that doesn't
> penalize platforms that do everything correctly.  The current patch
> breaks these scenarios even when the platform firmware is 100%
> correct.

On the other hand, our firmwares tend not to be and the vast majority of
our platforms have separate bus number domains (In fact I'm not sure
whether we have one that actually splits bus numbers or not, maybe some
ancient Apple gear, I need to double check).

We did use to force renumbering on macs to avoid bus number collisions
between domains because of ancient X servers that didn't do domains
properly but I think we dropped that.

Cheers,
Ben.


