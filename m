Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190Ab0H0Qpj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 12:45:39 -0400
Received: from enyo.dsw2k3.info ([195.71.86.239]:54919 "EHLO enyo.dsw2k3.info"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754070Ab0H0Qph (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 12:45:37 -0400
X-Greylist: delayed 454 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Aug 2010 12:45:37 EDT
Date: Fri, 27 Aug 2010 18:37:53 +0200
From: Matthias Schniedermeyer <ms@citd.de>
To: Eric Valette <Eric.Valette@Free.fr>
Cc: Phil Turmel <philip@turmel.org>, linux-kernel@vger.kernel.org,
        Florian Mickler <florian@mickler.org>
Subject: Re: Please add generic support for root=UUID= at kernel parameter
	command line (LABEL, BYID maybe also)
Message-ID: <20100827163753.GA13252@citd.de>
References: <4C728790.7050805@Free.fr> <4C72EE8F.3040708@turmel.org> <4C768919.30104@Free.fr> <4C76C641.30901@turmel.org> <4C77A89A.3070906@Free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C77A89A.3070906@Free.fr>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27.08.2010 13:59, Eric Valette wrote:
> On 08/26/2010 09:53 PM, Phil Turmel wrote:
>
>>
>>> Now I'm really puzzled grub2 as a "search by fs uuid" command that linux is unable to deliver for the root device!
>>
>> The key word here is "unable".  The maintainers aren't *unable* to do this.  They are *unwilling* to do this.  I don't recall the precise discussion, but basically it boils down to the fact that early userspace (aka initramfs) can do this efficiently, and it needs to be supported in initramfs for other reasons, so it is pointless to duplicate this code in the kernel.  I'm sure block folk will chime in if this isn't a fair representation (my apologies in advance if so).
>>
>> Try dracut.  Seriously.  It's lean and mean just for this use-case, and you'll be protecting yourself against future changes in the block layer.  And you can put root=LABEL=foo on your kernel command line to match your fstab.
>
>
> This is a rather bizarre argument as because of this situation
> 	1) the code is duplicated between the initramfs and the real disk

I don't really get what you mean.
But binary duplication isn't the issue, source-code duplication is.
I'd count an initramfs to the binary category. It is "compiled" more or 
less literaly.

> 	2) the initramfs has to be rebuild each time a new kernel is done

Only when you use kernel-modules, otherwise you should be fine for "some 
time".

> 	3) The tmpdevfs is also a dupplicate somehow

No.

devtmpfs uses tmpfs or ramfs as backing-store. And it doesn't really 
duplicate udev either, as it only does the bare minimum needed to get 
the computer to the point where udev can do the rest. Like when you have 
a root filesystem with no /dev at all.
(Which was kind of an chicken & egg-problem before.)





Bis denn

-- 
Real Programmers consider "what you see is what you get" to be just as 
bad a concept in Text Editors as it is in women. No, the Real Programmer
wants a "you asked for it, you got it" text editor -- complicated, 
cryptic, powerful, unforgiving, dangerous.

