Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753670Ab3ACQfZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 11:35:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17711 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753476Ab3ACQfX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 11:35:23 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CAHTX3d+P_UQK8nPfN8BKLdTkVY2VMKhty1rkCKbfHCrQBa+Nyw@mail.gmail.com>
References: <CAHTX3d+P_UQK8nPfN8BKLdTkVY2VMKhty1rkCKbfHCrQBa+Nyw@mail.gmail.com>
To: Michal Simek <monstr@monstr.eu>
Cc: dhowells@redhat.com, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: Add #includes needed to permit the removal of asm/system.h - sha1 96f951edb1f1bdbbc99b0cd458f9808bb83d58ae
Date: Thu, 03 Jan 2013 16:35:17 +0000
Message-ID: <14685.1357230917@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Simek <monstr@monstr.eu> wrote:

> It is because microblaze uses cmpxchg_local which is defined
> asm-generic/atomic.h file.
> Arnds patch has added it to atomic.h
> asm-generic: add generic atomic.h and io.h
> (sha1: 3f7e212df82ca0459d44c91d9e019efd1b5f936c)
> 
> What about to move cmpxchg_local and cmpxchg64_local from atomic.h to
> cmpxchg-local.h?

Hmmm...  cmpxchg_local() should be obtained through asm/cmpxchg.h, not
asm/atomic.h.  See:

	grep -r define\\s*cmpxchg_local arch

David
