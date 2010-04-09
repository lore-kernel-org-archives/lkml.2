Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756090Ab0DITqO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 15:46:14 -0400
Received: from tex.lwn.net ([70.33.254.29]:58170 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755439Ab0DITqN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 15:46:13 -0400
Date: Fri, 9 Apr 2010 13:46:10 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: linux-kernel@vger.kernel.org, Harald Welte <laforge@gnumonks.org>,
       JosephChan@via.com.tw, ScottFang@viatech.com.cn,
       Deepak Saxena <dsaxena@laptop.org>,
       linux-fbdev-devel@lists.sourceforge.net
Subject: Re: [PATCH 02/16] viafb: use proper pci config API
Message-ID: <20100409134610.0b610f93@bike.lwn.net>
In-Reply-To: <4BBE2389.5010802@gmx.de>
References: <1270746946-12467-1-git-send-email-corbet@lwn.net>
	<1270746946-12467-3-git-send-email-corbet@lwn.net>
	<4BBE2389.5010802@gmx.de>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 08 Apr 2010 20:42:17 +0200
Florian Tobias Schandinat <FlorianSchandinat@gmx.de> wrote:

> something I am wondering about is whether we can't simply do:
> viaparinfo->memsize = pci_resource_len(pdev, 0);
> I suppose that this is not possible meaning that the pci len can be 
> longer than the actual memory but I just wanted to use the moment to 
> make sure.

That would make sense.  But if somebody who is closer to the hardware than
I am doesn't take that approach, I'm nervous about changing it.  Harald?

> This function was not designed to return an error (memsize is not 
> checked). Either return a default value (let's say 8MB) or add a check 
> for memsize.

That's a good point.  I put in a check.

Thanks,

jon
