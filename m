Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876Ab0E0Mai (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 08:30:38 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:5122 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093Ab0E0Mag convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 08:30:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=S5Nh4IsJixMs8LpgH9/3F88mCAyK+JjpCdwUYckZJoAh2W2jxKKjSSKKGb7+YphTCY
         GBjKK7K11g3lxxZ59KNJ6TpQ18VcLGTt9GyNr2ej749eNbUwdCEzdUg6lYkNiWllkh16
         oalA1m8Qre+Q4OPumKydq6dXXGKeLN5ldq9A4=
MIME-Version: 1.0
In-Reply-To: <E1OHaLJ-0008VD-VJ@pomaz-ex.szeredi.hu>
References: <E1OHaLJ-0008VD-VJ@pomaz-ex.szeredi.hu>
Date: Thu, 27 May 2010 15:30:34 +0300
Message-ID: <AANLkTilGlR297cl9yHF5n6e4eU7JflJwrpm3TrIe-rlo@mail.gmail.com>
Subject: Re: [PATCH 1/2] vfs: sanitize __d_path()
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
       John Johansen <john.johansen@canonical.com>,
       Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 1:29 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
>
> __d_path() no longer appends " (deleted)" to unlinked paths.  This is
> moved into d_path() which is the only caller that cares.

d_path() or equivalent should get "int *deleted" argument to distinguish
really deleted files. Then users can decide if they care or not.

> If a global root is reached then __d_path() no longer prepends the
> name of the root dentry.  This was needed by pseudo filesystems, but
> the d_dname() method has superseded it.
