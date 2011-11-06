Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753813Ab1KFWKk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 17:10:40 -0500
Received: from tango.0pointer.de ([85.214.72.216]:35190 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252Ab1KFWKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 17:10:39 -0500
Date: Sun, 6 Nov 2011 23:10:38 +0100
From: Lennart Poettering <mzxreary@0pointer.de>
To: Davidlohr Bueso <dave@gnu.org>
Cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [RFC PATCH] tmpfs: support user quotas
Message-ID: <20111106221038.GB11672@tango.0pointer.de>
References: <1320614101.3226.5.camel@offbook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320614101.3226.5.camel@offbook>
Organization: Red Hat, Inc.
X-Campaign-1: ()  ASCII Ribbon Campaign
X-Campaign-2: /  Against HTML Email & vCards - Against Microsoft Attachments
User-Agent: Leviathan/19.8.0 [zh] (Cray 3; I; Solaris 4.711; Console)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 06.11.11 18:15, Davidlohr Bueso (dave@gnu.org) wrote:

> From: Davidlohr Bueso <dave@gnu.org>
> 
> This patch adds a new RLIMIT_TMPFSQUOTA resource limit to restrict an individual user's quota across all mounted tmpfs filesystems.
> It's well known that a user can easily fill up commonly used directories (like /tmp, /dev/shm) causing programs to break through DoS.

Thanks a lot for this work! One comment without looking at the patch in detail:

> +	if (atomic_long_read(&user->shmem_bytes) + len > 
> +	    rlimit(RLIMIT_TMPFSQUOTA))
> +		return -ENOSPC;

This should be EDQUOT "Disk quota exceeded", not ENOSPC "No space left
on device".

Lennart

-- 
Lennart Poettering - Red Hat, Inc.
