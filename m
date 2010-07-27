Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823Ab0G0Rh6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 13:37:58 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:62276 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633Ab0G0Rh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 13:37:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=kUnC3Tmc3dX8/+W1MRJUbdXTiWOyNTrmE4b+LACBCz+G3Cgud5TjsApA6m/ALmPtnm
         LCPNq2yyuwkYDQPSBhuExuzeRV3owGF9bX7c8IH3x3No+2KS1Hf3FNhZGctR/n5EDwU4
         E6YhWuYNDZjX/cnyA911finMJjYXyINmyx0Pw=
Message-ID: <4C4F1969.5020305@garzik.org>
Date: Tue, 27 Jul 2010 13:37:45 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100720 Fedora/3.0.6-1.fc12 Thunderbird/3.0.6
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: mingo@elte.hu, tglx@linutronix.de, bphilips@suse.de, yinghai@kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        stern@rowland.harvard.edu, gregkh@suse.de, khali@linux-fr.org
Subject: Re: [PATCH 11/12] libata: use IRQ expecting
References: <1276443098-20653-1-git-send-email-tj@kernel.org> <1276443098-20653-12-git-send-email-tj@kernel.org> <4C23F6C1.7070603@garzik.org> <4C245E50.7090701@kernel.org> <4C2577F2.4030005@garzik.org> <4C25BAD2.4070705@kernel.org> <4C25C551.8000404@garzik.org> <4C25CC18.2070507@kernel.org> <4C2DFAB0.3020703@kernel.org>
In-Reply-To: <4C2DFAB0.3020703@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02/2010 10:41 AM, Tejun Heo wrote:
> Hello, Jeff.
>
> So, something like the following.  This should be applied on top of
> the two previous libata patches.  The amount of code in the hot path
> is very small.  Compared to the cpu actually taking an interrupt and
> accessing hardware, it should be negligible, and this will give us
> working and acceptably performing systems in the presence of most
> types of IRQ problems.
>
> Thanks.
>
> Subject: [PATCH] libata: use IRQ expecting
>
> Legacy ATA is very susceptible to IRQ delivery problems in both
> directions - lost and spurious interrupts.  In traditional PATA, the
> IRQ line is ultimately out of the controller and driver's control.
>
> Even relatively new SATA controllers share this problem as many still
> emulate the traditional IDE interface which doesn't have reliable way
> to indicate interrupt pending state and there also is an issue
> regarding the interpretation of nIEN on both sides of the cable.
>
> Controllers with native interface have fewer problems compared to the
> ones which use SFF but they still are affected by IRQ misrouting or
> broken MSI implementations.
>
> IRQ delivery problems on ATA are particularly nasty because it
> commonly hosts installation and/or booting.
>
> Most of these problems can be worked around by using the new IRQ
> expecting mechanism without adding any noticeable overhead.  In ATA,
> almost all operations are initiated by the host and the controller
> signals progress or completion using IRQ.  IRQ expecting can easily be
> added in libata core and applied to all libata drivers.
>
> Signed-off-by: Tejun Heo<tj@kernel.org>
> ---
>   drivers/ata/libata-core.c |   55 ++++++++++++++++++++++++++++++----------------
>   drivers/ata/libata-eh.c   |    4 ++-
>   drivers/ata/libata-sff.c  |   37 +++++++++++++++---------------
>   include/linux/libata.h    |    2 +
>   4 files changed, 60 insertions(+), 38 deletions(-)

I suppose the few cycles it costs are worth it...

Assuming this new version (from July 2) is tested,

Acked-by: Jeff Garzik <jgarzik@redhat.com>


