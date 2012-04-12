Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762446Ab2DLTYz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 15:24:55 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:40579 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756171Ab2DLTYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 15:24:54 -0400
Date: Thu, 12 Apr 2012 15:23:25 -0400 (EDT)
Message-Id: <20120412.152325.787400025475295618.davem@davemloft.net>
To: sam@ravnborg.org
Cc: mmarek@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix modpost failures in fedora 17
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120412191304.GA30472@merkur.ravnborg.org>
References: <20120412.143730.258982831585270742.davem@davemloft.net>
	<20120412191304.GA30472@merkur.ravnborg.org>
X-Mailer: Mew version 6.4 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 12 Apr 2012 12:23:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sam Ravnborg <sam@ravnborg.org>
Date: Thu, 12 Apr 2012 21:13:04 +0200

> On Thu, Apr 12, 2012 at 02:37:30PM -0400, David Miller wrote:
>> 
>> The symbol table on x86-64 starts to have entries that have names
>> like:
>> 
>> _GLOBAL__sub_I_65535_0___mod_x86cpu_device_table
>> 
>> They are of type STT_FUNCTION and this one had a length of 18.  This
>> matched the device ID validation logic and it barfed because the
>> length did not meet the device type's criteria.
>> 
>> --------------------
>> FATAL: arch/x86/crypto/aesni-intel: sizeof(struct x86cpu_device_id)=16 is not a modulo of the size of section __mod_x86cpu_device_table=18.
>> Fix definition of struct x86cpu_device_id in mod_devicetable.h
>> --------------------
>> 
>> These are some kind of compiler tool internal stuff being emitted and
>> not something we want to inspect in modpost's device ID table
>> validation code.
>> 
>> So skip the symbol if it is not of type STT_OBJECT.
>> 
>> Signed-off-by: David S. Miller <davem@davemloft.net>
> Acked-by: Sam Ravnborg <sam@ravnborg.org>
> 
> I assume this is stable material too?

Yes.

> In other words we should add:
> Cc: stable@vger.kernel.org

Indeed, we should.
