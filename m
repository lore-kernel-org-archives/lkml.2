Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751605Ab1GRHF6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 03:05:58 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:18075 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855Ab1GRHF5 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:6:1>);
	Mon, 18 Jul 2011 03:05:57 -0400
Message-Id: <4E23F76D020000780004DCD9@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Mon, 18 Jul 2011 08:05:49 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: <Ian.Campbell@citrix.com>, "Keir Fraser" <keir.xen@gmail.com>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>, <keir@xen.org>
Cc: <olaf@aepfle.de>, <xen-devel@lists.xensource.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH] xen: update machine_to_phys_order on
	 resume
References: <4E20873F020000780007307B@nat28.tlf.novell.com>
 <CA46441A.1E019%keir.xen@gmail.com>
In-Reply-To: <CA46441A.1E019%keir.xen@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 15.07.11 at 20:23, Keir Fraser <keir.xen@gmail.com> wrote:
> On 15/07/2011 18:30, "Jan Beulich" <JBeulich@novell.com> wrote:
> 
>> Actually, one more thought: What's the purpose of this hypercall if
>> it is set in stone what values it ought to return? Isn't a guest using
>> it (supposed to be) advertising that it can deal with the values being
>> variable (and it was just overlooked so far that this doesn't only
>> include varying values from boot to boot, but also migration)? Or in
>> other words, if we found a need to relocate the M2P table or grow
>> its static maximum size, it would be impossible to migrate guests
>> from an old to a new hypervisor.
> 
> Fair point. There has to be a static fallback set of return values for old
> guests.

Hmm, in my reading the two sentences sort of contradict each other.
That is, I'm not certain what route we want to go here: Keep things
the way they are after 23706:3dd399873c9e, and introduce a
completely new discovery mechanism if we find it necessary to change
the M2P table's location and/or size, including a mechanism for a guest
to announce it's capable of dealing with that? If so, I think we ought
to add a comment to the hypercall implementation documenting that
its return values must not be changed (and why).

Jan

