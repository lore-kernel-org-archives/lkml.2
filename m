Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759950Ab1D3VNO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 17:13:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48154 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754091Ab1D3VNN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 17:13:13 -0400
Date: Sat, 30 Apr 2011 23:13:10 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Harry Wei <jiaweiwei.xiyou@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, greg@kroah.com,
        joe@perches.com, randy.dunlap@oracle.com
Subject: Re: [Oops 1/2]Something wrong with copy_from_user() function
In-Reply-To: <20110430061336.GA4274@gmail.com>
Message-ID: <alpine.LNX.2.00.1104302311530.12035@pobox.suse.cz>
References: <20110430061336.GA4274@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 30 Apr 2011, Harry Wei wrote:

> Hi us,
> 	When i was compiling 2.6.38.2 kernel. Something wrong happend to me.
> It shows like following.
> 
> [...]
> Warning: call to 'copy_from_user_overflow' declared with attribute warning:
> copy_from_user buffer size is not provably correct.
> [...]
> 
> See http://s1202.photobucket.com/albums/bb364/harrywei/Kernel/?action=view&current=report_bug.png for details.
> 	I tried to fix this warning, but i don't know how to deal with
> it. Can anyone help me.

wpa_set_keys() function (from staging drivers) in your kernel uses 
copy_from_user() without proper bounds checking, and thus can overflow and 
corrupt memory.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
