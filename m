Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258Ab0JWJvw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 05:51:52 -0400
Received: from isrv.corpit.ru ([86.62.121.231]:53464 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752309Ab0JWJvv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 05:51:51 -0400
Message-ID: <4CC2B033.7020806@msgid.tls.msk.ru>
Date: Sat, 23 Oct 2010 13:51:47 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.12) Gecko/20100913 Icedove/3.0.7
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org, stable@kernel.org, greg@kroah.com,
        stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Zachary Amsden <zamsden@redhat.com>, mtosatti@redhat.com,
        avi@redhat.com
Subject: Re: [077/103] KVM: x86: Fix SVM VMCB reset
References: <20101022185234.270241682@clark.site>
In-Reply-To: <20101022185234.270241682@clark.site>
X-Enigmail-Version: 1.0.1
OpenPGP: id=804465C5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

22.10.2010 22:51, Greg KH wrote:
> 2.6.35-stable review patch.  If anyone has any objections, please let us know.
> ------------------
> 
> From: Marcelo Tosatti <mtosatti@redhat.com>
> 
> commit 58877679fd393d3ef71aa383031ac7817561463d upstream.
> 
> On reset, VMCB TSC should be set to zero.  Instead, code was setting
> tsc_offset to zero, which passes through the underlying TSC.

Not an objection, but shouldn't this and subsequent 078 "KVM: x86: Move
TSC reset out of vmcb_init" patches be applied to 2.6.32 too?  The same
problem exists in 2.6.32, and the two patches allows an smp linux guest
to boot in there, or such a guest just hangs at boot.  (078 patch needs
to be adjusted a bit for 2.6.32, since the code there is a bit different
and it does not apply correctly; but the change is trivial).

Thanks!

/mjt
