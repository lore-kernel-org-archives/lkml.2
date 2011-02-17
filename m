Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932106Ab1BQNzk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 08:55:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10357 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753278Ab1BQNzh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 08:55:37 -0500
Date: Thu, 17 Feb 2011 14:55:25 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: alan@lxorguk.ukuu.org.uk, gregkh@suse.de
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] tty,vcs: vcs_seek fix + removing con_buf_mtx
Message-ID: <20110217135525.GA1952@jolsa.brq.redhat.com>
References: <1297103485-8319-1-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297103485-8319-1-git-send-email-jolsa@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
any feedback?

thanks,
jirka

On Mon, Feb 07, 2011 at 07:31:23PM +0100, Jiri Olsa wrote:
> hi,
> 
> the vcs lseek method might race with VC removal and cause panic.
> 
> Also it seems the vcs is the only one using con_buf and con_buf_mtx,
> which does not seem necessary any longer.
> 
> attached patches:
> 1/2 - lseek/VC-release race fix
> 2/2 - removing con_buf and con_buf_mtx
> 
> wbr,
> jirka
> ---
>  drivers/tty/vt/vc_screen.c |  110 +++++++++++++++++++++++++++-----------------
>  drivers/tty/vt/vt.c        |   12 -----
>  include/linux/vt_kern.h    |    8 ---
>  3 files changed, 67 insertions(+), 63 deletions(-)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
