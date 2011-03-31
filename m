Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757673Ab1CaNs3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 09:48:29 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45904 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861Ab1CaNs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 09:48:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=t1KeChvxYbkbb7h1msZKGDlbL6xYEkB5cOZrIgY9iyJ8FssxrtKI+B9RU+7DxZS/SQ
         +uqbmO/I7E2cN6xBXaepKRajqr0T+uU2dbgROMEXiIOVWqVZD5KkD0V3exFDMxCeFwED
         q88mT84TKiiBIudaftMgXN/LBq76JGceezVhs=
Message-ID: <4D948624.3040605@suse.cz>
Date: Thu, 31 Mar 2011 15:48:20 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Arend van Spriel <arend@broadcom.com>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, rmk+kernel@arm.linux.org.uk,
        devel@linuxdriverproject.org, gregkh@suse.de,
        linux-wireless@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH 1/1] drivers: brcmaxi: provide amba axi functionality
 in separate module
References: <1301391619-4499-1-git-send-email-arend@broadcom.com> <1301391619-4499-2-git-send-email-arend@broadcom.com> <4D91B856.8040302@suse.cz> <201103301453.48607.arnd@arndb.de>
In-Reply-To: <201103301453.48607.arnd@arndb.de>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/30/2011 02:53 PM, Arnd Bergmann wrote:
> On Tuesday 29 March 2011, Jiri Slaby wrote:
>> On 03/29/2011 11:40 AM, Arend van Spriel wrote:
>>> --- /dev/null
>>> +++ b/drivers/brcmaxi/axi.c
>>> @@ -0,0 +1,786 @@
>> ...
>>> +/* resetctrl */
>>> +#define	AIRC_RESET		1
>>> +
>>> +/* definition for specifying padding fields */
>>> +#define	_PADLINE(line)	pad ## line
>>> +#define	_XSTR(line)	_PADLINE(line)
>>> +#define	PAD		_XSTR(__LINE__)
>>> +
>>> +/*
>>> + * struct aidmp - device management plugin "wrapper" registers.
>>> + */
>>> +struct aidmp {
>>
>> This looks like it should be __packed__.
> 
> Why that? Adding the packed attribute would enforce byte access but
> not change the layout of the structure, so I think that would make
> it worse not better.

How it can? Packed only tells the compiler to have one byte alignment
steps. And it should not matter here as all the members are 32-bit long.

The structure seems to be something which maps to device registers. So
for documentation purposes it should be packed. And to avoid later
mistakes when the u32 are broken down to u8s and u16s.

regards,
-- 
js
suse labs
