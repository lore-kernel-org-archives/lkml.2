Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256Ab2JOMdE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 08:33:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35842 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753052Ab2JOMdB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 08:33:01 -0400
From: Oliver Neukum <oneukum@suse.de>
To: Ming Lei <ming.lei@canonical.com>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC PATCH 3/3] USB: forbid memory allocation with I/O during bus reset if storage interface exits
Date: Mon, 15 Oct 2012 14:30:57 +0200
Message-ID: <1921559.OPsFBnvatA@linux-lqwf.site>
Organization: SUSE
User-Agent: KMail/4.8.4 (Linux/3.6.0-rc4-12-desktop+; KDE/4.9.1; x86_64; ; )
In-Reply-To: <CACVXFVPi=fq1NP-nuWQi34xTpGgWbaceW1Hbzcq38RqQMF_T-w@mail.gmail.com>
References: <1350278059-14904-1-git-send-email-ming.lei@canonical.com> <2564763.3cNFlv543H@linux-lqwf.site> <CACVXFVPi=fq1NP-nuWQi34xTpGgWbaceW1Hbzcq38RqQMF_T-w@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 15 October 2012 20:06:36 Ming Lei wrote:
> On Mon, Oct 15, 2012 at 5:34 PM, Oliver Neukum <oneukum@suse.de> wrote:
> >
> > I think limiting this to devices which have a storage device is not
> > productive. What if you are using iSCSI or nbd? In the long run
> 
> You mean other non-mass storage or non-uas usb interfaces may
> be involved in iSCSI or nbd? If not, the patch should be OK.
> If yes, could you list them?

All network devices?

> > we will see busses attached to busses and as soon as the daughter
> > bus is hotpluggable you are thwarted anyway. Just do it unconditionally.
> 
> IMO, doing it unconditionally is not good because big chunk buffer
> is often allocated in probe() path.

It would be a chunk that has just been freed.

	Regards
		Oliver

