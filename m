Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756208Ab1FNLQM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 07:16:12 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:50545 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754362Ab1FNLQK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 07:16:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=kYmiPvOqoWtfQU8R/vC/OdkKlhKC2MXSxZ6bjey1B2mz0rZD5clrZYQfOI+oGovFsB
         wrSIz0mUvccg3VKVLk/gr4+upc3PHe4pAYwcjV8O7uTdvCQ9dcB0coMd2NAVVgORMYHK
         jJrsmWmDxBELmWi4VUx+my4vgzm0zgT15B2Ks=
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.00.1106140356240.29206@sister.anvils>
References: <alpine.LSU.2.00.1106140327550.29206@sister.anvils>
	<alpine.LSU.2.00.1106140356240.29206@sister.anvils>
Date: Tue, 14 Jun 2011 14:16:09 +0300
X-Google-Sender-Auth: 3p0I2UUgFKnVaW50uqTuOO9nNMw
Message-ID: <BANLkTinh+C2a4+mWCtMrRb5GcpQqiF5CUw@mail.gmail.com>
Subject: Re: [PATCH 11/12] tmpfs: use kmemdup for short symlinks
From: Pekka Enberg <penberg@kernel.org>
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 14, 2011 at 1:57 PM, Hugh Dickins <hughd@google.com> wrote:
> But we've not yet removed the old swp_entry_t i_direct[16] from
> shmem_inode_info.  That's because it was still being shared with the
> inline symlink.  Remove it now (saving 64 or 128 bytes from shmem inode
> size), and use kmemdup() for short symlinks, say, those up to 128 bytes.
>
> I wonder why mpol_free_shared_policy() is done in shmem_destroy_inode()
> rather than shmem_evict_inode(), where we usually do such freeing?  I
> guess it doesn't matter, and I'm not into NUMA mpol testing right now.
>
> Signed-off-by: Hugh Dickins <hughd@google.com>

Reviewed-by: Pekka Enberg <penberg@kernel.org>
