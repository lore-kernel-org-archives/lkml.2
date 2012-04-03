Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752177Ab2DCFmu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 01:42:50 -0400
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:60381 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176Ab2DCFms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 01:42:48 -0400
Date: Tue, 3 Apr 2012 07:42:42 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: gregkh@linuxfoundation.org, alan@linux.intel.com,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Martin Schwidefsky <schwidefsky@de.ibm.com>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH 25/69] TTY: con3215, remove tasklet for tty_wakeup
Message-ID: <20120403054241.GA2700@osiris.boeblingen.de.ibm.com>
References: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
 <1333367693-3244-26-git-send-email-jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1333367693-3244-26-git-send-email-jslaby@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12040305-5024-0000-0000-00000228727C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 02, 2012 at 01:54:09PM +0200, Jiri Slaby wrote:
> tty_wakeup is safe to be called from all contexts. No need to schedule
> a tasklet for that. Let us call it directly like in other drivers.
> 
> And delete the tasklet completely.

Your patch actually reverts Martin's recent commit 656d912537
"[S390] 3215 deadlock with tty_wakeup".
I'm quite sure the reason for the deadlock still exists.
Unfortunately the commit doesn't contain the call chain that
led to fix.

