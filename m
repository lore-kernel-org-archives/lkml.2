Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557Ab1CBHr1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 02:47:27 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60697 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175Ab1CBHr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 02:47:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=AVXoLC5ALs/X2mO5R05bCj1uZmyoaegB/SnZCxvRfa/HJt7o6UnetyywBxK8tbOlL7
         wdlcMGF+YRGjGpV6Hkc+wrsYh2gz2W4kiLoT+6zMTe1mx3r7Z52osFdsPqqpDncwgB7+
         Q7oxXZgH5TV8L7FdgvUmEiDbmWtasKT1VT5dU=
Date: Wed, 2 Mar 2011 08:47:21 +0100
From: Tejun Heo <tj@kernel.org>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        stable <stable@kernel.org>
Subject: Re: [PATCH #upstream-fixes] libata: fix hotplug for drivers which
 don't implement LPM
Message-ID: <20110302074721.GF19669@htj.dyndns.org>
References: <20110224183037.GS7840@htj.dyndns.org>
 <4D6DF58D.5030905@pobox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D6DF58D.5030905@pobox.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 02, 2011 at 02:45:17AM -0500, Jeff Garzik wrote:
> On 02/24/2011 01:30 PM, Tejun Heo wrote:
> >ata_eh_analyze_serror() suppresses hotplug notifications if LPM is
> >being used because LPM generates spurious hotplug events.  It compared
> >whether link->lpm_policy was different from ATA_LPM_MAX_POWER to
> >determine whether LPM is enabled; however, this is incorrect as for
> >drivers which don't implement LPM, lpm_policy is always
> >ATA_LPM_UNKNOWN.  This disabled hotplug detection for all drivers
> >which don't implement LPM.
> >
> >Fix it by comparing whether lpm_policy is greater than
> >ATA_LPM_MAX_POWER.
> >
> >Signed-off-by: Tejun Heo<tj@kernel.org>
> >Cc: stable@kernel.org
> 
> applied, though putting this into 2.6.38.1 is preferred to changing
> this at -rc7...  stable@ cc'd.

Understood.  As long as it ends up in stable@, either way is okay with
me.  Thank you.

-- 
tejun
