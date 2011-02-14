Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751641Ab1BNR60 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 12:58:26 -0500
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:23890 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082Ab1BNR6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 12:58:25 -0500
X-IronPort-AV: E=Sophos;i="4.60,469,1291593600"; 
   d="scan'208";a="4320376"
Date: Mon, 14 Feb 2011 17:58:19 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Yinghai Lu <yinghai@kernel.org>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>, Jan Beulich <JBeulich@novell.com>
Subject: Re: [PATCH] x86/mm/init: respect memblock reserved regions when
 destroying mappings
In-Reply-To: <AANLkTimVMG1N2Ln+zSCWgGPSSv9kdUM844UGD+HfeOtE@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1102141756550.2826@kaball-desktop>
References: <4D50343E.1020906@kernel.org> <alpine.DEB.2.00.1102071839060.7277@kaball-desktop> <4D504161.2060900@kernel.org> <4D506A85.9030802@goop.org> <4D50B4B5.4050505@kernel.org> <4D519AAA.8070309@zytor.com> <4D547962.8040403@goop.org> <4D547B74.1030302@kernel.org>
 <4D54844B.4010007@zytor.com> <4D5488D5.2020607@kernel.org> <20110214162602.GB11290@dumpdata.com> <AANLkTimVMG1N2Ln+zSCWgGPSSv9kdUM844UGD+HfeOtE@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Feb 2011, Yinghai Lu wrote:
> On Mon, Feb 14, 2011 at 8:26 AM, Konrad Rzeszutek Wilk
> <konrad.wilk@oracle.com> wrote:
> >> BTW: Do we really need to cleanup initial mapping between _brk_end to _end?
> >
> > Did you try to revert the patch and run it under your setup?
> 
> No.
> 
> but it should be ok.
> 
> Assume, we can update vmlinux.lds.S to make _end to be 2M aligned as
> Stefano suggested?

That would solve the problem as long as cleanup_highmap() is not moved
to setup_arch.
