Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756854Ab2AXOsg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 09:48:36 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:60447 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753646Ab2AXOse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 09:48:34 -0500
X-Authenticated: #28250155
X-Provags-ID: V01U2FsdGVkX18CWs1In0MCQt+BFCNa2xNfqFT053FRpTQlOqp0Cm
	AFfLzkm8wZQVIz
From: Sven Joachim <svenjoac@gmx.de>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, linux-scsi@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>,
        James Bottomley <JBottomley@parallels.com>
Subject: Re: [091/129] block: fail SCSI passthrough ioctls on partition devices
References: <20120124023932.023409422@clark.kroah.org>
	<1327410067-5957-1-git-send-email-pbonzini@redhat.com>
Date: Tue, 24 Jan 2012 15:48:30 +0100
In-Reply-To: <1327410067-5957-1-git-send-email-pbonzini@redhat.com> (Paolo
	Bonzini's message of "Tue, 24 Jan 2012 14:01:06 +0100")
Message-ID: <87fwf5b1hd.fsf@turtle.gmx.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-01-24 14:01 +0100, Paolo Bonzini wrote:

> You need to return -ENOTTY from scsi_verify_blk_ioctl and -ENOIOCTLCMD from
> sd_compat_ioctl, because -ENOIOCTLCMD will not be handled correctly by
> block/ioctl.c.  This would break BLKROSET and BLKFLSBUF done by non-root
> but with the appropriate capabilities.
>
> Fixed patch follows.  If you prefer that I send an interdiff, let me know.

An interdiff might not be necessary, but please ensure that the patch
does not get mangled by turning all tabs into spaces, like in this
case. :-/

Cheers,
       Sven
