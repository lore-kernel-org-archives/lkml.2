Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757422Ab0KJX2N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 18:28:13 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:45492 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757010Ab0KJX2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 18:28:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=MSdoPs3EQrUg+ulNPv9lWb/8fo1b6x7fNo4bPz3O3zEZ33HR2wtTtvYcDMJDtnL1yx
         jijzKo9Z/8r2tJyNuSQFtT2MZ4bryuY1Lwfiw8g+PAbxy1QSd4ZA4YYNeBIQCsrxPSXJ
         E4H46Qtpp37r8GYGG+41t8bGqCpBR4JAnM7yU=
Message-ID: <4CDB2A81.5030100@garzik.org>
Date: Wed, 10 Nov 2010 18:28:01 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Fedora/3.1.6-1.fc13 Thunderbird/3.1.6
MIME-Version: 1.0
To: James Bottomley <jejb@kernel.org>
CC: linux-scsi <linux-scsi@vger.kernel.org>,
        James Bottomley <James.Bottomley@suse.de>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Patch added to scsi-rc-fixes-2.6:  [SCSI] host lock push-down
References: <201011102240.oAAMe86a001486@hera.kernel.org>
In-Reply-To: <201011102240.oAAMe86a001486@hera.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/2010 05:40 PM, James Bottomley wrote:
> Your commit:
>
>      [SCSI] host lock push-down
>
>      Move the mid-layer's ->queuecommand() invocation from being locked
>      with the host lock to being unlocked to facilitate speeding up the
>      critical path for drivers who don't need this lock taken anyway.
>
>      The patch below presents a simple SCSI host lock push-down as an
>      equivalent transformation.  No locking or other behavior should change
>      with this patch.  All existing bugs and locking orders are preserved.
>
>      Minimal code disturbance was attempted with this change.  Most drivers
>      needed only two one-line modifications for their host lock push-down.
>
>      Signed-off-by: Jeff Garzik<jgarzik@redhat.com>
>      Signed-off-by: James Bottomley<James.Bottomley@suse.de>
>
> has been added to the upstream SCSI tree
> You can find it here:

No comments on renaming ->queuecommand to something else?

The consequences are rather dire if this goes unnoticed, yes?

	Jeff


In http://marc.info/?l=linux-ide&m=128891665713984&w=2 I wrote:
> An alternate arrangement, not presented by this patch, might
> be preferred:  in order to make it clear that queuecommand
> locking has changed, one could s/queuecommand/queuecommand_nl/ in
> Scsi_Host_Template, in order to guarantee that drivers are either
> (a) upgraded or (b) broken at compile time.  Compile-time detection of
> new locking may be desirable, and I'll volunteer to change my patch to
> do that, if community members prefer that route instead of below.

