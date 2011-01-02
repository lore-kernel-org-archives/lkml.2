Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500Ab1ABK7p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 05:59:45 -0500
Received: from depni.sinp.msu.ru ([213.131.7.21]:33781 "EHLO depni.sinp.msu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752639Ab1ABK7o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 05:59:44 -0500
From: Serge Belyshev <belyshev@depni.sinp.msu.ru>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Prevent users from disabling tickless
References: <20101221233942.GL1263@parisc-linux.org>
Date: Sun, 02 Jan 2011 10:59:38 +0000
In-Reply-To: <20101221233942.GL1263@parisc-linux.org> (Matthew Wilcox's
	message of "Tue, 21 Dec 2010 16:39:43 -0700")
Message-ID: <87zkrj4llx.fsf@depni.sinp.msu.ru>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox <matthew@wil.cx> writes:

> Disabling NO_HZ has a serious negative effect on performance -- an extra
> 70us per I/O.  Prevent users from deselecting it.

This is rather non-trivial change.

The common wisdom was that NO_HZ=y *adds* overhead, not removes it.
Thus, I propose:

(1) Retaining and elaborating the help text.
(2) Allow user to change the default.
