Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349Ab0E0Npj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 09:45:39 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:41866 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827Ab0E0Nph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 09:45:37 -0400
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: miklos@szeredi.hu, viro@zeniv.linux.org.uk, john.johansen@canonical.com,
       penguin-kernel@i-love.sakura.ne.jp, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-reply-to: <AANLkTikrejgaNreRt2krs_djeFN-pmrEU5G-v08llao6@mail.gmail.com>
	(message from Alexey Dobriyan on Thu, 27 May 2010 16:19:57 +0300)
Subject: Re: [PATCH 1/2] vfs: sanitize __d_path()
References: <E1OHaLJ-0008VD-VJ@pomaz-ex.szeredi.hu>
	<AANLkTilGlR297cl9yHF5n6e4eU7JflJwrpm3TrIe-rlo@mail.gmail.com>
	<E1OHcV6-0000oz-C5@pomaz-ex.szeredi.hu> <AANLkTikrejgaNreRt2krs_djeFN-pmrEU5G-v08llao6@mail.gmail.com>
Message-Id: <E1OHdOm-00017x-G8@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 27 May 2010 15:45:24 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 May 2010, Alexey Dobriyan wrote:
> Why would they want to do it (which means taking locks again and
> potential incoherence)?
> The information is right there, ship it upwards:
> 
> +       if (deleted)
> +               *deleted = 0;
>         spin_lock(&vfsmount_lock);
>         prepend(&end, &buflen, "\0", 1);
> -       if (d_unlinked(dentry) &&
> -               (prepend(&end, &buflen, " (deleted)", 10) != 0))
> -                       goto Elong;
> +       if (d_unlinked(dentry) && deleted)
> +               *deleted = 1;
> 
> "(deleted)" as interface sucks, we can't change it,
> at least, let's make in-kernel interface correct.
> 

Do you have any specific caller in mind?

The above will just result in extra code in most callers.  Better have
one function with does the old "(deleted)" thing, and one which
doesn't.

Thanks,
Miklos
