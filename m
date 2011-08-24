Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751693Ab1HXNyp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 09:54:45 -0400
Received: from smtp104.prem.mail.ac4.yahoo.com ([76.13.13.43]:46180 "HELO
	smtp104.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750767Ab1HXNyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 09:54:44 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: zTDJY.YVM1lgaCfz.w0u9IYSx_RLAUVTzGxbHzKcZuRluZJ
 btVluiCC2R_Sx_m8nFZ_gc.34d59YAEcIdg_auYh0JoYtZ0Br9rsIZR2smcP
 3OlPQ9boZgt2e_30GAydgSOKqwTfh0tyL4u9L2wotV.9iWj6281Fq1SW5W1P
 Mjlt8XuU93PrPZc8jiRh_tCxGcbZgnPR.egkb_hnz4fxxNjZaRTN9L5ExNxx
 ee2WZeBJvKnQdwB1VP9moGEzGeB44UXOZmcQ7d2wLpmKbc7d1LvM4u6cy8fc
 8mkd4FM2gRg.0nW_DKnrnuwwCxNs.Rc3JNQCGrMRkUxx.jbnzpcFpVojmBzy
 zU8eMmWDEbpOJvVLsSfaWGHMoDmvlc8jbvcKb5uA6aQ44FQ--
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Wed, 24 Aug 2011 08:54:40 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 13/15] x86: add cmpxchg_flag() variant
In-Reply-To: <4E542D28.4090006@zytor.com>
Message-ID: <alpine.DEB.2.00.1108240854080.24118@router.home>
References: <cover.1314045780.git.jeremy.fitzhardinge@citrix.com> <738d736ecffa3bd32df76ae41188aa39c2ace941.1314054734.git.jeremy.fitzhardinge@citrix.com> <alpine.DEB.2.00.1108231355380.26421@router.home> <4E540548.4080402@goop.org> <4E541154.6090805@zytor.com>
 <4E542681.2090703@goop.org> <4E542D28.4090006@zytor.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Aug 2011, H. Peter Anvin wrote:

> On 08/23/2011 03:15 PM, Jeremy Fitzhardinge wrote:
> >
> > However, having prototyped it, I dunno, it doesn't really seem like much
> > of a win for all the extra code it adds.  I just can't get too excited
> > about an extra test instruction adjacent to a monster like a locked
> > cmpxchg.  The jump variant avoids the test, but gcc still generates some
> > pretty bogus stuff:
> >
>
> A compare is hardly a big cost, as you're quite correctly pointing out.

Could become relatively costly if the cmpxchg is not locked or the compare
involves comparing multiple words.

