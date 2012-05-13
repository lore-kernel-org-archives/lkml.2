Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064Ab2EMXSF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 19:18:05 -0400
Received: from beauty.rexursive.com ([150.101.121.179]:54065 "EHLO
	beauty.rexursive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753772Ab2EMXSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 19:18:03 -0400
Message-ID: <1336951080.2190.4.camel@shrek.rexursive.com>
Subject: Re: [PATCH]: In kernel hibernation, suspend to both
From: Bojan Smojver <bojan@rexursive.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Linux PM list <linux-pm@vger.kernel.org>, linux-kernel@vger.kernel.org,
        bp@alien8.de
Date: Mon, 14 May 2012 09:18:00 +1000
In-Reply-To: <201205131510.37664.rjw@sisk.pl>
References: <1336515735.2097.23.camel@shrek.rexursive.com>
	 <201205122347.08176.rjw@sisk.pl>
	 <8b0184d9-0c54-4f6e-b0b7-ce1b7d854b9e@email.android.com>
	 <201205131510.37664.rjw@sisk.pl>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-05-13 at 15:10 +0200, Rafael J. Wysocki wrote:
> > So, a suspend after the image write will be just one long "failure",
> after
> > which hibernation code has to unwind again. No?
> 
> Hmm.  Good question.  It should be like this I think, although there
> may be some corner cases lurking.

AFAICT, the user space suspend to both works this way.

If I understand thing correctly, at the point of suspend to memory, we
are not really running a full system any more. All the processes have
been frozen and they've been told that hibernation is in progress. Ditto
devices, minus the ones we use to write to swap. So, when hibernation
code unwinds post resume from memory, it would be doing the correct
thing.

Srivatsa, does that make sense to you?

-- 
Bojan

