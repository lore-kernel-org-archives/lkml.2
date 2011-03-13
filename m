Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866Ab1CMIcI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 04:32:08 -0400
Received: from sabe.cs.wisc.edu ([128.105.6.20]:38609 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752023Ab1CMIcD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 04:32:03 -0400
Message-ID: <4D7C8013.3090500@cs.wisc.edu>
Date: Sun, 13 Mar 2011 03:28:03 -0500
From: Mike Christie <michaelc@cs.wisc.edu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Vasiliy Kulikov <segoon@openwall.com>
CC: linux-kernel@vger.kernel.org, security@kernel.org,
        "James E.J. Bottomley" <James.Bottomley@suse.de>,
        open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 19/20] scsi: iscsi: world-writable sysfs priv_sess file
References: <cover.1296818921.git.segoon@openwall.com> <1ca8a99eaadde79e662573d89e4f17a20457fba0.1296818921.git.segoon@openwall.com>
In-Reply-To: <1ca8a99eaadde79e662573d89e4f17a20457fba0.1296818921.git.segoon@openwall.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04/2011 06:24 AM, Vasiliy Kulikov wrote:
> Don't allow everybody to change iSCSI settings.
>
> Signed-off-by: Vasiliy Kulikov<segoon@openwall.com>
> ---
>   Compile tested only.
>
>   drivers/scsi/scsi_transport_iscsi.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
> index f905ecb..01543d2 100644
> --- a/drivers/scsi/scsi_transport_iscsi.c
> +++ b/drivers/scsi/scsi_transport_iscsi.c
> @@ -1847,7 +1847,7 @@ store_priv_session_##field(struct device *dev,				\
>   #define iscsi_priv_session_rw_attr(field, format)			\
>   	iscsi_priv_session_attr_show(field, format)			\
>   	iscsi_priv_session_attr_store(field)				\
> -static ISCSI_CLASS_ATTR(priv_sess, field, S_IRUGO | S_IWUGO,		\
> +static ISCSI_CLASS_ATTR(priv_sess, field, S_IRUGO | S_IWUSR,		\
>   			show_priv_session_##field,			\
>   			store_priv_session_##field)
>   iscsi_priv_session_rw_attr(recovery_tmo, "%d");


Sorry for the late reply. Messed up on my side. Patch is correct and ok 
with me. Tested here.

Acked-by: Mike Christie <michaelc@cs.wisc.edu>
