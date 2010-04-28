Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361Ab0D1PeK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 11:34:10 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:36270 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755190Ab0D1PeH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 11:34:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=Hss+STcul4qpExnf46qlaH3YL2oaamkIyGaJDIsvK5aly7B+1APGbFJ3URgGCBgnhY
         UxSLInAOthsh+qLg11cvfZVQYLa/PKE1W9lBEvJUlfxWVBzYAuCbTie74tpoVZykivE5
         KLUGeKGdkidxtjiD6RP4R+vb0NsO8FJ5TjAH0=
MIME-Version: 1.0
In-Reply-To: <14370.1272466806@redhat.com>
References: <1272430986-20436-1-git-send-email-xiaosuo@gmail.com> 
	<8526.1272447122@redhat.com> <q2r412e6f7f1004280656t331e9120rc9eab069fb4d4de3@mail.gmail.com> 
	<6096.1272463619@redhat.com> <v2x412e6f7f1004280753pd3438a3fv860edc580ecd6185@mail.gmail.com> 
	<14370.1272466806@redhat.com>
From: Changli Gao <xiaosuo@gmail.com>
Date: Wed, 28 Apr 2010 23:33:37 +0800
Message-ID: <p2w412e6f7f1004280833y4bdbcc6s6d99f2b6283a283@mail.gmail.com>
Subject: Re: [RFC] sched: implement the exclusive wait queue as a LIFO queue
To: David Howells <dhowells@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Alexander Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Roland Dreier <rolandd@cisco.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "David S. Miller" <davem@davemloft.net>,
       Eric Dumazet <dada1@cosmosbay.com>, Christoph Lameter <cl@linux.com>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Thomas Gleixner <tglx@linutronix.de>, Takashi Iwai <tiwai@suse.de>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 28, 2010 at 11:00 PM, David Howells <dhowells@redhat.com> wrote:
>
> But is it actually used in both modes at the same time?
>

It should be seldom in good applications. So I only need to add a
function, like this:

add_wait_queue_head_exclusive(wq, wait)
   first_exclusive = find_the_first_exclusive(wq); // it is fast, as
there should no or few non-exclusive wait queues
   list_add(wait, first_exclusive);


-- 
Regards，
Changli Gao(xiaosuo@gmail.com)
