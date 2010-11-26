Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397Ab0KZHqZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 02:46:25 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33115 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542Ab0KZHqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 02:46:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=II2L1NpzoJQojAfbcyJJe0e++aXegO56V4t6fLdxwChq6ZGWFn9U4R/cERmH0SWnLW
         MEVNsSt76fFvzXp41r609Ju2G1W8lRIu5pp8E4PuaFF5CUpLm7rjpwuT7Mmgsh9dWfR+
         Cmg8Nez1/SJej5klLTaMEOnUo0X5kYfUDpB6U=
Message-ID: <4CEF65CA.9020403@suse.cz>
Date: Fri, 26 Nov 2010 08:46:18 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.12) Gecko/20101026 SUSE/3.1.6 Thunderbird/3.1.6
MIME-Version: 1.0
To: Kyle McMartin <kyle@mcmartin.ca>
CC: Jiri Slaby <jslaby@suse.cz>, gregkh@suse.de, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 1/1] TTY: don't allow reopen when ldisc is changing
References: <4CEE93FF.3040507@suse.cz> <1290705383-6608-1-git-send-email-jslaby@suse.cz> <20101126002840.GL22651@bombadil.infradead.org>
In-Reply-To: <20101126002840.GL22651@bombadil.infradead.org>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2010 01:28 AM, Kyle McMartin wrote:
> On Thu, Nov 25, 2010 at 06:16:23PM +0100, Jiri Slaby wrote:
>> -	if (test_bit(TTY_CLOSING, &tty->flags))
>> +	if (test_bit(TTY_CLOSING, &tty->flags) ||
>> +			test_bit(TTY_LDISC_CHANGING, &tty->flags))
>>  		return -EIO;
>>  
>>  	if (driver->type == TTY_DRIVER_TYPE_PTY &&
> 
> Unfortunately, users report this doesn't seem to fix things for them
> (built against 2.6.36 (plus another patch you wrote iirc.))

Which patches exactly do you have? You need three of mine in 2.6.36.

> https://bugzilla.redhat.com/show_bug.cgi?id=630464#c27

regards,
-- 
js
suse labs
