Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476Ab2IGTBR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 15:01:17 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:41832 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024Ab2IGTBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 15:01:14 -0400
Subject: Re: [PATCH 00/11] lots of fixes for zero allocation length
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, target-devel@vger.kernel.org, hch@lst.de,
        roland@kernel.org
In-Reply-To: <1347031842-2531-1-git-send-email-pbonzini@redhat.com>
References: <1347031842-2531-1-git-send-email-pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 07 Sep 2012 12:01:12 -0700
Message-ID: <1347044472.4162.645.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-09-07 at 17:30 +0200, Paolo Bonzini wrote:
> Here are the fixes for zero-length commands, that ultimately let
> all command go through normal processing, even if they have
> zero length.
> 
> The first patch is for PSCSI, the others are for IBLOCK and friends.
> I tried to order them so that the safest come first.  So for 3.6 you
> could choose to stop at patch 1, 2, 3 or 6, or not apply anything
> at all.
> 
> Testcases included in each patch, when relevant.


Very nice, so the remaining patches #7-10 have been applied into
for-next, and I'll apply a slightly modified patch #11 next week after
rebasing for-next as patches #1-6 hit -rc5 -> -rc6 along with the other
pending fixes.

Great work Paolo !!

--nab

> Paolo
> 
> Paolo Bonzini (11):
>   target: go through normal processing for zero-length PSCSI commands
>   target: report too-small parameter lists everywhere
>   target: fail REPORT LUNS with less than 16 bytes of payload
>   target: support zero-size allocation lengths in transport_kmap_data_sg
>   target: support zero allocation length in REQUEST SENSE
>   target: go through normal processing for zero-length REQUEST_SENSE
>   target: support zero allocation length in INQUIRY
>   target: fix truncation of mode data, support zero allocation length
>   target: support zero allocation length in SBC commands
>   target: do not submit a zero-bio I/O request
>   target: go through normal processing for all zero-length commands
> 
>  drivers/target/target_core_alua.c      |    7 +++
>  drivers/target/target_core_device.c    |    7 +++
>  drivers/target/target_core_iblock.c    |   17 ++++++-
>  drivers/target/target_core_pr.c        |    8 +++
>  drivers/target/target_core_pscsi.c     |    8 ++--
>  drivers/target/target_core_sbc.c       |   23 ++++++---
>  drivers/target/target_core_spc.c       |   81 +++++++++++--------------------
>  drivers/target/target_core_transport.c |   35 ++++----------
>  include/target/target_core_base.h      |    1 +
>  9 files changed, 95 insertions(+), 92 deletions(-)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe target-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


