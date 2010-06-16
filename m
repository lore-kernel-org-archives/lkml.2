Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756761Ab0FPJkP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 05:40:15 -0400
Received: from one.firstfloor.org ([213.235.205.2]:46544 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249Ab0FPJkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 05:40:12 -0400
Date: Wed, 16 Jun 2010 11:40:10 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Nils Carlson <nils.carlson@ludd.ltu.se>
Cc: Andi Kleen <andi@firstfloor.org>, Doug Thompson <norsk5@yahoo.com>,
       Tony Luck <tony.luck@intel.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>, Borislav Petkov <bp@amd64.org>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       BrentYoung <brent.young@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "bluesmoke-devel@lists.sourceforge.net" 
	<bluesmoke-devel@lists.sourceforge.net>,
       Doug Thompson <dougthompson@xmission.com>,
       Joe Perches <joe@perches.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Edac Mailing List <linux-edac@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>, Matt Domsch <Matt_Domsch@dell.com>,
       Nils Carlson <nils.carlson@ericsson.com>
Subject: Re: Hardware Error Kernel Mini-Summit
Message-ID: <20100616094010.GC17599@basil.fritz.box>
References: <AANLkTil_mDFOsDUjvnp_NFZvkj0Ij-qww6BqewJ4lpHP@mail.gmail.com> <35525.41387.qm@web50105.mail.re2.yahoo.com> <20100615065630.GC6727@basil.fritz.box> <Pine.GSO.4.58.1006150951150.17579@dexter.ludd.ltu.se> <20100615114135.GH6727@basil.fritz.box> <Pine.GSO.4.58.1006151411370.17929@dexter.ludd.ltu.se> <20100615193519.GA12845@basil.fritz.box> <3B694326-F435-4A54-AC36-AE059AD9161D@ludd.ltu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3B694326-F435-4A54-AC36-AE059AD9161D@ludd.ltu.se>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Could you maybe give me an example from the board of your choosing
> of a DMI table print out, explain the format and then show how to use it?

The only requirement the current mcelog parser has is
(that is what it actually uses, it parses more things but I abandoned
them):

- List of DIMMs (type 17) 
- It's useful if they have the correct size for display to the user.
- Correct serial/part numbers/manufacturer are also useful (for display), but
not strictly required.
- Locator should match the silk screen label of the DIMM on the board
- Bank Locator is in the format prefix_Node%u_Channel%u_Dimm%u
prefix can be arbitary, but should not contain '_'
Node matching SOCKETID coming from CPU, Channel matching Channel, Dimm
matching Dimm number from CPU.
This requirement is the only extension over the standard.

-Andi
