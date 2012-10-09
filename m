Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751669Ab2JISVo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 14:21:44 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:57973 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818Ab2JISVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 14:21:41 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: Re: [PATCH 5/9] ARM: Xen: fix initial build problems:
Date: Tue, 9 Oct 2012 18:21:27 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Russell King <rmk+kernel@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
References: <1349796183-30648-1-git-send-email-arnd@arndb.de> <1349796183-30648-6-git-send-email-arnd@arndb.de> <alpine.DEB.2.02.1210091630170.29539@kaball.uk.xensource.com>
In-Reply-To: <alpine.DEB.2.02.1210091630170.29539@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201210091821.27818.arnd@arndb.de>
X-Provags-ID: V02:K0:pCU5eG1EXLHqk6USjSHpl/m9oAwRb8hRm5yQB99/6NF
 14PqehjUA9zfcpNKKQZH+zBDwp097p0bhbKCk9SETw1wadY3C+
 3MHtkqDzGLRJLoZTuOP2eHNUtZkswuqj78FFb8Io3LEvZaYw3z
 uKno/HJlLxqqfb0iuH58nfpjkQO4Zm8h8rPzwKuGaM+FMCt18+
 xKiaC1gOCu1Kzp+kjaQUiD/JvP8N7YoeV011nu/0DhBHanfv27
 HESRbHGFyXe3ZkeGzMQKkMSiYqJTgPmsSiezpMlgS8i50sNOCs
 s4unFVIx875znTPAbMCJAnGALPkwRyw7lhs3T/dKaaTfCRbxXZ
 sqRy/NGT3Wvq8WC6T4ZY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 October 2012, Stefano Stabellini wrote:
> >  config XEN
> >       bool "Xen guest support on ARM (EXPERIMENTAL)"
> >       depends on EXPERIMENTAL && ARM && OF
> > +     depends on !CPU_V6
> >       help
> >         Say Y if you want to run Linux in a Virtual Machine on Xen on ARM.
> 
> Considering that we rely on the virtualization extensions, this one can
> be:
> 
>     depends on CPU_V7
> 
> The rest looks fine. I can submit a second patch to change !CPU_V6 into
> CPU_V7 later, if you prefer.

CPU_V6 and CPU_V7 are not exclusive, I saw the problem when building a
combined kernel for both V6 and V7. The code also needs to depend on ARMv7
with virtualization extensions, but that is a different issue. We don't
actually have a configuration symbol for that yet, as far as I can tell.

	Arnd
