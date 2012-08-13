Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272Ab2HMDaX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2012 23:30:23 -0400
Received: from ozlabs.org ([203.10.76.45]:47647 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753020Ab2HMDaW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2012 23:30:22 -0400
From: Rusty Russell <rusty@ozlabs.org>
To: Jiri Slaby <jslaby@suse.cz>, gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: Re: [PATCH 12/41] mxser: allow overlapping vector
In-Reply-To: <1344368886-24033-13-git-send-email-jslaby@suse.cz>
References: <1344368886-24033-1-git-send-email-jslaby@suse.cz> <1344368886-24033-13-git-send-email-jslaby@suse.cz>
User-Agent: Notmuch/0.12 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Mon, 13 Aug 2012 11:20:55 +0930
Message-ID: <87r4rbsgow.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  7 Aug 2012 21:47:37 +0200, Jiri Slaby <jslaby@suse.cz> wrote:
> For many cards, this saves some IO space because interrupt status port
> has precedence over the rest of ports on the card. Hence it can be
> mapped to a hole in I/O ports.
> 
> Here we add a kernel parameter which allows that if a user wants to.
> But they need to explicitly enable it by a module parameter.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> ---
>  drivers/tty/mxser.c |   35 +++++++++++++++++++++++++++++++----
>  1 file changed, 31 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/tty/mxser.c b/drivers/tty/mxser.c
> index c162ee9..e64fe40 100644
> --- a/drivers/tty/mxser.c
> +++ b/drivers/tty/mxser.c
> @@ -2337,11 +2337,36 @@ static struct tty_port_operations mxser_port_ops = {
>   * The MOXA Smartio/Industio serial driver boot-time initialization code!
>   */
>  
> +static bool allow_overlapping_vector;
> +module_param(allow_overlapping_vector, bool, 444);

You mean 0444, right?

Cheers,
Rusty.
