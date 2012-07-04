Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751135Ab2GDMRf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 08:17:35 -0400
Received: from one.firstfloor.org ([213.235.205.2]:45131 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926Ab2GDMRc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 08:17:32 -0400
Date: Wed, 4 Jul 2012 14:17:26 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Srinivas_G_Gowda@Dell.com
Cc: minyard@acm.org, tcminyard@gmail.com, mjg59@srcf.ucam.org,
        andi@firstfloor.org, linux-kernel@vger.kernel.org,
        openipmi-developer@lists.sourceforge.net, jharg93@gmail.com
Subject: Re: [PATCH 1/1 v2 ] ipmi: Setting OS name as Linux in BMC
Message-ID: <20120704121726.GP11413@one.firstfloor.org>
References: <4FEC8931.5020001@dell.com> <4FEC8A28.4070806@dell.com> <m2k3yrgf4d.fsf@firstfloor.org> <20120629123001.GA26545@srcf.ucam.org> <4FEDBB3C.7080105@acm.org> <4FF3D090.8000403@dell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FF3D090.8000403@dell.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The intend of this patch was not to really workaround any issues, the aim was for the management software to use this data. 

.. use it to do something "Linux" specific right?

I think Corey summed it up pretty well in his previous comment. Management software associated with BMC usually use this information to let the users know about the OS that is using the BMC. Generally there are 3rd party application software that goes and pretty much fills up the OS env information and the management software uses this. My intend was why don't we get this information loaded by the driver itself. If there are applications that wants to rewrite it, so be it..! 
> Rather than just have a static entry such as 'Linux' I could probably write the version number and more(distro name etc.. ) 
> 
> Thoughts.. ? 

I still think "Linux" means nothing even to the management software.
What should it do with that?

If you provide some way for a distro to fill in "foobar linux 1.2.3.4"
maybe. But just Linux or even Linux x.y.z would be wrong because the same kernel 
version can behave very differently.

But it would be  better to define specific feature flags for
specific needs that actually mean something.

> I know there were some concerns with the security aspect, Can you please let me know what kind of security holes we could be looking at ? 

I don't think there are any security problems. just forward/backward
compatibility problems, as the ACPI experience shows.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
