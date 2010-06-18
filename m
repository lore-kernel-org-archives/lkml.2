Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761117Ab0FRMOS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 08:14:18 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:38426 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761102Ab0FRMOR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 08:14:17 -0400
Date: Fri, 18 Jun 2010 13:14:03 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: "Gleb O. Raiko" <raiko@niisi.msk.ru>
Cc: David Daney <ddaney@caviumnetworks.com>, Jesper Nilsson <jesper@jni.nu>,
       linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: MIPS: return after handling coprocessor 2 exception
Message-ID: <20100618121403.GC4466@linux-mips.org>
References: <20100617132554.GB24162@jni.nu>
 <4C1A57AE.9080706@caviumnetworks.com>
 <4C1B263E.7070906@niisi.msk.ru>
 <20100618100053.GA4466@linux-mips.org>
 <4C1B4C0A.9070506@niisi.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C1B4C0A.9070506@niisi.msk.ru>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 18, 2010 at 02:35:54PM +0400, Gleb O. Raiko wrote:

> >static int default_cu2_call(struct notifier_block *nfb, unsigned long action,
> >         void *data)
> >{
> >	...
> >
> >	return NOTIFY_OK | NOTIFY_STOP;
> NOTIFY_STOP implies NOTIFY_OK, so
> 	return NOTIFY_STOP;
> shall be enough.

Correct - I was thinking NOTIFY_STOP_MASK.

> >}
> 
> >The notifier list could also be used for example by perf
> 
> Or octeon cop2 handler that just sends NOTIFY_BAD for getting the
> same behavior.

Bad karma to return an error for where none happened.

  Ralf
