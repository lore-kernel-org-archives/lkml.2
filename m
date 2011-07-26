Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755Ab1GZDfn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 23:35:43 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:37112 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128Ab1GZDfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 23:35:38 -0400
Date: Tue, 26 Jul 2011 05:35:35 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [git pull] vfs pile 1.5
Message-ID: <20110726033535.GA11939@x4.trippels.de>
References: <20110725185649.GA22133@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110725185649.GA22133@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011.07.25 at 19:56 +0100, Al Viro wrote:
> Regression fixes (devtmpfs race, cifs ->d_revalidate() breakage, fsync
> fallout), ACL stuff (me/Linus/Christoph), fixes for bugs found while

> Linus Torvalds (1):
>       vfs: move ACL cache lookup into generic code

This breaks the build for "# CONFIG_FS_POSIX_ACL is not set" configs:

  CC      fs/namei.o
fs/namei.c: In function ‘check_acl’:
fs/namei.c:191:10: error: implicit declaration of function ‘negative_cached_acl’ [-Werror=implicit-function-declaration]
fs/namei.c:196:2: error: implicit declaration of function ‘get_cached_acl’ [-Werror=implicit-function-declaration]
fs/namei.c:196:6: warning: assignment makes pointer from integer without a cast [enabled by default]
fs/namei.c:212:11: error: implicit declaration of function ‘set_cached_acl’ [-Werror=implicit-function-declaration]
cc1: some warnings being treated as errors

-- 
Markus
