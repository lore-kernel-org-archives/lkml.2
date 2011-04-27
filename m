Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759685Ab1D0R0s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 13:26:48 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:44910 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754965Ab1D0R0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 13:26:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=chj1eo+HQnc6f82y7ZSguVHHRYLEIYyY+tSUIGIweaRiF4j+tXPPxx6r6Iz9Oy0T8b
         gPiuBbdecQiSChYus+WnBMhZJhQzyubW2hX9TOQKtayI8syIfAHahTIq5kVcjgPFQWMY
         jlsD63upfMFxUNj3MisDw0tmfKTZO07VloUEM=
Message-ID: <4DB851CE.7090503@gmail.com>
Date: Wed, 27 Apr 2011 21:26:38 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Don Zickus <dzickus@redhat.com>
CC: x86@kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] perf, nmi: Move LVT un-masking into irq handlers
References: <1303900353-10242-1-git-send-email-dzickus@redhat.com>
In-Reply-To: <1303900353-10242-1-git-send-email-dzickus@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/27/2011 02:32 PM, Don Zickus wrote:
> It was noticed that P4 machines were generating double NMIs for each
> perf event.  These extra NMIs lead to 'Dazed and confused' messages on
> the screen.
> 
> I tracked this down to a P4 quirk that said the overflow bit had to be
> cleared before re-enabling the apic LVT mask.  My first attempt was
> to move the un-masking inside the perf nmi handler from before the
> chipset NMI handler to after.
> 
> This broke Nehalem boxes that seem to like the unmasking before the
> counters themselves are re-enabled.
> 
> In order to keep this change simple for 2.6.39, I decided to just
> simply move the apic LVT un-masking to the beginning of all the
> chipset NMI handlers, with the exception of Pentium4's to fix the
> double NMI issue.
> 
> Later on we can move the un-masking to later in the handlers to save
> a number of 'extra' NMIs on those particular chipsets.
> 
> I tested this change on a P4 machine, an AMD machine, a Nehalem box,
> and a core2quad box.  'perf top' worked correctly along with various
> other small 'perf record' runs.  Anything high stress breaks all the
> machines but that is a different problem.
> 
> Thanks to various people for testing different versions of this patch.
> 
> Reported-and-tested-by: Shaun Ruffell <sruffell@digium.com>
> Signed-off-by: Don Zickus <dzickus@redhat.com>
> CC: Cyrill Gorcunov <gorcunov@gmail.com>
> 
> ---
> Originally I was going to bundle this with Cyrill's P4 alias patch but that
> may take awhile, so I am posting this stand alone for now.  Sorry for the
> delay.
> 

Looks good to me, thanks a lot Don! I'll send you updated alternate events
patch.

-- 
    Cyrill
