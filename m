Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866Ab2DBMDU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 08:03:20 -0400
Received: from smarthost1.greenhost.nl ([195.190.28.78]:59010 "EHLO
	smarthost1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752250Ab2DBMDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 08:03:15 -0400
Message-ID: <5f98ccc12c7887af855ff44700b528af.squirrel@webmail.greenhost.nl>
In-Reply-To: <AE90C24D6B3A694183C094C60CF0A2F6026B6ECF@saturn3.aculab.com>
References: <AE90C24D6B3A694183C094C60CF0A2F6026B6ECF@saturn3.aculab.com>
Date: Mon, 2 Apr 2012 22:03:12 +1000
Subject: RE: [RFC] net: bpf_jit: Two pass JIT and other changes
From: "Indan Zupancic" <indan@nul.nu>
To: "David Laight" <David.Laight@ACULAB.COM>
Cc: "Eric Dumazet" <eric.dumazet@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.22
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: 0.0
X-Scan-Signature: 739ba1b2be5fabc1cc6069058737919f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, April 2, 2012 19:28, David Laight wrote:
>
>> 1) Sadly, gcc isn't always smart enough to inline emit_code().
>>    So turn it into a macro to force gcc to inline it. This saves
>>    about 500 bytes. Tested with gcc 4.6.0. An alternative to the
>>    macro would be to create inline emit_code1(), emit_code2() etc.
>
> Does giving it the __attribute__((always_inline)) help?
> I had to mark a load of small static functions that way
> after a minor change (possibly to the overall size)
> stopped gcc inlining everything.

I did try that first, but it didn't work for some reason. Perhaps
the kernel uses some flag that overrides it when optimising for size.
Maybe plain -Os does that already, I don't know.

Greetings,

Indan


