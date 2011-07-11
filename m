Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932199Ab1GKUrE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 16:47:04 -0400
Received: from smtp-out.google.com ([216.239.44.51]:59483 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317Ab1GKUrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 16:47:02 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=SLUgvJmWwjfvW2onbT6CnEwcgGKvi//qgQC+jLKPecxZQwjD4NFqo2pysy3ooAIRg
	SDaIHIGbMYAp0B9M8J4mQ==
Date: Mon, 11 Jul 2011 13:46:42 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH next/mmotm] slub: partly fix freeze in __slab_free
In-Reply-To: <1310413167.2860.3.camel@edumazet-laptop>
Message-ID: <alpine.LSU.2.00.1107111339330.13756@sister.anvils>
References: <alpine.LSU.2.00.1107111156310.13035@sister.anvils> <1310413167.2860.3.camel@edumazet-laptop>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323584-668078831-1310417214=:13756"
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323584-668078831-1310417214=:13756
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Mon, 11 Jul 2011, Eric Dumazet wrote:
> Le lundi 11 juillet 2011 =C3=A0 11:58 -0700, Hugh Dickins a =C3=A9crit :
> > My load tests on PowerPC freeze within minutes in __slab_free().
> > I happened to try PPC first, didn't try without this fix on x86.
>=20
> I suspect you hit the bug on 32bit arch ?

No, it was ppc64.  I've not actually tried that load on mmotm 32bit
at all yet, better do so tonight!

Hugh

>=20
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index 3d76a43..1351d28 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -62,7 +62,7 @@ struct page {
>  =09=09struct {=09=09=09/* SLUB cmpxchg_double area */
>  =09=09=09void *freelist;
>  =09=09=09union {
> -=09=09=09=09unsigned long counters;
> +=09=09=09=09u64=09counters;
>  =09=09=09=09struct {
>  =09=09=09=09=09unsigned inuse:16;
>  =09=09=09=09=09unsigned objects:15;
--8323584-668078831-1310417214=:13756--
