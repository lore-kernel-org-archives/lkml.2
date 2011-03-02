Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765Ab1CBHpZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 02:45:25 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:57109 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264Ab1CBHpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 02:45:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=sTyH4mJ3CSSGxiaN9RkBY5wd/t6uRoY/r3qCob5GEVJVR0hvH3Pvu91xAa9mQlbz0w
         TfA/7ZNpPLck0P0bky+HSasCfOxS0S59u4wDvAOCXoMk8kAiieveg2J5glwhGlY6+861
         OTVXWUfEm/vzwtiqlqhMO2RKtIHYY86rL4XaY=
Message-ID: <4D6DF58D.5030905@pobox.com>
Date: Wed, 02 Mar 2011 02:45:17 -0500
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        stable <stable@kernel.org>
Subject: Re: [PATCH #upstream-fixes] libata: fix hotplug for drivers which
 don't implement LPM
References: <20110224183037.GS7840@htj.dyndns.org>
In-Reply-To: <20110224183037.GS7840@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24/2011 01:30 PM, Tejun Heo wrote:
> ata_eh_analyze_serror() suppresses hotplug notifications if LPM is
> being used because LPM generates spurious hotplug events.  It compared
> whether link->lpm_policy was different from ATA_LPM_MAX_POWER to
> determine whether LPM is enabled; however, this is incorrect as for
> drivers which don't implement LPM, lpm_policy is always
> ATA_LPM_UNKNOWN.  This disabled hotplug detection for all drivers
> which don't implement LPM.
>
> Fix it by comparing whether lpm_policy is greater than
> ATA_LPM_MAX_POWER.
>
> Signed-off-by: Tejun Heo<tj@kernel.org>
> Cc: stable@kernel.org

applied, though putting this into 2.6.38.1 is preferred to changing this 
at -rc7...  stable@ cc'd.

