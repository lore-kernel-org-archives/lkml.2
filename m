Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751659Ab1IWSvJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 14:51:09 -0400
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:44141 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457Ab1IWSvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 14:51:07 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=K6fnQZae8TPX1i0cofjQtTsb/A4CHt4xfMPVU6P219U= c=1 sm=1
 a=_RzpKRR_PHMA:10 a=BLceEmwcHowA:10 a=kj9zAlcOel0A:10
 a=k8hqzbHzjweV03hO1KKrVA==:17 a=UVCYoMOkAAAA:8 a=VwQbUJbxAAAA:8
 a=2Jna2N92cdG9PdF7F9MA:9 a=6D-siESdAuNEP4lNeUQA:7 a=CjuIK1q_8ugA:10
 a=x8gzFH9gYPwA:10 a=TP3bHbW6IrwA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Subject: Re: [PATCH 1/2] ext4: MMP: kmmpd should use nodename from init_uts_ns.name, not sysname
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Andreas Dilger <adilger.kernel@dilger.ca>
In-Reply-To: <1316737389-5522-2-git-send-email-nikitas_angelinas@xyratex.com>
Date: Fri, 23 Sep 2011 12:51:05 -0600
Cc: Johann Lombardi <johann@whamcloud.com>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        linux-kernel Kernel <linux-kernel@vger.kernel.org>,
        Nikitas Angelinas <nikitas_angelinas@xyratex.com>,
        andrew_perepechko@xyratex.com
Content-Transfer-Encoding: 7bit
Message-Id: <83CFA343-D1F7-4FD7-B2F1-DAC638FF7C91@dilger.ca>
References: <1316737389-5522-1-git-send-email-nikitas_angelinas@xyratex.com> <1316737389-5522-2-git-send-email-nikitas_angelinas@xyratex.com>
To: Nikitas Angelinas <nikitasangelinas@gmail.com>,
        Theodore Tso <tytso@mit.edu>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-09-22, at 6:23 PM, Nikitas Angelinas wrote:
> sysname holds "Linux" by default, i.e. what appears when doing a "uname
> -s"; nodename should be used to print the machine's hostname, i.e. what
> is returned when doing a "uname -n" or "hostname", and what
> gethostname(2)/sethostname(2) manipulate, in order to notify the
> administrator of the node which is contending to mount the filesystem.
> 
> Signed-off-by: Nikitas Angelinas <nikitas_angelinas@xyratex.com>
> Signed-off-by: Andrew Perepechko <andrew_perepechko@xyratex.com>

This looks to have crept in with the port of the patch to RHEL6, which
required the code to stop accessing system_utsname directly and instead
using the init_utsname() helper to access the structure.  That version
of the patch was contributed by an external developer, so I can't really
say why it was done, probably just an oversight.  In our RHEL5 patch it
used to be:

       memcpy(mmp->mmp_nodename, system_utsname.nodename,
              sizeof(mmp->mmp_nodename));

You can add Acked-by: Andreas Dilger <adilger@dilger.ca>.

Thanks for the fix.

> ---
> fs/ext4/mmp.c |    2 +-
> 1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ext4/mmp.c b/fs/ext4/mmp.c
> index 9bdef3f..2fca64e 100644
> --- a/fs/ext4/mmp.c
> +++ b/fs/ext4/mmp.c
> @@ -109,7 +109,7 @@ static int kmmpd(void *data)
> 	mmp->mmp_check_interval = cpu_to_le16(mmp_check_interval);
> 	bdevname(bh->b_bdev, mmp->mmp_bdevname);
> 
> -	memcpy(mmp->mmp_nodename, init_utsname()->sysname,
> +	memcpy(mmp->mmp_nodename, init_utsname()->nodename,
> 	       sizeof(mmp->mmp_nodename));
> 
> 	while (!kthread_should_stop()) {
> -- 
> 1.7.4.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas





