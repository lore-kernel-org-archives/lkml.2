Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932202Ab2FGNm5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 09:42:57 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:40217 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758095Ab2FGNm4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 09:42:56 -0400
MIME-Version: 1.0
In-Reply-To: <20120607040337.622672845@linuxfoundation.org>
References: <20120607041406.GA13233@kroah.com>
	<20120607040337.622672845@linuxfoundation.org>
Date: Thu, 7 Jun 2012 09:42:55 -0400
Message-ID: <CA+5PVA6A0K3WYBQJH8z3ddd2X3=fQm1a34z+fWSYGcUg4TR9+A@mail.gmail.com>
Subject: Re: [ 08/82] mm: pmd_read_atomic: fix 32bit PAE pmd walk vs
 pmd_populate SMP race condition
From: Josh Boyer <jwboyer@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Ulrich Obergfell <uobergfe@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Hugh Dickins <hughd@google.com>, Larry Woodman <lwoodman@redhat.com>,
        Petr Matousek <pmatouse@redhat.com>, Rik van Riel <riel@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 7, 2012 at 12:03 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> 3.4-stable review patch.  If anyone has any objections, please let me know.
>
> ------------------
>
> From: Andrea Arcangeli <aarcange@redhat.com>
>
> commit 26c191788f18129af0eb32a358cdaea0c7479626 upstream.
>
> When holding the mmap_sem for reading, pmd_offset_map_lock should only
> run on a pmd_t that has been read atomically from the pmdp pointer,
> otherwise we may read only half of it leading to this crash.

This one is important, but it can break Xen apparently:

http://permalink.gmane.org/gmane.comp.emulators.xen.devel/132522
https://bugzilla.redhat.com/show_bug.cgi?id=829016

Not sure if you want to hold off on it or see if Andrea comes up with
a follow up fix?

josh
