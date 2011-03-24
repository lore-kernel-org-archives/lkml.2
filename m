Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933442Ab1CXAO4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 20:14:56 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:56186 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933023Ab1CXAOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 20:14:55 -0400
X-Sasl-enc: u68rLTgT0rF4pj9ljQ5BufM+R95zk8MafFLeF1RIVrWt 1300925694
Date: Wed, 23 Mar 2011 21:14:51 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Burt Triplett <burt@pbjtriplett.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: BITS handling of CPU microcode updates
Message-ID: <20110324001451.GA7950@khazad-dum.debian.net>
References: <4D65EE74.1050709@pbjtriplett.org>
 <20110312023001.GB27550@khazad-dum.debian.net>
 <4D87E2CD.6020306@pbjtriplett.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D87E2CD.6020306@pbjtriplett.org>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Mar 2011, Burt Triplett wrote:
> Sorry for the delayed response; I wanted to make sure I could give
> you an answer that would agree with the Intel Software Developer's
> Manual, and that ended up meaning I needed to start the process of
> updating the relevant part of the SDM. :)

Heh :-)

> The Intel SDM correctly identifies microcode revision numbers as
> signed.  However, a simple signed comparison doesn't actually
> capture the correct logic, nor does an unsigned comparison, though
> in both cases the problem doesn't tend to come up in common cases.

...

> Tools which run automatically, without explicit user action, should
> not attempt to load a microcode if (X < 0) and (Z > 0).  Doing so
> makes life very difficult for people in those test lab environments:
> they put a microcode they want to test in the BIOS or load it via
> BITS, but then the OS driver automatically overrides it with the
> latest production microcode.  So, tools which run automatically
> without explicit user action should follow this rule:
> if ((Z < 0) || (Z > 0 && X > 0 && Z > X)) load_microcode();

Very well, I will send patches to fix that behaviour, as well as some
other stuff I noticed that was not updated to match the recommended
actions documented by the SDM and some Intel application notes.

> If microcode_ctl added an option to distinguish these two cases, it
> could apply the alternative logic when explicitly requested.

Indeed, the userspace and internal kernel API don't support that at this
time.

Now, we could change them I suppose, but it doesn't look like a worthwhile
effort to change the microcode core and APIs for something that would be
of limited use even inside an Intel lab.

Unless there is a reason to support online microcode downgrading, that is.
Does it?  Currently, the rare case of a microcode downgrade will only
happen at the next boot.

> I've started the process of getting the SDM changed to document the
> logic described above, and distinguish the two different types of
> microcode-loading tools.

Thank you.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
