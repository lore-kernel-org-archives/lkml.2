Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757513Ab1ANNR1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 08:17:27 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:51281 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757456Ab1ANNRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 08:17:20 -0500
From: "Hans-Peter Jansen" <hpj@urpla.net>
To: Nick Piggin <npiggin@gmail.com>
Subject: Re: vfs-scale, keep the errno
Date: Fri, 14 Jan 2011 14:17:11 +0100
User-Agent: KMail/1.9.10
Cc: "J. R. Okajima" <hooanon05@yahoo.co.jp>,
        "linux-fsdevel" <linux-fsdevel@vger.kernel.org>,
        linux-kernel@vger.kernel.org
References: <8406.1294976295@jrobl> <AANLkTi=jozto+CNwfSKu2_dGWXaRi5p=3dqQngMz7g24@mail.gmail.com>
In-Reply-To: <AANLkTi=jozto+CNwfSKu2_dGWXaRi5p=3dqQngMz7g24@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201101141417.11817.hpj@urpla.net>
X-Provags-ID: V02:K0:9g4cWfLtifc68E8AiL73Zp5ocIUD+kBEl5HuE2wmT3h
 h+fyqvPBetoBrTyNoDFAPNBAOaZVUZv26ufTVXfuuYEOi9k32q
 3qAqigfL0nrXCfBYpFrP2AUlh8VQqzRRw3PsqZoo9XXUNE9dNb
 sEW6+oOtJy1CsrCLtBumH5ha4taswYS3BbYzQGuayMGic4GFCA
 IFHATbRgCtyEEGHlkv/mUrD1wlJ3tLFSjO2DnB1/s8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 14 January 2011, 05:01:37 Nick Piggin wrote:
> On Fri, Jan 14, 2011 at 2:38 PM, J. R. Okajima <hooanon05@yahoo.co.jp> 
wrote:
> > When open(2) without O_DIRECTORY opens an existing dir, it should
> > return EISDIR. In do_last(), the variable 'error' is initialized
> > EISDIR, but it is changed by d_revalidate() which returns any
> > positive to represent 'the target dir is valid.'
> > Should we keep and return the initialized 'error' in this case.
>
> Great, thank you very much. I just changed a few variable names but
> applied it. Would you please add you Signed-off-by: on patches from
> now on?
>
> Good reviewing work. Are you finding these by review or testing? I
> think ltptests on an nfs mount should find this kind of bug... which
> I should do.

Nick, Junjiro is well known as a very smart (and|but) humble guy in the 
kernel niche of layered filesystems. Be assured, that almost every live 
distribution (one, that is runnable from RO media directly) _relies_ on 
his work: aufs (http://aufs.sourceforge.net/) to get the job done. Also 
many diskless setups (as do mine) relies on aufs.

It's a real pity, that all other approaches to layered filesystems (or 
filesystem unification, overlay filesystems), that are done by others, 
are either
 - technically inferior
 - restricted in usage scenarios
 - simply unfinished

but get more attention in the kernel guild. All, that Junjiro's approach 
takes is exporting a handful of symbols in order to be able to build it 
as a module also (and the number decreases as other lately merged 
subsystems do need them as well, i.e. apparmor). That's all. 

Layered filesystems are a killer feature, that could have been in the 
kernel for years, but is still missing for hard to follow (e.g. 
political, emotional) reasons. There are many interesting things, that 
can be done with layered filesystems, hard to archive up to impossible 
to be done otherwise). 

Sadly,
Pete
