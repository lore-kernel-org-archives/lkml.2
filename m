Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933094Ab2HPSpa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 14:45:30 -0400
Received: from mx4-phx2.redhat.com ([209.132.183.25]:42886 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754805Ab2HPSp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 14:45:28 -0400
Date: Thu, 16 Aug 2012 14:45:15 -0400 (EDT)
From: Tomas Racek <tracek@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, Alan Cox <alan@linux.intel.com>,
        linux-kernel@vger.kernel.org, qemu-devel@nongnu.org
Message-ID: <1898701172.1847948.1345142715802.JavaMail.root@redhat.com>
In-Reply-To: <20120816134834.GA11974@x1.osrc.amd.com>
Subject: Re: x86, nops settings result in kernel crash
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.36.6.135]
X-Mailer: Zimbra 7.2.0_GA_2669 (ZimbraWebClient - GC20 (Linux)/7.2.0_GA_2669)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> On Thu, Aug 16, 2012 at 09:35:12AM -0400, Tomas Racek wrote:
> > Hi,
> > 
> > I am writing a file system test which I execute in qemu with kernel
> > compiled from latest git sources and running it causes this error:
> > 
> > https://bugzilla.kernel.org/show_bug.cgi?id=45971
> > 
> > It works with v3.5, so I ran git bisect which pointed me to:
> > 
> > d6250a3f12edb3a86db9598ffeca3de8b4a219e9 x86, nops: Missing break
> > resulting in incorrect selection on Intel
> > 
> > To be quite honest, I don't understand this stuff much but I tried
> > to do some debugging and I figured out (I hope) that the crash is
> > caused by setting ideal_nops to p6_nops (k8_nops was used before
> > the break statement was added).
> 
> Maybe I overlooked it or maybe it was implied but did you try
> reverting
> the patch and rerunning your test? Does it work ok then?
> 

Yes, if I remove the break statement (introduced by this commit), it works fine.

Tomas

> Thanks.
> 
> --
> Regards/Gruss,
> Boris.
> 
