Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756012Ab1GQOh5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jul 2011 10:37:57 -0400
Received: from gate.crashing.org ([63.228.1.57]:59268 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752866Ab1GQOhw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jul 2011 10:37:52 -0400
Subject: Re: [PATCH 1/1] Fixup write permission of TLB on powerpc e500 core
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Shan Hai <haishan.bai@gmail.com>, paulus@samba.org, tglx@linutronix.de,
        walken@google.com, dhowells@redhat.com, cmetcalf@tilera.com,
        tony.luck@intel.com, akpm@linux-foundation.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <1310900561.13765.22.camel@twins>
References: <1310717238-13857-1-git-send-email-haishan.bai@gmail.com>
	 <1310717238-13857-2-git-send-email-haishan.bai@gmail.com>
	 <1310725418.2586.309.camel@twins>  <4E21A526.8010904@gmail.com>
	 <1310860194.25044.17.camel@pasglop>  <1310900561.13765.22.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Jul 2011 00:34:24 +1000
Message-ID: <1310913264.25044.205.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-07-17 at 13:02 +0200, Peter Zijlstra wrote:
> 
> Again, _WHY_ isn't gup(.write=1) a complete write fault? Its supposed to
> be, it needs to break COW, do dirty page tracking and call page_mkwrite.
> I'm still thinking this e500 stuff is smoking crack.
> 
> ARM has no hardware dirty bit either, and yet it works for them. I can't
> exactly tell how because I got lost in there, but it does, again,
> suggest e500 is on crack. 

Because gup won't set dirty for a page that is already writable but
whose dirty bit has been "harvested" by the VM already. Same with young.

Maybe nobody sees it on ARM because nobody ever swaps on it ? :-) Or
they have some different way of handling dirty/young updates.. I don't
know.

e500 isn't the only one who will be affected. All the non-hash powerpc
subarchs will (I wrote a lot of that mm code so it's all my fault :-)
That includes 4xx and 64-bit BookE.

Cheers,
Ben.


