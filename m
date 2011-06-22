Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757882Ab1FVNFs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 09:05:48 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:57957 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411Ab1FVNFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 09:05:45 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Ohad Ben-Cohen" <ohad@wizery.com>
Subject: Re: [RFC 0/8] Introducing a generic AMP/IPC framework
Date: Wed, 22 Jun 2011 15:05:32 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, akpm@linux-foundation.org,
        Brian Swetland <swetland@google.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        "davinci-linux-open-source" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Rusty Russell <rusty@rustcorp.com.au>
References: <1308640714-17961-1-git-send-email-ohad@wizery.com> <201106211620.02065.arnd@arndb.de> <BANLkTim1kN2f41Cfz70=g4a_+gPPrWDacA@mail.gmail.com>
In-Reply-To: <BANLkTim1kN2f41Cfz70=g4a_+gPPrWDacA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106221505.32531.arnd@arndb.de>
X-Provags-ID: V02:K0:lOfARYAZeuoUPNuUivJApOw8fR8ZW2HViiV82JDxJ/w
 0fsADjs2wsIgOV26lBgiANwPskNKrt9ZOmMJuMTmmEIw1fjKMu
 crcPnBXWYe3STsj7cYa+YhWyVNy/vGxy249eIyKlKystaxVu/E
 fdXwDajV+GL27Uoq1qiBrKQWlakWm3yFnVNRSiq9c+zEHgIqe+
 RfPyTA0F8qNg0HjD+ENDA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 22 June 2011, Ohad Ben-Cohen wrote:
> > One point I noticed is the use of debugfs, which you should probably
> > replace at some point with a stable API, e.g. your own debugfs-like
> > file system, but there is no hurry to do that now.
> 
> debugfs is only being used to expose debugging info (namely the power
> state of the remote processor and its trace log messages), which is
> mostly useful for developers trying to understand what went wrong.
> 
> It seems like debugfs fits quite nicely here (e.g. it's perfectly fine
> if this is completely compiled out on production systems), but sure,
> we can always revisit this later too.

Ok, I see. In that case I agree that using debugfs is fine, but I would
recommend trying to use fewer macros and just open-coding the file
operations for better readability.

> > Unfortunately require __packed. It would be better to sort the members
> > differently so that each member is naturally aligned in order to
> > avoid the need for padding or __packed attributes
> 
> Definitely. __packed is being used just to be on the safe side; we
> didn't intend to introduce unnatural alignment intentionally. will be
> fixed.

Ok.

	Arnd
