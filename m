Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933522Ab1CXUIW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 16:08:22 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49787 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752341Ab1CXUIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 16:08:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=pDtog+mtGRxRh9GWEH4io7SqUQvOl4cmuAzM901m+521ZEs58c6HjPVvnPKfUYcUGa
         iTYcCqToRTEYfhwp+9A5MVpEwjefiN9Cbte71+NNBDL1ta/P95NpkVkQl73hbVbDTZ5X
         NFlzQrcowh7fehTn19yhqQ4fdSc4fM/iHcwaY=
Subject: Re: [GIT PULL] SLAB changes for v2.6.39-rc1
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        tj@kernel.org, npiggin@kernel.dk, rientjes@google.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <alpine.DEB.2.00.1103241451060.5576@router.home>
References: <alpine.DEB.2.00.1103241300420.32226@router.home>
	 <AANLkTi=KZQd-GrXaq4472V3XnEGYqnCheYcgrdPFE0LJ@mail.gmail.com>
	 <alpine.DEB.2.00.1103241312280.32226@router.home>
	 <1300990853.3747.189.camel@edumazet-laptop>
	 <alpine.DEB.2.00.1103241346060.32226@router.home>
	 <AANLkTik3rkNvLG-rgiWxKaPc-v9sZQq96ok0CXfAU+r_@mail.gmail.com>
	 <20110324185903.GA30510@elte.hu>
	 <AANLkTi=66Q-8=AV3Y0K28jZbT3ddCHy9azWedoCC4Nrn@mail.gmail.com>
	 <alpine.DEB.2.00.1103241404490.5576@router.home>
	 <AANLkTimWYCHEsZjswLpD-xDcu_cL=GqsMshKRtkHt5Vn@mail.gmail.com>
	 <20110324193647.GA7957@elte.hu>
	 <AANLkTinBwKT3s=1En5Urs56gmt_zCNgPXnQzzy52Tgdo@mail.gmail.com>
	 <alpine.DEB.2.00.1103241451060.5576@router.home>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Mar 2011 21:08:10 +0100
Message-ID: <1300997290.2714.2.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 24 mars 2011 à 14:51 -0500, Christoph Lameter a écrit :
> On Thu, 24 Mar 2011, Pekka Enberg wrote:
> 
> > Thanks, Ingo! Christoph, may I have your sign-off for the patch and
> > I'll send it to Linus?
> 
> 
> Subject: SLUB: Write to per cpu data when allocating it
> 
> It turns out that the cmpxchg16b emulation has to access vmalloced
> percpu memory with interrupts disabled. If the memory has never
> been touched before then the fault necessary to establish the
> mapping will not to occur and the kernel will fail on boot.
> 
> Fix that by reusing the CONFIG_PREEMPT code that writes the
> cpu number into a field on every cpu. Writing to the per cpu
> area before causes the mapping to be established before we get
> to a cmpxchg16b emulation.
> 


Thats strange, alloc_percpu() is supposed to zero the memory already ...

Are you sure its really this problem of interrupts being disabled ?



