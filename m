Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751643Ab2KOVth (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 16:49:37 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:39205 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751549Ab2KOVtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 16:49:35 -0500
X-Sasl-enc: yxi0UKR99487HUCCSoSNrr6G8mLUs9teS6IERgRNLA+w 1353016174
Date: Thu, 15 Nov 2012 19:49:30 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Boris Ostrovsky <boris.ostrovsky@amd.com>
Cc: hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de,
        herrmann.der.user@googlemail.com, bp@alien8.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, microcode, AMD: Add support for family 16h
 processors
Message-ID: <20121115214930.GB5316@khazad-dum.debian.net>
References: <1353004910-2204-1-git-send-email-boris.ostrovsky@amd.com>
 <20121115204503.GB18032@khazad-dum.debian.net>
 <50A55E04.9020606@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50A55E04.9020606@amd.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Nov 2012, Boris Ostrovsky wrote:
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

It is quite a good enough reason to propose a patch to -stable, yes.  This
is no "theoretical" bug, it will hit users when AMD issues any microcode
updates for family 16h processors.  The fact that the patch is obviously
safe and correct is also a plus, and every distro will want it anyway.

BTW, you might want to propose a forward-looking change that uses a more
conservative size for the "default" case in verify_patch_size(), one which
would be less likely to cause trouble with future families.  As a separate
patch, of course.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
