Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688Ab1CDHW1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 02:22:27 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33030 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820Ab1CDHW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 02:22:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=FsAPyySk+RBY5C44Y7UKMmdGAkQor1mLTHIgtlqCiYI7AituQUnX50oXLHuNb8sqOi
         muDHNqzzcDPQXJoumEE5AEuAc+NyvDiLGNUBNWFWWwNhstV5QEtRlzG4yh5fWp7E+G0o
         PVXZjyJO6/7mb4sWH8RHAwrDHSjNHGpScCPXU=
Date: Fri, 4 Mar 2011 08:22:39 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: Torben Hohn <torbenh@gmx.de>
Cc: linux-kernel@vger.kernel.org, richard.cochran@omicron.at,
        johnstul@us.ibm.com, tglx@linutronix.de
Subject: Re: [PATCH 3/3] Check for write permission on FD based posix-clocks
Message-ID: <20110304072239.GA8957@riccoc20.at.omicron.at>
References: <1299173174-348-1-git-send-email-torbenh@gmx.de>
 <1299173174-348-4-git-send-email-torbenh@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299173174-348-4-git-send-email-torbenh@gmx.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 03, 2011 at 06:26:14PM +0100, Torben Hohn wrote:
> pc_clock_settime() and pc_clock_adjtime() did not check
> whether the fd was opened in write mode.
> 
> It was possible to set a clock, when we only had read
> permissions.
> 
> for completeness, we would also need to check for Read permissions
> on the read operations. but that would be a bit paranoid, probably.

I have no objection to this form of clock access control, but I would
like to get agreement about it from the list.

> diff --git a/kernel/time/posix-clock.c b/kernel/time/posix-clock.c
> index 04498cb..25028dd 100644
> --- a/kernel/time/posix-clock.c
> +++ b/kernel/time/posix-clock.c
> @@ -287,11 +287,16 @@ static int pc_clock_adjtime(clockid_t id, struct timex *tx)
>  	if (err)
>  		return err;
>  
> +	if ((cd.fp->f_mode & FMODE_WRITE) == 0) {
> +		err = -EACCES;

Looks like clock_settime and adjtimex are supposed to return EPERM in
this case.

Thanks,

Richard


