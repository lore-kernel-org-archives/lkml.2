Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755501Ab0KCQQW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 12:16:22 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45140 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752777Ab0KCQQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 12:16:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=laElCdYGmA3AtT/PKt92yNuEkYY6dVlr2rfRNcfsanEBqF8XjyyKGHnK8dhJjkthvc
         513zCJhtWpxMSAF3iHjbDMDCfPdqY0Q7u8QU2Ar/6uNPtHIhsXQ0f06BgvkzYfCiXHsI
         49XFKwI55YfTi6/q3u41vDwG9cjubHJymk/o4=
Message-ID: <4CD18ACB.4060108@suse.cz>
Date: Wed, 03 Nov 2010 17:16:11 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.12) Gecko/20101026 SUSE/3.1.6 Thunderbird/3.1.6
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        jirislaby@gmail.com, "[cleanups]"@suse.de,
        "Dr. Werner Fink" <werner@suse.de>, Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 1/1] console: add /proc/consoles
References: <1288798509-23550-1-git-send-email-jslaby@suse.cz> <20101103161342.GA4942@suse.de>
In-Reply-To: <20101103161342.GA4942@suse.de>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/03/2010 05:13 PM, Greg KH wrote:
> On Wed, Nov 03, 2010 at 04:35:09PM +0100, Jiri Slaby wrote:
>> It allows users to see what consoles are currently known to the system
>> and with what flags.
>>
>> It is based on Werner's patch, the part about traversing fds was
>> removed, the code was moved to kernel/printk.c, where consoles are
>> handled and it makes more sense to me.
> 
> Why kernel/printk.c?  I don't think that makes sense, it's just a random
> proc file, so why not put it into something like fs/proc/ instead?
> 
> Does it rely on any functions in the printk.c file?

No it doesn't. I will move it to fs/proc/ if that's preferred. I checked
how VM proc stuff is handled and it was in in mm/, so I put this into
kernel/...

(Then it will depend on the console cleanup series which I sent few
minutes ago...)

thanks,
-- 
js
suse labs
