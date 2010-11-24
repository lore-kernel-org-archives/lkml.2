Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486Ab0KXWCw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 17:02:52 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:50700 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353Ab0KXWCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 17:02:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=BA9nsPmJ0H9RmJTm8/xUiCR+McET5Fj79ben+I6tvERXgLhhX6jcraP+nYYq8UBheZ
         DvJJa2/Sx35dKJHbwJPFTlq9Prrag/aRp/9dDfFbdf3rnUfFAav9FWJjc9gzzuNLID6n
         oHlD6lFwba9Y7vS+qYKE1G0rp673Vt+lQsmyY=
Message-ID: <4CED8B86.6070607@suse.cz>
Date: Wed, 24 Nov 2010 23:02:46 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.12) Gecko/20101026 SUSE/3.1.6 Thunderbird/3.1.6
MIME-Version: 1.0
To: Sergey Lapin <slapin@ossfans.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: ldisc problems with 2.6.32-2.6.37-rc2 (at least)
References: <20101124135249.GA7282@build.ihdev.net> <4CED2251.3020708@suse.cz> <20101124170326.GB7282@build.ihdev.net> <4CED6ACF.9000402@suse.cz> <4CED6B53.50408@suse.cz> <20101124215339.GA8691@build.ihdev.net>
In-Reply-To: <20101124215339.GA8691@build.ihdev.net>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/24/2010 10:53 PM, Sergey Lapin wrote:
> Initially I run it, everything is ok.
> Then I run it and get error and backtrace.
> And if I run it again, everything is ok again, repeatedly. Probably some resources are properly
> set up in error condition, and not in normal condition.
> 
> I use ARM machine for testing and x86, bug is architecture-independent.
> 
> addr2lines:
> c01bc110 drivers/tty/tty_ldisc.c:499

Got it. Does this fixes the warning?
--- a/drivers/tty/tty_ldisc.c
+++ b/drivers/tty/tty_ldisc.c
@@ -454,6 +454,8 @@ static int tty_ldisc_open(struct tty_struct *tty,
struct tty_ldisc *ld)
                 /* BTM here locks versus a hangup event */
                WARN_ON(!tty_locked());
                ret = ld->ops->open(tty);
+               if (ret)
+                       clear_bit(TTY_LDISC_OPEN, &tty->flags);
                return ret;
        }
        return 0;

thanks,
-- 
js
suse labs
