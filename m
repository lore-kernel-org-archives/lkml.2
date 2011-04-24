Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338Ab1DXGEd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Apr 2011 02:04:33 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:54252 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056Ab1DXGEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Apr 2011 02:04:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=pNNaWT6yyd9dB7mB7Q7Apl6EJXDBz2Izh9I4aqUtQhQE/HaIzHijSjmvWe97sRLshw
         XFqfvEr+raUPmrITfagSVl/De53huS8DTQX/86f8f0tc77ziUvlwA+XPaD9IW5yNjH53
         rpvz0gdiEW1KlMTeoqZ/tkrVIfXIyC4ny9Xb8=
MIME-Version: 1.0
In-Reply-To: <4DB3AF8B.6020105@gmail.com>
References: <1303317178.2587.30.camel@mulgrave.site> <alpine.DEB.2.00.1104201410350.31768@chino.kir.corp.google.com>
 <20110421220351.9180.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1104211237250.5829@chino.kir.corp.google.com>
 <alpine.DEB.2.00.1104211500170.5741@router.home> <alpine.DEB.2.00.1104211411540.20201@chino.kir.corp.google.com>
 <alpine.DEB.2.00.1104211501470.20201@chino.kir.corp.google.com>
 <4DB3840F.3060503@gmail.com> <BANLkTi=vm-qs48-JySCpv+YHyC+9sO9U0A@mail.gmail.com>
 <4DB3A09A.70308@gmail.com> <4DB3AF8B.6020105@gmail.com>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Sun, 24 Apr 2011 15:04:10 +0900
Message-ID: <BANLkTinsryqSrnCnEoawJx6UfoH2iJ8dQA@mail.gmail.com>
Subject: Re: [patch] m68k, mm: set all online nodes in N_NORMAL_MEMORY
To: Michael Schmitz <schmitzmic@googlemail.com>
Cc: David Rientjes <rientjes@google.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Roman Zippel <zippel@linux-m68k.org>, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org, schwab@linux-m68k.org,
        "tg@mirbsd.de >> Thorsten Glaser" <tg@mirbsd.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/4/24 Michael Schmitz <schmitzmic@googlemail.com>:
> Michael Schmitz wrote:
>>
>> Besides, your solution would set N_HIGH_MEMORY not N_NORMAL_MEMORY if I
>> read free_area_init_nodes() right. Does that matter?
>
> check_for_regular_memory() does take care of that - so it would be all the
> same in the end. Whether it's worth it for a handful of nodes at best I'm
> unsure. I'll leave that for Geert to decide.

check_for_regular_memory() doesn't. It is CONFIG_HIGHMEM specific.
The trick is in node_status definition. N_NORMAL_MEMORY and
N_HIGHMEMORY share the same value. then
node_set_state(nid, N_HIGH_MEMORY) turn on both normal and
highmem bitmask.

--------------------------------------------------------------------
enum node_states {
        N_POSSIBLE,             /* The node could become online at some point */
        N_ONLINE,               /* The node is online */
        N_NORMAL_MEMORY,        /* The node has regular memory */
#ifdef CONFIG_HIGHMEM
        N_HIGH_MEMORY,          /* The node has regular or high memory */
#else
        N_HIGH_MEMORY = N_NORMAL_MEMORY,
#endif
        N_CPU,          /* The node has one or more cpus */
        NR_NODE_STATES
};
