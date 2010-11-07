Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561Ab0KGQ5J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 11:57:09 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:62600 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751748Ab0KGQ5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 11:57:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=ePHderzk+tDC9+D/K7MMP2mLwEoH4Rnl32bk7WIkL8P4RfnWaRjkGyNAm57iPeQT3V
         /b5MyIyLH+cANBsVXgoPleSUxlBznS9ZuOT+ESVfOM5N/y1TeDC/O3a0Cpe2sTQE1o4q
         AV64AP6jTSgb1NEKArO4DzMEzXfnQwTBJtyEk=
Message-ID: <4CD6DA5F.3050905@garzik.org>
Date: Sun, 07 Nov 2010 11:57:03 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Fedora/3.1.6-1.fc13 Thunderbird/3.1.6
MIME-Version: 1.0
To: Boaz Harrosh <bharrosh@panasas.com>
CC: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] SCSI host lock push-down
References: <20101105002409.GA21714@havoc.gtf.org> <4CD66222.5040808@panasas.com>
In-Reply-To: <4CD66222.5040808@panasas.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2010 03:24 AM, Boaz Harrosh wrote:
> Well now isn't that simple? One nit for me though.
> I would like to see a more scary name for above something like:
> DEF_SCSI_QCMD_WITH_LOCKING or
> DEF_SCSI_QCMD_OLD_WAY

I don't have a real preference; whatever the community prefers.  Maybe I 
would suggest DEF_SCSI_QCMD_LOCKER.


> Something that calls for a cleanup and removal the first time
> the driver is touched.
>
> Otherwise I think this is the only form that should make it safe
> for this Kernel.
>
> (The rename could be nice also though it is one additional hunk in
>   each driver. Did you use a script to produce this?)

No script; a few vim macros helped a bit.  I wanted to actually examine 
each callsite, to get a feel of the locking scheme, and make sure my 
change was truly an equivalent-transformation.

	Jeff



