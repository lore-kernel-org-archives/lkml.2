Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204Ab0FWScd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 14:32:33 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:50118 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752380Ab0FWScb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 14:32:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=pTsfPMlTDpE3Oi2w9V3eE2ohOeBEloXhgElmCwGEenBegF7ZhIyoga6tyRJqQ922ws
         oyxLXSORpOuPJRoIBRXfzae3KXkgKT0eLDjxQNTdS7Jbe+vcJ604sANFcnxBsJ51fThT
         R/wXt7LiG/T6H4DUpcN7aUjtzlq9JgC2JQ/ws=
Message-ID: <4C225338.9010807@gmail.com>
Date: Wed, 23 Jun 2010 14:32:24 -0400
From: Scott Lovenberg <scott.lovenberg@gmail.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.10) Gecko/20100512 Lightning/1.0b1 Thunderbird/3.0.5 ThunderBrowse/3.2.8.1
MIME-Version: 1.0
To: Suresh Jayaraman <sjayaraman@suse.de>
CC: Steve French <smfrench@gmail.com>, linux-cifs@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Howells <dhowells@redhat.com>
Subject: Re: [RFC][PATCH 10/10] cifs: add mount option to enable local caching
References: <yes> <1277220309-3757-1-git-send-email-sjayaraman@suse.de>
In-Reply-To: <1277220309-3757-1-git-send-email-sjayaraman@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/22/2010 11:25 AM, Suresh Jayaraman wrote:
> Add a mount option 'fsc' to enable local caching on CIFS.
>
> As the cifs-utils (userspace) changes are not done yet, this patch enables
> 'fsc' by default to assist testing.
>    
[...]
> @@ -1332,6 +1336,8 @@ cifs_parse_mount_options(char *options, const char *devname,
>   			printk(KERN_WARNING "CIFS: Mount option noac not "
>   				"supported. Instead set "
>   				"/proc/fs/cifs/LookupCacheEnabled to 0\n");
> +		} else if (strnicmp(data, "fsc", 3) == 0) {
> +			vol->fsc = true;
>   		} else
>   			printk(KERN_WARNING "CIFS: Unknown mount option %s\n",
>   						data);
> @@ -2405,6 +2411,8 @@ static void setup_cifs_sb(struct smb_vol *pvolume_info,
>   		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_OVERR_GID;
>   	if (pvolume_info->dynperm)
>   		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_DYNPERM;
> +	if (pvolume_info->fsc)
> +		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_FSCACHE;
>   	if (pvolume_info->direct_io) {
>   		cFYI(1, "mounting share using direct i/o");
>   		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_DIRECT_IO;
>    
I reworked the CIFS mount option parsing a while back; I'm not sure 
whether that patch was going to be in the 2.6.35 tree or not (the window 
just opened, didn't it?).

Jeff, Steve, can you confirm if that patch is going to be in 2.6.35?

Patch refs: http://patchwork.ozlabs.org/patch/53059/  and 
http://patchwork.ozlabs.org/patch/53674/



