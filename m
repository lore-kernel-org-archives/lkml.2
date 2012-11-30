Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755204Ab2K3BOa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 20:14:30 -0500
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:49090 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752859Ab2K3BO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 20:14:28 -0500
Message-ID: <1354238054.2860.18.camel@thor>
Subject: Re: [PATCH] tty: Correct tty buffer flushing.
From: Peter Hurley <peter@hurleysoftware.com>
To: Alan Cox <alan@linux.intel.com>
Cc: Ilya Zykov <ilya@ilyx.ru>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Xiaobing Tu <xiaobing.tu@intel.com>, Jiri Slaby <jslaby@suse.cz>,
        Alek Du <alek.du@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Date: Thu, 29 Nov 2012 20:14:14 -0500
In-Reply-To: <20121129212809.5bc12088@bob.linux.org.uk>
References: <50B55A93.4090900@ilyx.ru> <50B6A652.9000107@ilyx.ru>
	 <20121129135418.4237e7f8@pyramind.ukuu.org.uk> <50B76D96.20809@ilyx.ru>
	 <20121129212809.5bc12088@bob.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.2.4-0build1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Authenticated-User: 125194 peter@hurleysoftware.com
X-MT-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-11-29 at 21:28 +0000, Alan Cox wrote:
> > Sorry, In you reply not all patch.
> > Main idea here -  we never flash last (struct tty_buffer) in the
> > active buffer. Only data for ldisc. (tty->buf.head->read =
> > tty->buf.head->commit). At that moment driver can collect(write) data
> > in buffer without conflict.
> 
> Ah.. now I understand. Yes that makes sense.  I will think about that
> carefully. This is why a good explanation with a patch is important.

FWIW, I've been running this on -next. The logic seems sound to me --
fundamentally, this technique is what flush_to_ldisc() does.

Regards,
Peter Hurley


