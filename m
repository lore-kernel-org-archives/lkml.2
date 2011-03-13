Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529Ab1CMHTJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 03:19:09 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:35523 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195Ab1CMHTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 03:19:05 -0400
Date: Sun, 13 Mar 2011 08:19:02 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] genksyms: Track changes to enum constant
Message-ID: <20110313071902.GA3377@merkur.ravnborg.org>
References: <1299997825-18977-1-git-send-email-mmarek@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299997825-18977-1-git-send-email-mmarek@suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal.

Patch serie looks good.
You can add my ack to all of them if you do a second round.


On Sun, Mar 13, 2011 at 07:30:18AM +0100, Michal Marek wrote:
> This series makes genksyms remember the values of enum constants and use them
> during symbol expansion. This makes sure that patches like
> 
> | enum e {
> |  	E1,
> | 	E2,
> |+	E3,
> | 	E_MAX
> | };
> |
> | struct s {
> | 	int a[E_MAX];
> | }
> |
> | int f(struct s *s) { ... }
> | EXPORT_SYMBOL(f)
> 
> change the checksum of the exported symbol. Previously, it would just use the
> string "E_MAX" in the calculation and the change would go unnoticed. The main
> part is in patches 6/7 and 7/7, the rest are cleanups and preparatory patches.

This nice explanation would be good to include in the changelog
of 7/8 so "git log" give a better intro to the changes.

	Sam
