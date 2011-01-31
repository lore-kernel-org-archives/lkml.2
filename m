Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756151Ab1AaTei (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 14:34:38 -0500
Received: from 184-106-158-135.static.cloud-ips.com ([184.106.158.135]:57444
	"EHLO mail" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754075Ab1AaTeh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 14:34:37 -0500
Date: Mon, 31 Jan 2011 19:35:07 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Soren Hansen <soren@linux2go.dk>, linux-kernel@vger.kernel.org,
        Dave Hansen <haveblue@us.ibm.com>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: nbd locking problems
Message-ID: <20110131193507.GA19778@mail.hallyn.com>
References: <AANLkTimP=5A-BNHUwV0qhvjw8y4HevMvXtOBpRr6vFYR@mail.gmail.com>
 <20110128211825.GA20707@mail.hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110128211825.GA20707@mail.hallyn.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Serge E. Hallyn (serge@hallyn.com):
> Quoting Soren Hansen (soren@linux2go.dk):

(Sorry, I seem to have stupidly deleted later replies)

> 
> As Dave just explained to me, BKL is released when you sleep :)  I
> assume that's how it gets released around the kthread_create().  I
> *think* you're right that the new mutex is superfluous, but I'd like to
> look through the ioctl code and make sure there's no shared state which
> we need to protect.  I don't see how there could be, or rather, if there
> were, then it was broken before.

Yup, removing nbd_mutex should be safe.  Esp since the
bdev->bd_disk->private_data doesn't get changed outside
of nbd_init().  Removing it looks safe.

thanks,
-serge
