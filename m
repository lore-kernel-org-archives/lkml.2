Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754322Ab0EPUmt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 16:42:49 -0400
Received: from casper.infradead.org ([85.118.1.10]:49423 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753594Ab0EPUms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 16:42:48 -0400
Date: Sun, 16 May 2010 13:45:40 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Alessio Igor Bogani <abogani@texware.it>
Cc: Oliver Neukum <oliver@neukum.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       Dominik Brodowski <linux@dominikbrodowski.net>,
       Bill Pemberton <wfp5p@virginia.edu>, Jiri Kosina <jkosina@suse.cz>,
       Javier Martinez Canillas <martinez.javier@gmail.com>,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: quatech_usb2: Convert eos semaphore to mutex
Message-ID: <20100516134540.7dd69473@infradead.org>
In-Reply-To: <AANLkTilSP7AYz08-aTNJ1fWCYrgbTebJznAIps1AbjoW@mail.gmail.com>
References: <1273959602-15465-1-git-send-email-abogani@texware.it>
	<201005152355.54762.oliver@neukum.org>
	<AANLkTilSP7AYz08-aTNJ1fWCYrgbTebJznAIps1AbjoW@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 May 2010 00:08:30 +0200
Alessio Igor Bogani <abogani@texware.it> wrote:

> Hi Oliver,
> 
> 2010/5/15 Oliver Neukum <oliver@neukum.org>:
> > Am Samstag, 15. Mai 2010 23:40:02 schrieb Alessio Igor Bogani:
> >> The eos semaphore is used as a mutex so replace it with a real
> >> mutex.
> >
> > Documentation/mutex-design.txt states that a mutex must not be used
> > from within an interrupt handler. Is this outdated?
> 
> You are right. Simply I didn't see irqreturn_t return type in function
> prototype.
> 
> Sorry for my mistake.
> 

you might want to convert it to a completion....
that sounds more the usage model that the driver here is doing


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
