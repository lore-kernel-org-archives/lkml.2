Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759067Ab1FVWSH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 18:18:07 -0400
Received: from smtp-out.google.com ([74.125.121.67]:2200 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758297Ab1FVWSF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 18:18:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=UeoGXaevJgndTkAWlB7dWn8ywZJLGiABQ8ZFuCcinoV/RDZsaL8eu9cjQf1rnbNKm+
         HUCjv9iK0q9gLwdng7cA==
MIME-Version: 1.0
In-Reply-To: <20110622093903.GA1981@aepfle.de>
References: <1308612129-12488-1-git-send-email-msb@chromium.org>
	<20110622093903.GA1981@aepfle.de>
Date: Wed, 22 Jun 2011 15:17:59 -0700
X-Google-Sender-Auth: 9l66Y8zVkLJ2DAURe-z1GJs1Hms
Message-ID: <BANLkTimc-+Zjtpz980bODMVL72OBWwQQNciEzs2ym-6HWADZag@mail.gmail.com>
Subject: Re: [PATCH 1/2] panic: panic=-1 for immediate reboot
From: Mandeep Singh Baines <msb@chromium.org>
To: Olaf Hering <olaf@aepfle.de>
Cc: linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Huang Ying <ying.huang@intel.com>, Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 22, 2011 at 2:39 AM, Olaf Hering <olaf@aepfle.de> wrote:
> On Mon, Jun 20, Mandeep Singh Baines wrote:
>
>> From: Hugh Dickins <hughd@chromium.org>
>>
>> When kernel BUG or oops occurs, ChromeOS intends to panic and immediately
>> reboot, with stacktrace and other messages preserved in RAM across reboot.
>> But the longer we delay, the more likely the user is to poweroff and lose
>> the info.
>
> I have no strong opinion here, but:
>
> Is delaying one second (instead of say 180 like on powerpc) such a big
> deal if the system is dead anyway?
>

Our kernel is configured to preserve the panic in RAM. So we don't get
any benefit in waiting. On the reboot following the crash, the panic gets
logged. If the user hits the power button instead of waiting for the panic,
we lose the crash data. For this reason, we even set our lockup
thresholds as low as we can.

Our system is almost stateless and our boot time is 8 seconds so a panic
reboot cycle is not so bad. But the quicker we can get the system
back up, the better.

Regards,
Mandeep

> Olaf
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
