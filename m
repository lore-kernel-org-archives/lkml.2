Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760643Ab2FUXBG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 19:01:06 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:52807 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760566Ab2FUXBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 19:01:04 -0400
X-Sasl-enc: vKQU54A8umBp3HGiIeFYzySEMkEr3GgSxP+8FCxeaerV 1340319663
Date: Thu, 21 Jun 2012 20:00:59 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Borislav Petkov <bp@amd64.org>, "Yu, Fenghua" <fenghua.yu@intel.com>,
        X86-ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: [PATCH 2/2] x86, microcode: Make reload interface per system
Message-ID: <20120621230059.GA27178@khazad-dum.debian.net>
References: <1340121811-4477-1-git-send-email-bp@amd64.org>
 <1340121811-4477-3-git-send-email-bp@amd64.org>
 <CANDHA0jf2fLOtg1E6CbyNM=omn=kj=YoRJ3VTkNA0AhkS-MLtg@mail.gmail.com>
 <3E5A0FA7E9CA944F9D5414FEC6C7122007737623@ORSMSX105.amr.corp.intel.com>
 <20120619232857.GH5996@aftab.osrc.amd.com>
 <1340182778.21745.75.camel@twins>
 <20120620230856.GA4223@khazad-dum.debian.net>
 <1340267075.21745.155.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340267075.21745.155.camel@twins>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Jun 2012, Peter Zijlstra wrote:
> On Wed, 2012-06-20 at 20:08 -0300, Henrique de Moraes Holschuh wrote:
> > On Wed, 20 Jun 2012, Peter Zijlstra wrote:
> > > On Wed, 2012-06-20 at 01:28 +0200, Borislav Petkov wrote:
> > > > which makes me wonder whether we still need that OLD INTERFACE.
> > > > Henrique, any thoughts here? 
> > > 
> > > Yes I need it, I've no f'ing clue where to put the ucode image so that
> > > the whole firmware mess can find it :-)
> > 
> > iucode_tool -K <name of intel microcode .dat/.bin file(s)> will do it
> > for you :p
> 
> This thing is not installed on my machine, nor would I have know to look
> for it. Nor does apt-cache search iucode_tool suggest any package.
> 
> IOW fail.

Meh.  I uploaded the first public version of the thing a whole two weeks
ago!  It should have been all over the Internet by now ;-)

It is in Debian Wheezy (soon-to-be-stable) as of yesterday, I think.  It
will eventually end up in Ubuntu.  And if you guys think it is worthwhile to
maintain it upstream either in git.k.o, or as part of tools/, I have nothing
against it.

I posted the URL earlier, I think, but here it is:
http://cdn.debian.net/debian/pool/contrib/i/iucode-tool/iucode-tool_0.8.orig.tar.bz2

But it really exists to help distros do Intel microcode management and
release install-and-forget packages for end users.  End-users should get to
either ignore its existence entirely and get automated updates of microcode
as distro binary packages, or run an "update-intel-microcode" script (not
written yet, but there is one on Debian and Ubuntu's microcode.ctl package)
that downloads the blob from Intel, and does whatever is needed to install
it to /lib/firmware and apply it to the running system (and kernel image,
initramfs, whatever).

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
