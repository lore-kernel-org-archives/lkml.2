Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758058Ab2CLXTw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 19:19:52 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:57799 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756789Ab2CLXTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 19:19:51 -0400
Message-ID: <4F5E8491.70403@gmail.com>
Date: Tue, 13 Mar 2012 10:19:45 +1100
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.27) Gecko/20120216 Lightning/1.0b2 Thunderbird/3.1.19
MIME-Version: 1.0
To: shuahkhan@gmail.com
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: simple_strtoull() - FIXME?
References: <1331569011.4386.15.camel@lorien2>
In-Reply-To: <1331569011.4386.15.camel@lorien2>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/03/12 03:16, Shuah Khan wrote:

> What's this FIXME in simple_strtoull() for? Something to be terribly
> concerned about and need fixing (assuming there is something that still
> needs fixing)
> 
> unsigned long long simple_strtoull(const char *cp, char **endp, unsigned
> int base)
> {
>         unsigned long long result;
>         unsigned int rv;
> 
>         cp = _parse_integer_fixup_radix(cp, &base);
>         rv = _parse_integer(cp, base, &result);
>         /* FIXME */


git blame/show answers your question. From the commit message of
1dff46d6: lib/kstrtox: common code between kstrto*() and simple_strto*()
functions:

 simple_strtoull() (and scanf(), BTW) ignores integer overflow, that's a
 bug we currently don't have guts to fix, making KSTRTOX_OVERFLOW hack
 necessary.

Note that simple_strtoull and friends are now deprecated (see
include/linux/kernel.h) and you should now be using the kstrto*
functions instead.

~Ryan

