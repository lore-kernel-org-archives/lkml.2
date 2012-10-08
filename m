Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752971Ab2JHTqA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 15:46:00 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:40128 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750941Ab2JHTp6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 15:45:58 -0400
Message-ID: <1349725550.15802.21.camel@joe-AO722>
Subject: Re: [PATCH 1/2] random: make it possible to enable debugging
 without rebuild
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org
Date: Mon, 08 Oct 2012 12:45:50 -0700
In-Reply-To: <alpine.LNX.2.00.1210081637170.28357@pobox.suse.cz>
References: <alpine.LNX.2.00.1210081637170.28357@pobox.suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-10-08 at 16:39 +0200, Jiri Kosina wrote:
> The module parameter that turns debugging mode (which basically means 
> printing a few extra lines during runtime) is in '#if 0' block. Forcing 
> everyone who would like to see how entropy is behaving on his system seems 
> to be a little bit too harsh.
> If we were concerned about speed, we could potentially turn 'debug' into
> a static key, but I don't think it's necessary.
> 
> Drop the '#if 0' block to allow using the 'debug' parameter without rebuilding.

I'd also convert the printk(KERN_DEBUG to pr_debug
to avoid penalizing non-debug builds altogether.



