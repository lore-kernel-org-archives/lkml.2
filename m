Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751448Ab0KIMyO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 07:54:14 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:64926 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165Ab0KIMyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 07:54:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:in-reply-to:references:user-agent:date
         :message-id:mime-version:content-type;
        b=j0pTBtG2eO6dFVS7b8ft2+cV63ZcU48X3CbRSiNkQj720UWQCWMmLYDWYtTiy1TXdf
         TOqZu8+GkAEEr9NXBwKRUFGXzauj1nlxkcbXoQLsQ/UDNcADnq66KiMBWlJMOaPctJIg
         f3LBcLyTnIieV/CDhPty0yY1azvJDuEWNsiVE=
From: Ben Gamari <bgamari.foss@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
        rsync@lists.samba.org, linux-mm@kvack.org
Subject: Re: fadvise DONTNEED implementation (or lack thereof)
In-Reply-To: <20101109162525.BC87.A69D9226@jp.fujitsu.com>
References: <87lj597hp9.fsf@gmail.com> <20101109162525.BC87.A69D9226@jp.fujitsu.com>
User-Agent: Notmuch/0.3.1-158-g04cd99c (http://notmuchmail.org) Emacs/23.1.1 (x86_64-pc-linux-gnu)
Date: Tue, 09 Nov 2010 07:54:07 -0500
Message-ID: <877hgmr72o.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  9 Nov 2010 16:28:02 +0900 (JST), KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> So, I don't think application developers will use fadvise() aggressively
> because we don't have a cross platform agreement of a fadvice behavior.
> 
I strongly disagree. For a long time I have been trying to resolve
interactivity issues caused by my rsync-based backup script. Many kernel
developers have said that there is nothing the kernel can do without
more information from user-space (e.g. cgroups, madvise). While cgroups
help, the fix is round-about at best and requires configuration where
really none should be necessary. The easiest solution for everyone
involved would be for rsync to use FADV_DONTNEED. The behavior doesn't
need to be perfectly consistent between platforms for the flag to be
useful so long as each implementation does something sane to help
use-once access patterns.

People seem to mention frequently that there are no users of
FADV_DONTNEED and therefore we don't need to implement it. It seems like
this is ignoring an obvious catch-22. Currently rsync has no fadvise
support at all, since using[1] the implemented hints to get the desired
effect is far too complicated^M^M^M^Mhacky to be considered
merge-worthy. Considering the number of Google hits returned for
fadvise, I wouldn't be surprised if there were countless other projects
with this same difficulty. We want to be able to tell the kernel about
our useage patterns, but the kernel won't listen.

Cheers,

- Ben

[1] http://insights.oetiker.ch/linux/fadvise.html
