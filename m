Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353Ab2IKFTU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 01:19:20 -0400
Received: from smtp209.alice.it ([82.57.200.105]:51193 "EHLO smtp209.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751647Ab2IKFTT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 01:19:19 -0400
X-Greylist: delayed 345 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Sep 2012 01:19:18 EDT
Message-ID: <504EC8BA.7010706@libero.it>
Date: Tue, 11 Sep 2012 07:14:34 +0200
From: Goffredo Baroncelli <kreijack@libero.it>
Reply-To: kreijack@inwind.it
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120418 Icedove/11.0
MIME-Version: 1.0
To: Wang Sheng-Hui <shhuiw@gmail.com>
CC: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, cwillu <cwillu@cwillu.com>,
        Josef Bacik <jbacik@fusionio.com>
Subject: Re: [PATCH] btrfs: fix disk-io.c/btrfs_read_dev_super with BTRFS_SUPER_MIRROR_MAX
 to control the loops
References: <504D8AEB.9090401@gmail.com>
In-Reply-To: <504D8AEB.9090401@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 09/10/2012 08:38 AM, Wang Sheng-Hui wrote:
> To check the duplicated super blocks, use BTRFS_SUPER_MIRROR_MAX
> as the loops limit.
>
> Signed-off-by: Wang Sheng-Hui<shhuiw@gmail.com>
> ---
>   fs/btrfs/disk-io.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 22e98e0..a431144 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -2723,7 +2723,7 @@ struct buffer_head *btrfs_read_dev_super(struct block_device *bdev)
>   	 * So, we need to add a special mount option to scan for
>   	 * later supers, using BTRFS_SUPER_MIRROR_MAX instead
>   	 */
> -	for (i = 0; i<  1; i++) {
> +	for (i = 0; i<  BTRFS_SUPER_MIRROR_MAX; i++) {
>   		bytenr = btrfs_sb_offset(i);
>   		if (bytenr + 4096>= i_size_read(bdev->bd_inode))
>   			break;


Pay attention that when a device is removed from a filesystem by the 
command "btrfs device delete", *only* the 1st superblock btrfs signature 
is zeroed [1]. This means that the other (backup) superblocks will be 
considered valid with your change.



[1] See the function btrfs_rm_device() in volume.c




