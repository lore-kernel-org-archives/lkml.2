Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756543Ab0ELWQI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 18:16:08 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:2011 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756394Ab0ELWQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 18:16:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:references:x-url:x-pgp-fp:x-pgp:date
         :in-reply-to:message-id:user-agent:mime-version:content-type;
        b=V+KpdTMM/p9WIWTQLvFL/+5rQGwUJtGx4M4bWs//kAL9m9J6FSaeFs4BZsvJPQuLrp
         aMqkJ/oB8CiZos4+LSCIkKdsi8/0A6G9v4jO6iEUrjMsphPNOqKY+aEeSO46TU2N3hkI
         KR8f/dE0+exOazdt/M2dkFYORIuHHet/Cil+U=
From: Michal Nazarewicz <mina86@mina86.com>
To: Greg KH <greg@kroah.com>
Cc: Michal Nazarewicz <m.nazarewicz@samsung.com>, linux-usb@vger.kernel.org,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       Viral Mehta <Viral.Mehta@lntinfotech.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: gadget: f_mass_storage: fix in error recovery
References: <994e1bf34d3b6f1fbc58c0f7ce61c7f258208ddd.1273651956.git.mina86@mina86.com>
	<70376CA23424B34D86F1C7DE6B9973430254343ABA@VSHINMSMBX01.vshodc.lntinfotech.com>
	<op.vck4q0c87p4s8u@pikus>
	<70376CA23424B34D86F1C7DE6B9973430254343ABB@VSHINMSMBX01.vshodc.lntinfotech.com>
	<70376CA23424B34D86F1C7DE6B9973430254343ABC@VSHINMSMBX01.vshodc.lntinfotech.com>
	<op.vck7aofj7p4s8u@pikus>
	<70376CA23424B34D86F1C7DE6B9973430254343ABF@VSHINMSMBX01.vshodc.lntinfotech.com>
	<1148fb1fcb3a9864a2a12fbbf2e3444827c9ed4a.1273661077.git.mina86@mina86.com>
	<20100512213938.GA27648@kroah.com>
X-Url: http://mina86.com/
X-PGP-FP: 9134 06FA 7AD8 D134 9D0C  C33F 532C CB00 B7C6 DF1E
X-PGP: B7C6DF1E
Date: Thu, 13 May 2010 00:16:00 +0200
In-Reply-To: <20100512213938.GA27648@kroah.com> (Greg KH's message of "Wed, 12
	May 2010 14:39:38 -0700")
Message-ID: <87sk5wahr3.fsf@erwin.mina86.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/24.0 (Slckware Linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, May 12, 2010 at 12:51:13PM +0200, Michal Nazarewicz wrote:
>> In to places in fsg_common_init() an unconditional call to kfree()
>> on common was performed in error recovery which is not a valid
>> behaviour since fsg_common structure is not always allocated by
>> fsg_common_init().
>> 
>> To fix, the calls has been replaced with a goto to a proper error
>> recovery which does the correct thing.
>> 
>> Also, refactored fsg_common_release() function.
>> 
>> Signed-off-by: Michal Nazarewicz <mina86@mina86.com>

Greg KH <greg@kroah.com> writes:
> Does this superseed your previous patch in this thread?

Yes. 

The difference is with fsg_common_release() function which is
purely a style change.

-- 
Best regards,                                         _     _
 .o. | Liege of Serenly Enlightened Majesty of      o' \,=./ `o
 ..o | Computer Science,  Michal "mina86" Nazarewicz   (o o)
 ooo +--<mina86-tlen.pl>--<jid:mina86-jabber.org>--ooO--(_)--Ooo--
