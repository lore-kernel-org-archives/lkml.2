Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759651Ab2FGK1H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 06:27:07 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57008 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753710Ab2FGK1G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 06:27:06 -0400
Message-ID: <1339064814.23343.14.camel@twins>
Subject: Re: processes hung after sys_renameat, and 'missing' processes
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@suse.cz>, Jan Kara <jack@suse.cz>
Date: Thu, 07 Jun 2012 12:26:54 +0200
In-Reply-To: <CA+55aFx_oREEd2XS_aG7PJ7dwzWjgx689V_uRPGWpVS01_++6A@mail.gmail.com>
References: <20120603223617.GB7707@redhat.com>
	 <CA+55aFwCusEdMq3_3TAXSZ=+kbN7H6AbnngVaagAZw=ZpicckQ@mail.gmail.com>
	 <20120603231709.GP30000@ZenIV.linux.org.uk>
	 <20120603232820.GQ30000@ZenIV.linux.org.uk>
	 <20120606194233.GA1537@redhat.com>
	 <CA+55aFwxFVLPk4-dp73uccKXepKwjpGFgh0NW1u8d0zYzr=hBA@mail.gmail.com>
	 <20120606230040.GA18089@redhat.com>
	 <CA+55aFx_oREEd2XS_aG7PJ7dwzWjgx689V_uRPGWpVS01_++6A@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-06 at 16:31 -0700, Linus Torvalds wrote:
> PeterZ - the fact that we use mutex_lock_nested with
> I_MUTEX_PARENT/I_MUTEX_CHILD/nothing hopefully doesn't screw us up in
> case we get it wrong, right? 

Sadly, if you get that annotation wrong you can annotate an actual
deadlock away. This the reason you have to be very careful when
annotating stuff.
