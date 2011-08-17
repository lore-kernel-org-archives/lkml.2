Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244Ab1HQMwZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 08:52:25 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:24458 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126Ab1HQMwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 08:52:24 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmztM8TOFPjzEQErKX0w==
X-RZG-CLASS-ID: mo00
Date: Wed, 17 Aug 2011 14:51:27 +0200
From: Olaf Hering <olaf@aepfle.de>
To: Ian Campbell <Ian.Campbell@citrix.com>, Keir Fraser <keir.xen@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>, Konrad <konrad.wilk@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: [Xen-devel] [PATCH 1/3] xen/pv-on-hvm kexec: prevent crash in
 xenwatch_thread() when stale watch events arrive
Message-ID: <20110817125127.GA3163@aepfle.de>
References: <1313500613-21394-1-git-send-email-olaf@aepfle.de>
 <1313500613-21394-2-git-send-email-olaf@aepfle.de>
 <1313504072.5010.120.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1313504072.5010.120.camel@zakaz.uk.xensource.com>
User-Agent: Mutt/1.5.21.rev5535 (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 16, Ian Campbell wrote:

> On Tue, 2011-08-16 at 14:16 +0100, Olaf Hering wrote:
> > During repeated kexec boots xenwatch_thread() can crash because
> > xenbus_watch->callback is cleared by xenbus_watch_path() if a node/token
> > combo for a new watch happens to match an already registered watch from
> > an old kernel.  In this case xs_watch returns -EEXISTS, then
> > register_xenbus_watch() does not remove the to-be-registered watch from
> > the list of active watches but returns the -EEXISTS to the caller
> > anyway.
> 
> Isn't this behaviour the root cause of the issue (which should be fixed)
> rather than papering over it during watch processing. IOW should't
> register_xenbus_watch cleanup after itself if xs_watch fails.

Keir, the EEXISTS case in register_xenbus_watch() was added by you 6
years ago. Do you happen to know what it tried to solve, and do these
conditions still apply today?  Perhaps the EEXISTS can be removed now.

http://xenbits.xen.org/hg/xen-unstable.hg/diff/8016551fde98/linux-2.6-xen-sparse/drivers/xen/xenbus/xenbus_xs.c

Olaf
