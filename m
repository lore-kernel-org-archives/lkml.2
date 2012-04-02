Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383Ab2DBRat (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 13:30:49 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:44090 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859Ab2DBRar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 13:30:47 -0400
Message-ID: <4F79E242.5090300@suse.cz>
Date: Mon, 02 Apr 2012 19:30:42 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120331 Thunderbird/13.0a2
MIME-Version: 1.0
To: simon@mungewell.org
CC: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>, Michael Bauer <michael@m-bauer.org>,
        Michal Maly <madcatxster@gmail.com>
Subject: Re: [PATCH 1/2] HID: hid-lg4ff: Use Private Data
References: <a4e40aa5c43be934d83240849aa25f3b.squirrel@mungewell.org>    <1333378444-3117-1-git-send-email-simon@mungewell.org>    <4F79D486.5090605@suse.cz> <44acbf3ff0b6aa62eab2831ee6ecea80.squirrel@mungewell.org>
In-Reply-To: <44acbf3ff0b6aa62eab2831ee6ecea80.squirrel@mungewell.org>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2012 07:01 PM, simon@mungewell.org wrote:
> 
>>> +	struct lg4ff_device_entry *uninitialized_var(entry);
>>> +	struct lg_drv_data *uninitialized_var(drv_data);
>>
>> You don't need uninitialized_var bloat anymroe, right?
> 
> I guess I don't fully understand the 'unitialized_var()' macro, and was
> just following the previous uses in the code.
> 
> Google'ing doesn't really help either. Is there a definitive guide as when
> to use and not?

The simple answer is: never.

It serves the purpose to shut up the compiler when it complains that the
variable might be uninitialized, but the programmer is sure it cannot.
In your case, the compiler should not even complain about that.

Advantage of the macro is that it adds no assembly, but still silents
the compiler.

thanks,
-- 
js
suse labs


