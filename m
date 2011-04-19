Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754389Ab1DSUaP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 16:30:15 -0400
Received: from mail.bluewatersys.com ([202.124.120.130]:54719 "EHLO
	hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751530Ab1DSUaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 16:30:12 -0400
Message-ID: <4DADF0D3.3040006@bluewatersys.com>
Date: Wed, 20 Apr 2011 08:30:11 +1200
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101208 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Jonathan Cameron <jic23@cam.ac.uk>
CC: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, greg@kroah.com,
        adobriyan@gmail.com
Subject: Re: [PATCH 2/3] debugfs: move to new strtobool
References: <a> <1303213427-12798-3-git-send-email-jic23@cam.ac.uk>
In-Reply-To: <1303213427-12798-3-git-send-email-jic23@cam.ac.uk>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19/2011 11:43 PM, Jonathan Cameron wrote:
> No functional changes requires that we eat errors from strtobool.
> If people want to not do this, then it should be fixed at a later date.

May as well fix it now or it will get forgotten about. A second patch on
top of this can fix the bug.

~Ryan

> V2: Simplification suggested by Rusty Russell removes the need for
> additional variable ret.
> 
> Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
> ---
>  fs/debugfs/file.c |   17 ++++-------------
>  1 files changed, 4 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/debugfs/file.c b/fs/debugfs/file.c
> index 89d394d..568304d 100644
> --- a/fs/debugfs/file.c
> +++ b/fs/debugfs/file.c
> @@ -429,25 +429,16 @@ static ssize_t write_file_bool(struct file *file, const char __user *user_buf,
>  {
>  	char buf[32];
>  	int buf_size;
> +	bool bv;
>  	u32 *val = file->private_data;
>  
>  	buf_size = min(count, (sizeof(buf)-1));
>  	if (copy_from_user(buf, user_buf, buf_size))
>  		return -EFAULT;
>  
> -	switch (buf[0]) {
> -	case 'y':
> -	case 'Y':
> -	case '1':
> -		*val = 1;
> -		break;
> -	case 'n':
> -	case 'N':
> -	case '0':
> -		*val = 0;
> -		break;
> -	}
> -	
> +	if (strtobool(buf, &bv) == 0)
> +		*val = bv;
> +
>  	return count;
>  }
>  


-- 
Bluewater Systems Ltd - ARM Technology Solution Centre

Ryan Mallon         		5 Amuri Park, 404 Barbadoes St
ryan@bluewatersys.com         	PO Box 13 889, Christchurch 8013
http://www.bluewatersys.com	New Zealand
Phone: +64 3 3779127		Freecall: Australia 1800 148 751
Fax:   +64 3 3779135			  USA 1800 261 2934
