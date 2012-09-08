Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753792Ab2IHKUZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 06:20:25 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:40756 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753322Ab2IHKUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 06:20:23 -0400
Message-ID: <504B1BE0.9040901@redhat.com>
Date: Sat, 08 Sep 2012 12:20:16 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Stefan Bader <stefan.bader@canonical.com>
CC: Jan Beulich <JBeulich@suse.com>, "Justin M. Forbes" <jmforbes@linuxtx.org>,
        Matt Wilson <msw@amazon.com>, xen-devel@lists.xen.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH/RFC] Fix xsave bug on older Xen hypervisors
References: <1347018043-21252-1-git-send-email-stefan.bader@canonical.com> <504A05B00200007800099C7B@nat28.tlf.novell.com> <5049F4E9.9050306@canonical.com> <504A1A950200007800099D4C@nat28.tlf.novell.com> <20120907142251.GA20096@linuxtx.org> <504A32800200007800099E40@nat28.tlf.novell.com> <504A172B.5020005@canonical.com>
In-Reply-To: <504A172B.5020005@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 07/09/2012 17:47, Stefan Bader ha scritto:
> 
> Legacy hypervisors (RHEL 5.0 and RHEL 5.1) do not handle guest writes to
> cr4 gracefully. If a guest attempts to write a bit of cr4 that is
> unsupported, then the HV is so offended it crashes the domain. While
> later guest kernels (such as RHEL6) don't assume the HV supports all
> features, they do expect nicer responses. That assumption introduced
> code that probes whether or not xsave is supported early in the boot. So
> now when attempting to boot a RHEL6 guest on RHEL5.0 or RHEL5.1 an early
> crash will occur.
> 
> This patch is quite obviously an undesirable hack. The real fix for this
> problem should be in the HV, and is, in later HVs. However, to support
> running on old HVs, RHEL6 can take this small change. No impact will
> occur for running on any RHEL HV (not even RHEL 5.5 supports xsave).
> There is only potential for guest performance loss on upstream Xen.
> 
> All this by way of explanation for why is this patch not going upstream.

If it is just 5.0 and 5.1, you can restrict the patch to Xen 3.0.

5.2 switched to Xen 3.1, which has been subsequently patched to death
without rebasing.

Paolo
