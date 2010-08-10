Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932565Ab0HJSjw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 14:39:52 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59712 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932504Ab0HJSjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 14:39:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=IFdwvW5lnqe0CIo4NpAaw7CFXR/h7iADnio+puagJiz3E3F0q7tgUbKSOVDf9XQXJw
         gfMmyHklSeQo5w0hTMIlbvbo+EHl89SZ8eGX40rJsjHcYBd/odW86dM2/PsOMegu5PMg
         apYMkou6Hlv9qoWq9+Lm72UVUlDp4CecOZ9WE=
Message-ID: <4C619CF0.30609@gmail.com>
Date: Tue, 10 Aug 2010 20:39:44 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.8) Gecko/20100802 SUSE/3.1.2 Thunderbird/3.1.2
MIME-Version: 1.0
To: linux-acpi@vger.kernel.org
CC: Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Fan runs full speed after S3 sometimes (regression)
References: <4C613619.30309@gmail.com>
In-Reply-To: <4C613619.30309@gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/10/2010 01:20 PM, Jiri Slaby wrote:
> Hi,
> 
> till I was running on 2.6.34-rc5-mm1 (mmotm) and earlier everything was
> fine. Now, I'm running 2.6.35-rc6-mm1 (.35-rc5-mm1 was the same) and
> sometimes when the computer (desktop) returns from S3, the CPU fan is
> running at full speed making a big noise.

Just to add, full power cycle is needed to get rid of that. Warm reboot
is not enough.

> I don't know how to debug that. Bisection is out of question -- it
> happens once in 10 or 20 cases. There are no fan entries in /sys.
> 
> The load is as follows:
> $ while :; do cat /proc/loadavg; sleep 3; done
> 0.37 0.33 0.32 1/325 21358
> 0.42 0.34 0.32 1/325 21362
> 0.42 0.34 0.32 1/326 21366
> 0.38 0.33 0.32 1/330 21386
> 0.38 0.33 0.32 1/331 21391
> 0.35 0.33 0.32 1/331 21394
> 0.32 0.32 0.32 1/331 21397
> 0.32 0.32 0.32 1/331 21400
> 0.30 0.32 0.32 1/331 21403
> ...
> 
> I can boot into 34-rc5 to compare that if this is of relevance.
> 
> 290 kB kernel log since boot over several S3 sleep till now where the
> fan is noisy:
> http://www.fi.muni.cz/~xslaby/sklad/panics/boot.msg-fan_fullspeed
> 
> Should you need DSDT, it's there too:
> http://www.fi.muni.cz/~xslaby/sklad/panics/DSDT
> 
> Any ideas what could have caused this?
> 
> thanks,
-- 
js
