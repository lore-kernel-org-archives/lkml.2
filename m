Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756748Ab1FIDy0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 23:54:26 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39834 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755799Ab1FIDyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 23:54:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ddxC8l2Va7KGvdceZ0sBvrFofldOefkjIHGsPZCLWJ09ogoQ1wBhrWOB9PNl0FWYrw
         tgl5ZaVLewz+nDhF8KBpSDL+OvDNQVXjgZtTmSisQ8zxmcJq/CbXP0aM9rqNHQjrCdGR
         XJXNxe2AlGdXhvH5BLf4v7Tc8cVCV3wuadnxY=
Subject: Re: Change in functionality of futex() system call.
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Andrew Lutomirski <luto@mit.edu>
Cc: Darren Hart <dvhart@linux.intel.com>, George Spelvin <linux@horizon.com>,
        david@rgmadvisors.com, kyle@moffetthome.net,
        linux-kernel@vger.kernel.org
In-Reply-To: <BANLkTik62dLMf5PCPGeW=9P=sF2QcnW42g@mail.gmail.com>
References: <20110609004435.14550.qmail@science.horizon.com>
	 <4DF037C6.4000507@linux.intel.com>
	 <BANLkTik62dLMf5PCPGeW=9P=sF2QcnW42g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 09 Jun 2011 05:54:19 +0200
Message-ID: <1307591659.3980.37.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 08 juin 2011 à 23:38 -0400, Andrew Lutomirski a écrit :

> Huh?
> 
> I still don't understand why userspace ought to need to deny read
> access to a file to prevent DoS.  I think it's entirely reasonable for
> userspace to make the assumption that users with read access cannot
> make changes visible to writers unless explicitly documented (i.e.
> file locking, which is so thoroughly broken that it shouldn't be taken
> as an example of how to design anything).
> 
> Given that current kernels make this use safe and the proposal is to
> make it unsafe, I think it's worth designing the interface to avoid
> introducing new security problems.

I am very tired of this discussion, you repeat the same arguments over
and over.

You can not prevent DOS on a machine if you allow a process to RO map
your critical files (where you put futexes), because you allow this
process to interfere with critical cache lines bouncing between cpus.

Really, please forget about this crazy idea of allowing foreigners to
_read_ or memory _map_ your files. Dont do it.



