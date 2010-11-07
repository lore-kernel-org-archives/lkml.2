Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753582Ab0KGQy3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 11:54:29 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:60628 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141Ab0KGQy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 11:54:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=TE8VERYRYmgCasGX5wTkskNEh8ktqUWHpgeYqZHCHmQ29cz508kN59vYpPFrj64INT
         CEgvnNbeuMalB+3GrICCA6xsRnNXVhsd4C2M2uMWgz2z3YCMvUZqARtGvOo0rvbyo8Zx
         vkKTs8/yiPkNh7EoMvHFnjzTgsHknMJBb/b2k=
Message-ID: <4CD6D9BE.3030206@garzik.org>
Date: Sun, 07 Nov 2010 11:54:22 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Fedora/3.1.6-1.fc13 Thunderbird/3.1.6
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] SCSI host lock push-down
References: <20101105002409.GA21714@havoc.gtf.org> <4CD52059.7010503@s5r6.in-berlin.de>
In-Reply-To: <4CD52059.7010503@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2010 05:31 AM, Stefan Richter wrote:
> Jeff Garzik wrote:
>> An alternate arrangement, not presented by this patch, might
>> be preferred:  in order to make it clear that queuecommand
>> locking has changed, one could s/queuecommand/queuecommand_nl/ in
>> Scsi_Host_Template, in order to guarantee that drivers are either
>> (a) upgraded or (b) broken at compile time.  Compile-time detection of
>> new locking may be desirable, and I'll volunteer to change my patch to
>> do that, if community members prefer that route instead of below.
>
> I followed only a fraction of the related discussion.  Thus I wonder why a
> renaming of scsi_host_template.queuecommand was not part of these attempts
> from the very outset.
>
> Given the choice between compile-time breakage of unconverted drivers and
> silent invalidation of potential locking assumptions at runtime, the
> preferable way forward is quite clear IMO.

I am leaning towards a rename, but wanted to see what others thought.


> (Since no coexistence period of .queuecommand and .queuecommand_nl or
> .unlocked_queuecommand is planned, how about you rename it to .queue_command?
> Follows Linux naming conventions more closely.)

To me, that name lacks a clear "locking changed" signal, for a random 
engineer who simply stumbles upon the queuecommand -> queue_command 
rename change one day.

	Jeff


