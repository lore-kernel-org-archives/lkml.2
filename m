Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753604Ab2I2KqS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2012 06:46:18 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:52011 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753204Ab2I2KqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2012 06:46:17 -0400
X-Sasl-enc: R0rTDWT+6MnUTIzw6MqsPY0OhB0tx02s/GKPhvYmZeUn 1348915576
Date: Sat, 29 Sep 2012 07:46:11 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Peter Hurley <peter@hurleysoftware.com>,
        "zhenzhong.duan@oracle.com" <zhenzhong.duan@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] x86: mtrr: Constrain WB MTRR to max phys mem prior to
 cleanup
Message-ID: <20120929104611.GB14974@khazad-dum.debian.net>
References: <1347039854.6288.8.camel@thor>
 <504A3FA9.1050502@zytor.com>
 <504D6490.2060606@oracle.com>
 <1348853876.2229.22.camel@thor>
 <5066680E.3090907@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5066680E.3090907@zytor.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Sep 2012, H. Peter Anvin wrote:
> On 09/28/2012 10:37 AM, Peter Hurley wrote:
> > An interesting side note: more recent revisions of this BIOS (rev. A11)
> > report one less variable MTRR (so, IA32_MTRRCAP is writable?)
> > 
> >>> However, the right way to fix that is to use the PAT interfaces, which 
> >>> doesn't have this drawback -- then MTRR cleanup becomes entirely 
> >>> superfluous and the problem goes away.
> >> Do you mean disable MTRR totally here?
> > 
> > Well, since PAT entries marked WC override all MTRR settings, whatever
> > the BIOS set the variable MTRRs to becomes irrelevant, so not disabled
> > but rather ignored.
> > 
> 
> The whole point is that the display stuff should not use MTRR, but
> rather use PAT to provide WC.  Then we don't need to "clean up" the
> BIOS-set MTRRs.

What about my trusty ThinkPad T43, and other ia32 boxes that either lack PAT
support, or have it blacklisted?

These are exactly the boxes that will _never_ get a BIOS fix if their MTRRs
are screwed up...

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
