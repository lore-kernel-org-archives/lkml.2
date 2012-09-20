Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932589Ab2ITX2U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 19:28:20 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45277 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932468Ab2ITX2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 19:28:19 -0400
Date: Thu, 20 Sep 2012 16:25:36 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "Liu, Chuansheng" <chuansheng.liu@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Colin Cross <ccross@android.com>
Subject: Re: [PATCH] pstore: avoid recursive spinlocks in the
 oops_in_progress case
Message-ID: <20120920232536.GB8209@lizard>
References: <1347903824.29767.15.camel@cliu38-desktop-build>
 <20120920225727.GD29721@lizard>
 <3908561D78D1C84285E8C5FCA982C28F19D43812@ORSMSX108.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F19D43812@ORSMSX108.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2012 at 11:09:36PM +0000, Luck, Tony wrote:
> > Mm... why break?
> 
> We don't know what the back-end driver will do if we allow another call
> while a previous one is still in progress.  It might end up corrupting the
> backing non-volatile storage and losing some previously saved records.

True, but the lock is used to protect pstore->buf, I doubt that
any backend will actually want to grab it, no?

Since it is pstore that is handing the buffer to backend, it is
pstore's worry to do proper locking.

> Existing drivers (ERST and EFI) are dependent on f/w ... so things might
> work on some platforms, yet be horribly bad on others.
> 
> The patch as it was written converts a deadlock (hang) case into a "lose
> this log, but keep going" case. Which seems to be an improvement without
> taking any risks about what the backend will do.

But why backends should (or want/will want to) grab this lock?..

If a backend needs its own locking in ->write callback, then it'll
have to use its own lock, I guess.

Thanks,
Anton.
