Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319Ab0FESoK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 14:44:10 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55020 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753496Ab0FESoG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 14:44:06 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Nigel Cunningham <ncunningham@crca.org.au>
Subject: Re: [linux-pm] [SUSPECTED SPAM] Re: Proposal for a new algorithm 
 =?utf-8?q?for=09reading_=26_writing_a_hibernation?= image.
Date: Sat, 5 Jun 2010 20:45:19 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.35-rc1-rjw; KDE/4.3.5; x86_64; ; )
Cc: Pavel Machek <pavel@ucw.cz>, pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "TuxOnIce-devel" <tuxonice-devel@tuxonice.net>
References: <9rpccea67yy402c975fqru8r.1275576653521@email.android.com> <4C099867.4050807@crca.org.au>
In-Reply-To: <4C099867.4050807@crca.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201006052045.19889.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 05 June 2010, Nigel Cunningham wrote:
> Hi again.
> 
> As I think about this more, I reckon we could run into problems at 
> resume time with reloading the image. Even if some bits aren't modified 
> as we're writing the image, they still might need to be atomically 
> restored. If we make the atomic restore part too small, we might not be 
> able to do that.
> 
> So perhaps the best thing would be to stick with the way TuxOnIce splits 
> the image at the moment (page cache / process pages vs 'rest'), but 
> using this faulting mechanism to ensure we do get all the pages that are 
> changed while writing the first part of the image.

I still don't quite understand why you insist on saving the page cache data
upfront and re-using the memory occupied by them for another purpose.  If you
dropped that requirement, I'd really have much less of a problem with the
TuxOnIce's approach.

Rafael
