Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756367Ab2JQInY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 04:43:24 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:65435 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753394Ab2JQInW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 04:43:22 -0400
Date: Wed, 17 Oct 2012 10:43:20 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: linux-kernel@vger.kernel.org
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [Q] reprobe deferred-probing drivers
In-Reply-To: <Pine.LNX.4.64.1210171021060.7402@axis700.grange>
Message-ID: <Pine.LNX.4.64.1210171039410.7402@axis700.grange>
References: <Pine.LNX.4.64.1210171021060.7402@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:YQlQeha+TxMLlPcTp/phzroqsIAyVr89f5mF+jvdhuQ
 zrIiHkPSlLqSVrKF64c+4Yfpk0Eb6j4QQ2WXJSxdSi0zIrEvpY
 T/nvxvqFVZN/KLEfnw2taQ/N79oDgPqlJ45Gw8uLSnYe0/ROsV
 /TWyQGAWKLjhKi8/01rzoLTpWvHs+ZrP6gTFEodgx0LTxKyPZB
 7IJ697+crr8/e0QSReOYxgBAIlgUpTrKyIK/zUZzVaXmg3UZnG
 8NTSYVEjsF7cyazcjXjVLv5oP12rSAY4R9EhQkLfu4saplyBsd
 HHUs71hg6I1mZIe2+UTyFZ8w/F8w4TwUI4g+lcgjwCD9tBEN6C
 34tdbJn7FPU2L4MJ3TwDvbbjkEymjiPwLoOY+b11vBnwa0J/DW
 LZKfnzn/9A/lQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Oct 2012, Guennadi Liakhovetski wrote:

> Hi
> 
> I've got a situation, for which I currently don't have a (good) solution.

Ok, right, would it be acceptable to just do something like

		if (dev->parent)
			device_lock(dev->parent);
		device_release_driver(dev);
		device_attach(dev);

?

Thanks
Guennadi

> Let's say device A depends on device B and as long as B hasn't probed, A 
> requests deferred probing. Now B probes, which causes A to also succeed 
> its probing. Next we want to remove B, say, by unloading its driver. A has 
> to go back into "deferred-probing" state. How do we do it? This can be 
> achieved by unloading B's driver and loading again. Essentially, we have 
> to use the sysfs "unbind" and then the "bind" attributes. But how do we do 
> this from the kernel? Shall we export driver_bind() and driver_unbind()?

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
