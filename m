Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134Ab0IVGcv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 02:32:51 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:52274 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543Ab0IVGct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 02:32:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ITLAXoP3T/BMka4ZpA+ti92FkvT7iRDEYKg2jHJju4q5BG3h9x/JGbQggbRMhU15S6
         jid+3spTaj/7PzUSoBl/48VMsLGCPd6mJc7QsATi5v07SIMuLLlchTF5Ig/vaK9VDq7x
         gAPdjRyeusJNDZRWqgV/3jshhWHgngGwjHW/w=
Date: Wed, 22 Sep 2010 10:32:44 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Valdis.Kletnieks@vt.edu, Richard Purdie <rpurdie@rpsys.net>,
        Chris Ball <cjb@laptop.org>, Hein_Tibosch <hein_tibosch@yahoo.es>,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org
Subject: Re: mmotm 2010-09-15 - BUG in mmc driver calling
 led_trigger_event()
Message-ID: <20100922063244.GA19324@oksana.dev.rtsoft.ru>
References: <201009152352.o8FNqXGr022752@imap1.linux-foundation.org>
 <8581.1285124507@localhost>
 <20100921201758.66841897.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100921201758.66841897.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 21, 2010 at 08:17:58PM -0700, Andrew Morton wrote:
[...]
> led_trigger_event() does read_lock() then calls led_set_brightness()
> which indirectly calls sdhci_led_control() which does mutex_lock().  
> 
> That mutex_lock() was added by sdhci-turn-host-lock-into-a-mutex.patch.
> 
> Anton, those patches aren't going very well - I think I'll drop

Yep, please drop it.

Thanks,

> sdhci-turn-timeout-timer-into-delayed-work.patch
> sdhci-use-work-structs-instead-of-tasklets.patch
> sdhci-use-work-structs-instead-of-tasklets-fix.patch
> sdhci-clear-interrupt-status-register-just-once.patch
> sdhci-use-threaded-irq-handler.patch
> sdhci-turn-host-lock-into-a-mutex.patch
> sdhci-get-rid-of-card-detect-work.patch
> sdhci-get-rid-of-card-detect-work-fix.patch
> sdhci-get-rid-of-mdelays-where-it-is-safe-and-makes-sense.patch
> sdhci-use-jiffies-instead-of-a-timeout-counter.patch
> 

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
