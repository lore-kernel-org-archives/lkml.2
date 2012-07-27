Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686Ab2G0NFu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 09:05:50 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:50369 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113Ab2G0NFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 09:05:49 -0400
Date: Fri, 27 Jul 2012 14:09:31 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jaeden Amero <jaeden.amero@ni.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] n_tty: Don't lose characters when PARMRK is enabled
Message-ID: <20120727140931.19ed2bf4@pyramind.ukuu.org.uk>
In-Reply-To: <1343340751-1942-1-git-send-email-jaeden.amero@ni.com>
References: <y>
	<1343340751-1942-1-git-send-email-jaeden.amero@ni.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jul 2012 17:12:31 -0500
Jaeden Amero <jaeden.amero@ni.com> wrote:

> When PARMRK is set and large transfers of characters that will get
> marked are being received, n_tty could drop data silently (i.e.
> without reporting any error to the client). This is because
> characters have the potential to take up to three bytes in the line
> discipline (when they get marked with parity or framing errors), but
> the amount of free space reported to tty_buffer flush_to_ldisc (via
> tty->receive_room) is based on the pre-marked data size.
> 
> With this patch, the n_tty layer will no longer assume that each byte
> will only take up one byte in the line discipline. Instead, it will
> make an overly conservative estimate that each byte will take up
> three bytes in the line discipline when PARMRK is set.
> 
> Signed-off-by: Jaeden Amero <jaeden.amero@ni.com>

What a fun corner case. Patch looks good to me.

Acked-by: Alan Cox <alan@linux.intel.com>
