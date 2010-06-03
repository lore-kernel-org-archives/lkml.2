Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751941Ab0FCEkn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 00:40:43 -0400
Received: from SMTP.ANDREW.CMU.EDU ([128.2.11.61]:46797 "EHLO
	smtp.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827Ab0FCEkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 00:40:41 -0400
Date: Thu, 3 Jun 2010 00:40:02 -0400
From: Ben Blum <bblum@andrew.cmu.edu>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Paul Menage <menage@google.com>, Ben Blum <bblum@andrew.cmu.edu>,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       akpm@linux-foundation.org, ebiederm@xmission.com, lizf@cn.fujitsu.com,
       matthltc@us.ibm.com
Subject: Re: [RFC] [PATCH 2/2] cgroups: make procs file writable
Message-ID: <20100603044001.GA21006@ghc02.ghc.andrew.cmu.edu>
References: <20100530013002.GA762@ghc01.ghc.andrew.cmu.edu>
 <20100530013303.GC762@ghc01.ghc.andrew.cmu.edu>
 <20100531175242.GA14691@redhat.com>
 <20100531180446.GA16249@redhat.com>
 <AANLkTimcrX0TjzDMNJdubR92pAO4IPATbVpyvvVt0qIV@mail.gmail.com>
 <20100602140659.GA5324@redhat.com>
 <AANLkTin-T6ij3xf0ceGoCamwcoayxyf0GdAKY6yXDMVl@mail.gmail.com>
 <20100602202048.GB28663@redhat.com>
 <AANLkTimrJFiidM8BlUNvmzfapUAv8369R9PYnTscasEf@mail.gmail.com>
 <20100602205855.GA30039@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100602205855.GA30039@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-PMX-Version: 5.5.9.388399, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2010.6.3.42715
X-SMTP-Spam-Clean: 8% (
 BODYTEXTP_SIZE_3000_LESS 0, BODY_SIZE_1000_LESS 0, BODY_SIZE_2000_LESS 0, BODY_SIZE_400_499 0, BODY_SIZE_5000_LESS 0, BODY_SIZE_7000_LESS 0, __BOUNCE_CHALLENGE_SUBJ 0, __BOUNCE_NDR_SUBJ_EXEMPT 0, __CD 0, __CT 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID 0, __TO_MALFORMED_2 0, __USER_AGENT 0)
X-SMTP-Spam-Score: 8%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 02, 2010 at 10:58:55PM +0200, Oleg Nesterov wrote:
> Hmm. The usage of ->thread_group in ->can_attach() methods doesn't
> look safe to me... but currently bool threadgroup is always false.
> 
> Oleg.
> 
> 

I recall putting a rcu_read_lock() around that part and being assured
that made it safe. But I don't remember the details. Maybe taking
tasklist_lock is necessary?

-- Ben
