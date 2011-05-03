Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752900Ab1ECOHR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 10:07:17 -0400
Received: from cantor.suse.de ([195.135.220.2]:48572 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752664Ab1ECOHL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 10:07:11 -0400
Date: Tue, 3 May 2011 07:06:08 -0700
From: Greg KH <gregkh@suse.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Valdis.Kletnieks@vt.edu, LKML <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC][PATCH] PM: Print a warning if firmware is requested when
 tasks are frozen
Message-ID: <20110503140608.GB7944@suse.de>
References: <201105030044.51661.rjw@sisk.pl>
 <50363.1304379012@localhost>
 <201105031302.08910.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201105031302.08910.rjw@sisk.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 03, 2011 at 01:02:08PM +0200, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> Subject: PM: Print a warning if firmware is requested when tasks are frozen
> 
> Some drivers erroneously use request_firmware() from their ->resume()
> (or ->thaw(), or ->restore()) callbacks, which is not going to work
> unless the firmware has been built in.  This causes system resume to
> stall until the firmware-loading timeout expires, which makes users
> think that the resume has failed and reboot their machines
> unnecessarily.  For this reason, make _request_firmware() print a
> warning and return immediately with error code if it has been called
> when tasks are frozen and it's impossible to start any new usermode
> helpers.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

I'm guessing you will take this through your tree?  If so, that's great:

Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
