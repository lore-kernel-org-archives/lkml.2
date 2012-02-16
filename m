Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753808Ab2BPPOR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 10:14:17 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:36865 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752739Ab2BPPOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 10:14:12 -0500
Date: Thu, 16 Feb 2012 16:14:25 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Hillf Danton <dhillf@gmail.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Andrew Morton <akpm@linux-foundation.org>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>
Subject: Re: [PATCH] mm: extend prefault helpers to fault in more than
 PAGE_SIZE
Message-ID: <20120216151425.GB19158@phenom.ffwll.local>
Mail-Followup-To: Hillf Danton <dhillf@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
	DRI Development <dri-devel@lists.freedesktop.org>,
	LKML <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>
References: <1329393696-4802-1-git-send-email-daniel.vetter@ffwll.ch>
 <1329393696-4802-2-git-send-email-daniel.vetter@ffwll.ch>
 <CAJd=RBBr4EkCwAaS3xZZrm0QE71Z0soyZXTuwXyBn6ohp3pU2Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJd=RBBr4EkCwAaS3xZZrm0QE71Z0soyZXTuwXyBn6ohp3pU2Q@mail.gmail.com>
X-Operating-System: Linux phenom 3.2.0-1-amd64
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 16, 2012 at 09:32:08PM +0800, Hillf Danton wrote:
> On Thu, Feb 16, 2012 at 8:01 PM, Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
> > @@ -416,17 +417,20 @@ static inline int fault_in_pages_writeable(char __user *uaddr, int size)
> >         * Writing zeroes into userspace here is OK, because we know that if
> >         * the zero gets there, we'll be overwriting it.
> >         */
> > -       ret = __put_user(0, uaddr);
> > +       while (uaddr <= end) {
> > +               ret = __put_user(0, uaddr);
> > +               if (ret != 0)
> > +                       return ret;
> > +               uaddr += PAGE_SIZE;
> > +       }
> 
> What if
>              uaddr & ~PAGE_MASK == PAGE_SIZE -3 &&
>                 end & ~PAGE_MASK == 2

I don't quite follow - can you elaborate upon which issue you're seeing?
-Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
