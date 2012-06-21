Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753137Ab2FUEjk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 00:39:40 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:46443 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752706Ab2FUEji convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 00:39:38 -0400
MIME-Version: 1.0
In-Reply-To: <1340231684-1667-1-git-send-email-luis.henriques@canonical.com>
References: <20120620145659.a5fff5f6.akpm@linux-foundation.org>
	<1340231684-1667-1-git-send-email-luis.henriques@canonical.com>
Date: Wed, 20 Jun 2012 21:39:38 -0700
Message-ID: <CALjC5hbVph_XvRPNFdz-7DNGwMBnSnbh1eznMAUcYOCbXjNrNw@mail.gmail.com>
Subject: Re: [PATCH] ocfs2: Fix NULL pointer dereferrence in __ocfs2_change_file_space
From: Bret Towe <magnade@gmail.com>
To: Luis Henriques <luis.henriques@canonical.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        ocfs2-devel@oss.oracle.com, mfasheh@suse.com, jlbec@evilplan.org,
        sunil.mushran@oracle.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2012 at 3:34 PM, Luis Henriques
<luis.henriques@canonical.com> wrote:
> As ocfs2_fallocate() will invoke __ocfs2_change_file_space() with a NULL
> as the first parameter (file), it may trigger a NULL pointer dereferrence
> due to a missing check.  See http://bugs.launchpad.net/bugs/1006012.
>
> Signed-off-by: Luis Henriques <luis.henriques@canonical.com>

ran the patch for a while no crashes I see if the other patch isn't used
i did notice the following in dmesg  not sure exactly what i was up to
at that point tho
never seen the message before

[ 4704.352332] (pool,1731,0):ocfs2_unlink:951 ERROR: status = -39
