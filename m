Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756047Ab0HIJuA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 05:50:00 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61552 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755919Ab0HIJt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 05:49:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=mMinbvrP/RyMSri6Y1xcRlqf6GaW1IiosUtim9G8aV9L5DbqGAPuUILSStJaYp1pKo
         Lj79Jz7KSQhQve41GmgA9/EGYotk2VfgCbAmrfDk/JyvAmPPz5WWMDhFQm9I4E4Vnrm6
         qX+28Mp1Oh/DFoZWwPHLMXXQfWyXmvN4N6q1Q=
Message-ID: <4C5FCF0C.2000100@gmail.com>
Date: Mon, 09 Aug 2010 11:49:00 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Markus Trippelsdorf <markus@trippelsdorf.de>
CC: Heiko Carstens <heiko.carstens@de.ibm.com>, walt <w41ter@gmail.com>,
        linux-kernel@vger.kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH wq#for-linus] workqueue: workqueue_cpu_callback() should
 be cpu_notifier not hotcpu_notifier
References: <i3n3dh$t48$1@dough.gmane.org> <20100809063742.GA1632@arch.tripp.de> <20100809083053.GB2169@osiris.boeblingen.de.ibm.com> <20100809083451.GC2169@osiris.boeblingen.de.ibm.com> <4C5FC49B.9040208@kernel.org> <4C5FCC14.6030901@gmail.com> <20100809094630.GA1603@arch.tripp.de>
In-Reply-To: <20100809094630.GA1603@arch.tripp.de>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 08/09/2010 11:46 AM, Markus Trippelsdorf wrote:
> This fixes the boot problem here. Thanks.

Great.  May I add your Tested-by?

> (The drm delayed enqueue problem, which I mentioned earlier still
> persists.)

Yeah, I'm looking into it now but it looks like the error message is
simply spurious.  queue_delayed_work() returns 1 if the work was
actually queued and 0 if it was already pending and thus the function
call was no-op.  output_poll_execute() is incorrectly interpreting 1
return as error.  I'll look through the history and try to find out
whether/how wq changes affected the behavior, but the fix is most
likely simply killing the message.

Thanks.

-- 
tejun
