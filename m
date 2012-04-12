Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755880Ab2DLTNI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 15:13:08 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:46471 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752737Ab2DLTNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 15:13:07 -0400
Date: Thu, 12 Apr 2012 21:13:04 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: David Miller <davem@davemloft.net>, Michal Marek <mmarek@suse.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix modpost failures in fedora 17
Message-ID: <20120412191304.GA30472@merkur.ravnborg.org>
References: <20120412.143730.258982831585270742.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120412.143730.258982831585270742.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2012 at 02:37:30PM -0400, David Miller wrote:
> 
> The symbol table on x86-64 starts to have entries that have names
> like:
> 
> _GLOBAL__sub_I_65535_0___mod_x86cpu_device_table
> 
> They are of type STT_FUNCTION and this one had a length of 18.  This
> matched the device ID validation logic and it barfed because the
> length did not meet the device type's criteria.
> 
> --------------------
> FATAL: arch/x86/crypto/aesni-intel: sizeof(struct x86cpu_device_id)=16 is not a modulo of the size of section __mod_x86cpu_device_table=18.
> Fix definition of struct x86cpu_device_id in mod_devicetable.h
> --------------------
> 
> These are some kind of compiler tool internal stuff being emitted and
> not something we want to inspect in modpost's device ID table
> validation code.
> 
> So skip the symbol if it is not of type STT_OBJECT.
> 
> Signed-off-by: David S. Miller <davem@davemloft.net>
Acked-by: Sam Ravnborg <sam@ravnborg.org>

I assume this is stable material too?
In other words we should add:
Cc: stable@vger.kernel.org

Michal - I assume you take this.

	Sam
