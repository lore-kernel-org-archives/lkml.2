Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751803Ab0KYMHR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 07:07:17 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42732 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919Ab0KYMHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 07:07:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=OhfFV9aSzUvuKjDcXYhxJzbCZpkZvrIOlQ8u2XiP8z2KKfGLuAWFdyLk5euMye+gzU
         WiCSVYAfRhHouBmpiKl4WwQWPdqUZ95Z4PkDvDcfEncHFm+mWr00uQceLyVQ3su1XWZr
         egf8SebmEK0T1S+vXrx4GLATRYLox75onyNzE=
Message-ID: <4CEE516E.6010006@gmail.com>
Date: Thu, 25 Nov 2010 13:07:10 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.12) Gecko/20101026 SUSE/3.1.6 Thunderbird/3.1.6
MIME-Version: 1.0
To: Andrew Hendry <andrew.hendry@gmail.com>
CC: davem@davemloft.net, netdev@vger.kernel.org, slapin@ossfans.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] NET: wan/x25_asy, move lapb_unregister to x25_asy_close_tty
References: <1290642894-4577-1-git-send-email-jslaby@suse.cz> <AANLkTi=DEHOKkrvzHUBnW+rAkGz-uhizRqZb2PAuh4k-@mail.gmail.com>
In-Reply-To: <AANLkTi=DEHOKkrvzHUBnW+rAkGz-uhizRqZb2PAuh4k-@mail.gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2010 12:37 PM, Andrew Hendry wrote:
> Sorry I haven't used this driver so can't fully test it. Looks
> straightforward and compile tested ok.
> 
> On Thu, Nov 25, 2010 at 10:54 AM, Jiri Slaby <jslaby@suse.cz> wrote:
>> We register lapb when tty is created, but unregister it only when the
>> device is UP. So move the lapb_unregister to x25_asy_close_tty after
>> the device is down.

I forgot to mention what it causes. The commit message should add:
The old behaviour causes ldisc switching to fail each second attempt,
because we noted for us that the device is unused, so we use it the
second time, but labp layer still have it registered, so it fails
obviously.

thanks,
-- 
js
