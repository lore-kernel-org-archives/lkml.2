Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336Ab1KBLBN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 07:01:13 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34822 "EHLO
	earthlight.etchedpixels.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756301Ab1KBLAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 07:00:25 -0400
Date: Wed, 2 Nov 2011 11:00:55 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
Cc: Alan Cox <alan@linux.intel.com>, gregkh@suse.de,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com
Subject: Re: [PATCH 2/2] pch_uart: Delete modem status interrupt enable code
Message-ID: <20111102110055.153d06c6@lxorguk.ukuu.org.uk>
In-Reply-To: <4EB0DAB6.7000106@dsn.lapis-semi.com>
References: <1319697919-5623-1-git-send-email-tomoya-linux@dsn.lapis-semi.com>
	<1319697919-5623-2-git-send-email-tomoya-linux@dsn.lapis-semi.com>
	<20111101125757.4ef7f883@bob.linux.org.uk>
	<4EB0DAB6.7000106@dsn.lapis-semi.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Called ".get_mctrl" function, other software can know incoming carrier 
> detection.
> Or you mean a uart driver must detect incoming carrier with interrupt ?

If a user opens a tty port which has no carrier signal then the open is
supposed to block until the carrier is raised unless either clocal
termios or O_NDELAY open flags are set.

That usually means you need to take the carrier raise interrupt in order
to wake out of open in this case.

Alan
