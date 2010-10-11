Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110Ab0JKX32 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 19:29:28 -0400
Received: from iona.labri.fr ([147.210.8.143]:57697 "EHLO iona.labri.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753449Ab0JKX31 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 19:29:27 -0400
X-Greylist: delayed 1743 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 Oct 2010 19:29:26 EDT
Date: Tue, 12 Oct 2010 01:00:17 +0200
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Tracey Dent <tdent48227@gmail.com>
Cc: greg@kroah.com, w.d.hubbs@gmail.com, chris@the-brannons.com,
        kirk@braille.uwo.ca, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] Staging: speakup: Added EXPORT_SYMBOL_GPL() markings.
Message-ID: <20101011230017.GT4721@const.famille.thibault.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Tracey Dent <tdent48227@gmail.com>, greg@kroah.com,
	w.d.hubbs@gmail.com, chris@the-brannons.com, kirk@braille.uwo.ca,
	linux-kernel@vger.kernel.org
References: <1286836590-6708-1-git-send-email-tdent48227@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1286836590-6708-1-git-send-email-tdent48227@gmail.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tracey Dent, le Mon 11 Oct 2010 18:36:30 -0400, a écrit :
> -void speakup_clear_selection(void)
> -{
> -	sel_start = -1;
> -}

Mmm, this won't be so simple actually, as speakup_set_selection and
speakup_paste_selection will still be using speakup/selection.c's
sel_start variable.  I guess all speakup/selection.c will need to be
migrated to using drivers/char/selection.c functions at the same time.

speakup_paste_selection is basically like paste_selection, except that
it can be called with in_atomic() being true.  Yes, it's a hack.  The
calls to speakup_past_selection should first be moved to a helper
thread, and then the main paste_selection function can be used instead.

speakup_set_selection is basically like set_selection, except that it
doesn't take a userland structure, but gets the values from kernelland
speakup.  A kernel-land variant of set_selection should probably be
defined that takes a kernelland structure. Apart from that, I don't
think speakup_set_selection has anything particular compared to the main
version.  Kirk, can you confirm?

Samuel
