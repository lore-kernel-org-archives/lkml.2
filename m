Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053Ab0D1Lrf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 07:47:35 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:34608 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752244Ab0D1Lrd convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:2:1>);
	Wed, 28 Apr 2010 07:47:33 -0400
Message-Id: <4BD83C74020000780003C66C@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Wed, 28 Apr 2010 12:47:32 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Eric Anholt" <eric@anholt.net>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: intel_i830_chipset_flush(): local clflush() vs. global
	 wbinvd()
References: <4BD5787C020000780003C1DB@vpn.id2.novell.com>
 <8739ygwlf5.fsf@pollan.anholt.net>
In-Reply-To: <8739ygwlf5.fsf@pollan.anholt.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Eric Anholt <eric@anholt.net> 28.04.10 01:00 >>>
>On Mon, 26 Apr 2010 10:26:52 +0100, "Jan Beulich" <JBeulich@novell.com> wrote:
>> Eric, Brice,
>> 
>> what is the point of issuing wbinvd() on all CPUs here if clflush isn't
>> available, but using clflush() (if available) only on the current CPU?
>
>My reading of these two is that wbinvd affects this processor's cache
>lines, while clflush affects the cacheline regardless of which CPU owns
>it since they all share the same coherence domain.

Indeed, one can read it that way, although it seems unlikely to me that
it really means it (namely in large configurations the need to behave
that way may make clflush less preferable over wbinvd in some
situations). I'm trying to clarify this with Intel.

>Given that on many systems without CLFLUSH (8xx chipsets), we have
>issues with getting coherence to external memory successfully (note how
>neither of those instructions provide that!), I'm not sure it's a good
>time to be worrying about how to improve cache flushing performance on them!

No, the purpose of the question was not to hint at elimination of
the global wbinvd (which nevertheless could be reduced in scope),
but rather to find out why the same isn't needed on the clflush
path.

Jan

