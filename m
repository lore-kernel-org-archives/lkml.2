Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757543Ab0KJXwN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 18:52:13 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:59311 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757322Ab0KJXwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 18:52:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Nbo4YKfX3DB6whphhDIVxcIg/EUqP8s2pv5pyQtpZzYnsVfL2852a7Gr7WUoVr6eut
         WGEXZjBnKZVaKP28j/C0tW1/Fr7Qr1dIlGc/3qpxfzF09f2Xcad9MeHlLST+JWZPq3/F
         lZpmM9YBgFzrTfG4wf+T3zNmld3uuMaBVs+b8=
Message-ID: <4CDB3028.6080605@garzik.org>
Date: Wed, 10 Nov 2010 18:52:08 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Fedora/3.1.6-1.fc13 Thunderbird/3.1.6
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@suse.de>
CC: linux-scsi <linux-scsi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Patch added to scsi-rc-fixes-2.6:  [SCSI] host lock push-down
References: <201011102240.oAAMe86a001486@hera.kernel.org> <4CDB2A81.5030100@garzik.org> <1289432759.3016.63.camel@mulgrave.site>
In-Reply-To: <1289432759.3016.63.camel@mulgrave.site>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/2010 06:45 PM, James Bottomley wrote:
> On Wed, 2010-11-10 at 18:28 -0500, Jeff Garzik wrote:
>> On 11/10/2010 05:40 PM, James Bottomley wrote:
>>> Your commit:
>>>
>>>       [SCSI] host lock push-down
>>>
>>>       Move the mid-layer's ->queuecommand() invocation from being locked
>>>       with the host lock to being unlocked to facilitate speeding up the
>>>       critical path for drivers who don't need this lock taken anyway.
>>>
>>>       The patch below presents a simple SCSI host lock push-down as an
>>>       equivalent transformation.  No locking or other behavior should change
>>>       with this patch.  All existing bugs and locking orders are preserved.
>>>
>>>       Minimal code disturbance was attempted with this change.  Most drivers
>>>       needed only two one-line modifications for their host lock push-down.
>>>
>>>       Signed-off-by: Jeff Garzik<jgarzik@redhat.com>
>>>       Signed-off-by: James Bottomley<James.Bottomley@suse.de>
>>>
>>> has been added to the upstream SCSI tree
>>> You can find it here:
>>
>> No comments on renaming ->queuecommand to something else?
>
> What we wondered about doing differently isn't really relevant for a
> change log ... that should just really be about what was done (to avoid
> confusion).

Wasn't referring to the changelog (perhaps shouldn't have quoted that); 
just asking the question generally.


>> The consequences are rather dire if this goes unnoticed, yes?
>
> You mean if there's a missed in-tree driver?  Yes, but I took care to
> make sure all SCSI drivers were accounted for.  For out of tree drivers,
> as with the eh lock push down, it's caveat emptor.

Thinking about out-of-tree drivers, yes.

	Jeff


