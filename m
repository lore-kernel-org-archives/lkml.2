Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932187Ab0ELWYt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 18:24:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52860 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756694Ab0ELWYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 18:24:48 -0400
Date: Wed, 12 May 2010 15:24:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Eduardo Valentin <eduardo.valentin@nokia.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-arm-kernel@lists.infradead.org,
       Linux-OMAP <linux-omap@vger.kernel.org>,
       Russell King <linux@arm.linux.org.uk>,
       ext Tony Lindgren <tony@atomide.com>,
       ext Kevin Hilman <khilman@deeprootsystems.com>,
       Peter De-Schrijver <Peter.De-Schrijver@nokia.com>,
       santosh.shilimkar@ti.com, Ambresh <a0393775@ti.com>,
       felipe.balbi@nokia.com, Jouni Hogander <jouni.hogander@nokia.com>,
       Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCHv5 0/3] Introduce the /proc/socinfo and use it to export
 OMAP data
Message-Id: <20100512152424.803ea807.akpm@linux-foundation.org>
In-Reply-To: <1273587331-24604-1-git-send-email-eduardo.valentin@nokia.com>
References: <1273587331-24604-1-git-send-email-eduardo.valentin@nokia.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 May 2010 17:15:28 +0300
Eduardo Valentin <eduardo.valentin@nokia.com> wrote:

> Here is the version 5 of the change to export OMAP data to userspace
> (name, revision, id code, production id and die id).
> 
> Basically, this version is still attempting to create a new file under /proc.
> It is the /proc/socinfo, which should be used to export bits which are SoC specific
> (not CPU related, nor machine related).
> 
> So, differences between previous version are:
> - merged patch 02/04 with 03/04 to avoid compilation breakages.
> - simplified the seq_file usage by using the single_open and single_release functions
> - exported a function to register a seq_operation .show callback
> - adapted the changes accordingly
> 
> As usual, comments are welcome.

This changelog would be rather more useful if it was to show us some
sample output from /proc/socinfo, perhaps accompanied with an
explanation for people who aren't familar with this area of the kernel.

I'd have thought that sysfs was an appropriate place for this info. 
Perhaps under /sys/devices/platform?  Or /sys/devices/system?  Peter's
original patch didn't tell us where in the hierarchy the file was
placed, nor why it was placed there, not what its contents look like. 
But crappy changelogs are the norm :(

The objections stated in this email:
http://www.mail-archive.com/linux-omap@vger.kernel.org/msg17630.html
appear to still apply to this version of the patches?

Kevin didn't explain why he said "Please export these via debugfs". 
Tony didn't clearly explain why he said "I don't think we want to
export unique chip identifiers by default".



So apart from having certain opinions regarding communication skills
and wondering why people cc me on stuff without vaguely providing
enough info for me to understand what they're thinking, I don't know
what to make of it all :(
