Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760903Ab2FGObE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 10:31:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25396 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753395Ab2FGObC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 10:31:02 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: mihailov ivan <mihailov.iaa@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] change lock model in aio_put_req
References: <CA+Z7AcYDcZiAxPr+Au8PKoNzoT6G_0F0dAn75nb9ktXp9kBf9g@mail.gmail.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Thu, 07 Jun 2012 10:31:00 -0400
In-Reply-To: <CA+Z7AcYDcZiAxPr+Au8PKoNzoT6G_0F0dAn75nb9ktXp9kBf9g@mail.gmail.com>
	(mihailov ivan's message of "Wed, 6 Jun 2012 22:46:52 +0000")
Message-ID: <x497gvjb3dn.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mihailov ivan <mihailov.iaa@gmail.com> writes:

> Why used spin_lock/unlock_irq instead of
> spin_lock_irqsave/spin_unlock_irqrestore?

Because the function is never called from interrupt context.

> __aio_put_req it's interrupt safe call but why aio_put_req not?

__aio_put_req is called with the ctx lock already taken.  This (the __
routine being called with the lock held) is a fairly common convention
in the kernel.

Nack.  Your patch doesn't fix anything.

Cheers,
Jeff
