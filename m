Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759028Ab0GPTSG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 15:18:06 -0400
Received: from smtp204.alice.it ([82.57.200.100]:56621 "EHLO smtp204.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754756Ab0GPTSE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 15:18:04 -0400
Date: Fri, 16 Jul 2010 21:16:50 +0200
From: Giuliano Pochini <pochini@shiny.it>
To: Kulikov Vasiliy <segooon@gmail.com>
Cc: kernel-janitors@vger.kernel.org, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Julia Lawall <julia@diku.dk>,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Subject: Re: [PATCH 11/15] pci: echoaudio: check kmalloc() result
Message-ID: <20100716211650.4abb6387@Jay>
In-Reply-To: <1279296943-25187-1-git-send-email-segooon@gmail.com>
References: <1279296943-25187-1-git-send-email-segooon@gmail.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.14.7; powerpc-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Jul 2010 20:15:43 +0400
Kulikov Vasiliy <segooon@gmail.com> wrote:

> If kmalloc() fails exit with -ENOMEM.
> 
> Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
> ---
>  sound/pci/echoaudio/echoaudio.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/sound/pci/echoaudio/echoaudio.c b/sound/pci/echoaudio/echoaudio.c
> index 668a5ec..20763dd 100644
> --- a/sound/pci/echoaudio/echoaudio.c
> +++ b/sound/pci/echoaudio/echoaudio.c
> @@ -2250,6 +2250,8 @@ static int snd_echo_resume(struct pci_dev *pci)
>  	DE_INIT(("resume start\n"));
>  	pci_restore_state(pci);
>  	commpage_bak = kmalloc(sizeof(struct echoaudio), GFP_KERNEL);
> +	if (commpage_bak == NULL)
> +		return -ENOMEM;
>  	commpage = chip->comm_page;
>  	memcpy(commpage_bak, commpage, sizeof(struct comm_page));
>  

Yes, of course. Thank you.


Ack-by: Giuliano Pochini <pochini@shiny.it>


-- 
Giuliano.
