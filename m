Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755867Ab2AIVWk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 16:22:40 -0500
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:59916 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754848Ab2AIVWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 16:22:38 -0500
Message-ID: <4F0B6845.4080503@xenotime.net>
Date: Mon, 09 Jan 2012 14:20:53 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Paulius Zaleckas <paulius.zaleckas@gmail.com>
CC: mmarek@suse.cz, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] menuconfig: add Home and End keys support for
 inputbox
References: <20120109113633.24486.69758.stgit@localhost6.localdomain6> <20120109113641.24486.95511.stgit@localhost6.localdomain6>
In-Reply-To: <20120109113641.24486.95511.stgit@localhost6.localdomain6>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/2012 03:36 AM, Paulius Zaleckas wrote:
> Makes long string editing easier.
> 
> Signed-off-by: Paulius Zaleckas <paulius.zaleckas@gmail.com>

Hi,

Does "default hostname" in the "General setup" menu use an inputbox?
If so, I can't get Home and End keys to work for it.

If not, please tell me a field that uses an inputbox so that I can test it.

Thanks.

> ---
> 
>  scripts/kconfig/lxdialog/inputbox.c |   10 ++++++++++
>  1 files changed, 10 insertions(+), 0 deletions(-)
> 
> diff --git a/scripts/kconfig/lxdialog/inputbox.c b/scripts/kconfig/lxdialog/inputbox.c
> index 834eee9..0d9cacc 100644
> --- a/scripts/kconfig/lxdialog/inputbox.c
> +++ b/scripts/kconfig/lxdialog/inputbox.c
> @@ -158,6 +158,16 @@ do_resize:
>  					goto redraw;
>  				}
>  				continue;
> +			case KEY_HOME:
> +				scroll = input_x = 0;
> +				goto redraw;
> +			case KEY_END:
> +				if (len >= box_width) {
> +					scroll = len - box_width + 1;
> +					input_x = box_width - 1;
> +				} else
> +					input_x = len;
> +				goto redraw;
>  			default:
>  				if (key < 0x100 && isprint(key)) {
>  					if (len < MAX_LEN) {
> 
> --


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
