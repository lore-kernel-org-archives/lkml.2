Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751841Ab2KOVza (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 16:55:30 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:50492 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492Ab2KOVz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 16:55:29 -0500
Date: Thu, 15 Nov 2012 22:55:23 +0100
From: Andreas Herrmann <herrmann.der.user@googlemail.com>
To: Boris Ostrovsky <boris.ostrovsky@amd.com>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>, hpa@zytor.com, mingo@elte.hu,
        tglx@linutronix.de, bp@alien8.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, microcode, AMD: Add support for family 16h
 processors
Message-ID: <20121115215523.GB6520@tweety>
References: <1353004910-2204-1-git-send-email-boris.ostrovsky@amd.com>
 <20121115204503.GB18032@khazad-dum.debian.net>
 <50A55E04.9020606@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50A55E04.9020606@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 15, 2012 at 04:26:28PM -0500, Boris Ostrovsky wrote:
> 
> 
> On 11/15/2012 03:45 PM, Henrique de Moraes Holschuh wrote:
> >On Thu, 15 Nov 2012, Boris Ostrovsky wrote:
> >>Add valid patch size for family 16h processors
> >>
> >>Signed-off-by: Boris Ostrovsky <boris.ostrovsky@amd.com>
> >
> >Is this something that needs to go to -stable ?
> >
> >>  #define F1XH_MPB_MAX_SIZE 2048
> >>  #define F14H_MPB_MAX_SIZE 1824
> >>  #define F15H_MPB_MAX_SIZE 4096
> >>+#define F16H_MPB_MAX_SIZE 3458
> >>
> >>  	switch (c->x86) {
> >>  	case 0x14:
> >>@@ -198,6 +199,9 @@ static unsigned int verify_patch_size(int cpu, u32 patch_size,
> >>  	case 0x15:
> >>  		max_size = F15H_MPB_MAX_SIZE;
> >>  		break;
> >>+	case 0x16:
> >>+		max_size = F16H_MPB_MAX_SIZE;
> >>+		break;
> >>  	default:
> >>  		max_size = F1XH_MPB_MAX_SIZE;
> >>  		break;
> >
> >Because it looks like without this patch, some valid microcode updates
> >would be rejected by the kernel...
> 
> Right, patch loading will fail.
> 
> I wasn't sure whether stable would be appropriate since this is
> support for new HW. OTOH since this would result in loss of
> functionality one could consider this a bug.

Yes, it seems that a

 Cc: <stable@vger.kernel.org>

(at least for 3.2, 3.4, 3.6)

can't hurt to ensure that most recent kernel releases properly handle
ucode updates for family 16h CPUs (whenever they come out).


Andreas
