Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662Ab0I2R16 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 13:27:58 -0400
Received: from smtp.opengridcomputing.com ([209.198.142.2]:37998 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754574Ab0I2R14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 13:27:56 -0400
Message-ID: <4CA37715.4020302@opengridcomputing.com>
Date: Wed, 29 Sep 2010 12:27:49 -0500
From: Steve Wise <swise@opengridcomputing.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100915 Lightning/1.0b1 Thunderbird/3.0.8
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: Arnd Bergmann <arnd@arndb.de>, linux-rdma@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RDMA/cxgb4: Add default_llseek to debugfs files.
References: <20100929141112.26944.21931.stgit@build.ogc.int> <adawrq431sr.fsf@cisco.com>
In-Reply-To: <adawrq431sr.fsf@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/29/2010 12:19 PM, Roland Dreier wrote:
>   >  @@ -182,6 +182,7 @@ static const struct file_operations qp_debugfs_fops = {
>   >   	.open    = qp_open,
>   >   	.release = qp_release,
>   >   	.read    = debugfs_read,
>   >  +	.llseek  = default_llseek,
>   >   };
>
> I think this could actually be generic_file_llseek (right, Arnd?).
>
> Also could qp_read() and other read methods be simplified by using
> simple_read_from_buffer()?  I don't see anything fancy there, seems like
> the read methods could become one-liners that way.
>
>    

I assume you mean debugs_read()...Like this?

static ssize_t debugfs_read(struct file *file, char __user *buf, size_t 
count,
                             loff_t *ppos)
{
         struct c4iw_debugfs_data *d = file->private_data;

         return simple_read_from_buffer(buf, ppos, d->buf, d->pos);
}


Steve.
