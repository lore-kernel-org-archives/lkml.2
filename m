Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932419Ab2GFR3W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 13:29:22 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:19358 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753986Ab2GFR3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 13:29:20 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmwtM48/lk3M7oE7o=
X-RZG-CLASS-ID: mo00
Date: Fri, 6 Jul 2012 19:29:18 +0200
From: Olaf Hering <olaf@aepfle.de>
To: Jan Beulich <JBeulich@suse.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: kexec@lists.infradead.org, xen-devel@lists.xensource.com,
        Daniel Kiper <dkiper@net-space.pl>, linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] incorrect layout of globals from head_64.S during
 kexec boot
Message-ID: <20120706172918.GA15222@aepfle.de>
References: <20120705210607.GA26908@aepfle.de>
 <20120706084120.GA31219@router-fw-old.local.net-space.pl>
 <20120706120750.GA8970@aepfle.de>
 <4FF6FCA9020000780008E0BB@nat28.tlf.novell.com>
 <20120706133105.GA20600@aepfle.de>
 <20120706141419.GA21951@aepfle.de>
 <4FF7174C020000780008E1FF@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4FF7174C020000780008E1FF@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21.rev5543 (2011-12-20)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 06, Jan Beulich wrote:

> > Could it be that some code tweaks the stack content used by decompress()
> > in some odd way? But that would most likely lead to a crash, not to
> > unexpected uncompressing results.
> 
> Especially if the old and new kernel are using the exact same
> image, how about the decompression writing over the shared
> info page causing all this? As the decompressor wouldn't
> expect Xen to possibly write stuff there itself, it could easily be
> that some repeat count gets altered, thus breaking the
> decompressed data without the decompression code necessarily
> noticing.

In my case the gfn of the shared info page is 1f54.
Is it possible to move the page at runtime? It looks like it can be done
because the hvm loader configures fffff initially.

Perhaps the PVonHVM code has to give up the shared pages or move them to
some dedicated unused page during the process of booting into the new
kernel.

Konrad, any idea how that could be done?

> If that's the case, there would be a more general problem here
> (for kdump at least), as granted pages could also still get written
> to when the new kernel already is in the process of launching.

Maybe you meant to say kexec instead of kdump?
kdump runs in its own memory area, so I think the worst thing is that
some pages of the crashed kernel get modified.

Olaf
