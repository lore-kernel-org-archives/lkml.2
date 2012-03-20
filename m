Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964907Ab2CTVXO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 17:23:14 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:55693 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753832Ab2CTVXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 17:23:12 -0400
Date: Tue, 20 Mar 2012 22:23:51 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: linaro-mm-sig@lists.linaro.org, LKML <linux-kernel@vger.kernel.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        linux-media@vger.kernel.org
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: Re: [PATCH] [RFC] dma-buf: mmap support
Message-ID: <20120320212013.GA22215@phenom.ffwll.local>
Mail-Followup-To: linaro-mm-sig@lists.linaro.org,
	LKML <linux-kernel@vger.kernel.org>,
	DRI Development <dri-devel@lists.freedesktop.org>,
	linux-media@vger.kernel.org
References: <1332276785-1440-1-git-send-email-daniel.vetter@ffwll.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332276785-1440-1-git-send-email-daniel.vetter@ffwll.ch>
X-Operating-System: Linux phenom 3.2.0-1-amd64
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 20, 2012 at 09:53:05PM +0100, Daniel Vetter wrote:
> Note taht this dma-buf mmap patch does _not_ support every possible
> insanity an existing subsystem could pull of with mmap: Because it
> does not allow to intercept pagefaults and shoot down ptes importing
> subsystems can't add some magic of their own at these points (e.g. to
> automatically synchronize with outstanding rendering or set up some
> special resources). I've done a cursory read through a few mmap
> implementions of various subsytems and I'm hopeful that we can avoid
> this (and the complexity it'd bring with it).

To clarify: This concerns the importer. The exporter is of course still
free to do whatever it pleases. But the goal of this exercise is that
importing subsystems can still offer an identical userspace interfaces for
buffers imported through dma-buf and native ones, hence why I've mentioned
it.
-Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
