Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751898Ab0FFGWT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 02:22:19 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40072 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483Ab0FFGWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 02:22:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=RI93yeAvlQ2Ll+jcRcHF38MrJhIDWjPlGhSkm3Ltgw03nQc+5wuQ6yo0l4Ts7FA/My
         9gqQ5t1oMJjvaSwpIwbEvxYfhNuYXwsJDyk1XG08KrFayXlgYQ+6iVQYobpfO1DEK+U0
         sF3ulTamMtNGMJtnoxAeWivUkn8sSA5aVcPHk=
Message-ID: <4C0B3E94.6020506@gmail.com>
Date: Sun, 06 Jun 2010 08:22:12 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.4) Gecko/20100527 SUSE/3.1rc1-3.3 Thunderbird/3.1
MIME-Version: 1.0
To: Don Zickus <dzickus@redhat.com>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       linux-ide@vger.kernel.org
Subject: Re: hibernation hangs with ATA errors (lockup_detector bug)
References: <4C03C608.1040600@gmail.com> <20100601135004.GP15159@redhat.com> <4C051D44.7040203@gmail.com> <20100602184459.GA15159@redhat.com>
In-Reply-To: <20100602184459.GA15159@redhat.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/02/2010 08:44 PM, Don Zickus wrote:
> --- a/kernel/watchdog.c
> +++ b/kernel/watchdog.c
> @@ -550,8 +550,7 @@ cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
>  		break;
>  	case CPU_ONLINE:
>  	case CPU_ONLINE_FROZEN:
> -		if (watchdog_enable(hotcpu))
> -			return NOTIFY_BAD;
> +		watchdog_enable(hotcpu)

This fixes the problem indeed.

thanks,
-- 
js
