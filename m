Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755276Ab0KXTnR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 14:43:17 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45724 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753305Ab0KXTnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 14:43:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=VuwQcztRcrITqO9Z2G8VuxPMSG7ngoi53/iRMVodkyr+uRWTvwy3sCDbde+PfIdnSB
         1xm+MwV2FUz1m8GCpqAzbduuA4oKCXJ/1y5TjGnfFj7yGdidyYfrcCaUv2e31O//ecI+
         WY+EVrFQljmEA24SMkOCI8xWVm6x6fbZF6ZmM=
Message-ID: <4CED6ACF.9000402@suse.cz>
Date: Wed, 24 Nov 2010 20:43:11 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.12) Gecko/20101026 SUSE/3.1.6 Thunderbird/3.1.6
MIME-Version: 1.0
To: Sergey Lapin <slapin@ossfans.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: ldisc problems with 2.6.32-2.6.37-rc2 (at least)
References: <20101124135249.GA7282@build.ihdev.net> <4CED2251.3020708@suse.cz> <20101124170326.GB7282@build.ihdev.net>
In-Reply-To: <20101124170326.GB7282@build.ihdev.net>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/24/2010 06:03 PM, Sergey Lapin wrote:
>> Hi, I don't think you get similar backtraces in .37-rc2. Could you grab one?
> 
> Yeah, they are different definitely.

Weird, actually, it's the same warning. I cannot see how this can happen
though. The code looks like:
        tty_ldisc_close(tty, o_ldisc);

        /* Now set up the new line discipline. */
        tty_ldisc_assign(tty, new_ldisc);
        tty_set_termios_ldisc(tty, ldisc);

        retval = tty_ldisc_open(tty, new_ldisc);


Could you provide disassembly of tty_set_ldisc? E.g. by extracting it from:
objdump -d drivers/tty/tty_ldisc.o

thanks,
-- 
js
suse labs
