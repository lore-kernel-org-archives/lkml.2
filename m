Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532Ab1JRSlT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 14:41:19 -0400
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:28451 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474Ab1JRSlR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 14:41:17 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=KBSlDmMtPy+6dcT8s2HSk+nEQXlV1wil9/JK38/4IYQ= c=1 sm=1
 a=PRlI2w1zOTMA:10 a=BLceEmwcHowA:10 a=kj9zAlcOel0A:10
 a=k8hqzbHzjweV03hO1KKrVA==:17 a=VnNF1IyMAAAA:8 a=aMwjNbt0s1OJYPdNM8kA:9
 a=CjuIK1q_8ugA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Subject: Re: [PATCH -V7 25/26] ext4: Implement rich acl for ext4
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <1318951981-5508-26-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Date: Tue, 18 Oct 2011 12:41:15 -0600
Cc: agruen@kernel.org, bfields@fieldses.org, akpm@linux-foundation.org,
        viro@zeniv.linux.org.uk, dhowells@redhat.com,
        linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <BCAE5666-30A1-484A-9808-B52E5B422A3F@dilger.ca>
References: <1318951981-5508-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1318951981-5508-26-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-10-18, at 9:33 AM, Aneesh Kumar K.V wrote:
> From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
> 
> Support the richacl permission model in ext4.  The richacls are stored
> in "system.richacl" xattrs.This need to be enabled by tune2fs or during
> mkfs.ext4

It isn't clear from your commit comment or the code what needs to be enabled by tune2fs or mkfs.ext4.  Please list the specific ext4 feature
that needs to be enabled.

> +#ifdef CONFIG_EXT4_FS_RICHACL
> +#define EXT4_IS_RICHACL(inode) IS_RICHACL(inode)
> 

> +#else  /* CONFIG_FS_EXT4_RICHACL */
> +
> +#define EXT4_IS_RICHACL(inode) (0)

It is a bit confusing that you are using both EXT4_IS_RICHACL() and
IS_RICHACL() in this code.  Initially I thought EXT4_IS_RICHACL() was
checking an ext4-specific inode flag, but it seems that it is instead
conditional upon the configure flags.

It looks like it should be possible to use EXT4_IS_RICHACL() in all
of the code, since the richacl-specific code will not be compiled
anyway.

Cheers, Andreas





