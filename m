Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753287Ab2LDSV4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 13:21:56 -0500
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:34738 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751997Ab2LDSVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 13:21:55 -0500
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmztM8TOFHjy0MEysz
X-RZG-CLASS-ID: mo00
Date: Tue, 4 Dec 2012 19:21:51 +0100
From: Olaf Hering <olaf@aepfle.de>
To: Jan Beulich <JBeulich@suse.com>
Cc: konrad.wilk@oracle.com, xen-devel@lists.xen.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xen/blkback: do not leak mode property
Message-ID: <20121204182151.GA25878@aepfle.de>
References: <1354563168-6609-1-git-send-email-olaf@aepfle.de>
 <50BDDEBF02000078000ADAAC@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <50BDDEBF02000078000ADAAC@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21.rev5558 (2012-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 04, Jan Beulich wrote:

> This looks necessary but insufficient - there's nothing really
> preventing backend_changed() from being called more than once
> for a given device (is simply the handler of xenbus watch). Hence
> I think either that function needs to be guarded against multiple
> execution (e.g. by removing the watch from that function itself,
> if that's permitted by xenbus), or to properly deal with the
> effects this has (including but probably not limited to the leaking
> of be->mode).

If another watch does really trigger after the kfree(be) in
xen_blkbk_remove(), wouldnt backend_changed access stale memory?
So if that can really happen in practice, shouldnt the backend_watch be
a separate allocation instead being contained within backend_info?

Looking at unregister_xenbus_watch, it clears removes the watch from the
list, so that process_msg will not see it anymore.

Olaf
