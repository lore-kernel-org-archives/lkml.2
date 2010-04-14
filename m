Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755725Ab0DNX6t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 19:58:49 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51311
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751597Ab0DNX6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 19:58:47 -0400
Date: Wed, 14 Apr 2010 16:58:51 -0700 (PDT)
Message-Id: <20100414.165851.144419620.davem@davemloft.net>
To: dhowells@redhat.com
Cc: dvomlehn@cisco.com, to@dvomlehn-lnx2.corp.sa.net,
       linux-arch@vger.kernel.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, maint_arch@dvomlehn-lnx2.corp.sa.net
Subject: Re: [PATCH 1/23] Make register values available to panic notifiers
From: David Miller <davem@davemloft.net>
In-Reply-To: <28376.1271289134@redhat.com>
References: <20100412060609.GA25273@dvomlehn-lnx2.corp.sa.net>
	<24048.1271070978@redhat.com>
	<28376.1271289134@redhat.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Howells <dhowells@redhat.com>
Date: Thu, 15 Apr 2010 00:52:14 +0100

> David VomLehn <dvomlehn@cisco.com> wrote:
> 
>> > Can the use of va_start() clobber lots of registers, thereby rendering the
>> > exercise pointless on some arches?
>> >   
>>
>> The implementations I'm familiar with only need one or two registers. What
>> it *does* do is to force the contents of registers being used to pass
>> argument values onto the stack. This is roughly what gcc does for asm()
>> statements when you tell it registers are clobbered.
> 
> How about something like Sparc, where you can pass up to 8 arguments (if I
> remember correctly) in registers.  I'm not sure how Sparc handles varargs
> functions, though.

6 arguments, and all arguments get popped onto the stack into the
argument save area when doing varargs so you can access them as an
array.

Stack looks like:

	struct register_window	window;
	unsigned long args[...];
