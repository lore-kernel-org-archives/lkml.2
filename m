Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629Ab1IEWsW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 18:48:22 -0400
Received: from nm28-vm0.bullet.mail.sp2.yahoo.com ([98.139.91.234]:47213 "HELO
	nm28-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751731Ab1IEWsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 18:48:13 -0400
X-Greylist: delayed 353 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Sep 2011 18:48:13 EDT
X-Yahoo-Newman-Id: 955415.78410.bm@omp1038.mail.sp2.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: AR8W6bIVM1n0wE47YF_VV36lOZsxfT6c7Y7jb9xKzoozOZX
 AU83fVxTkhnRFu5zNT_RQIRLKUIN20SMq82qWzEYp62db5OyiRJnswCUWZWe
 etQKT9wAWciNm7QMVfWf5lxFGX9ETmXtfxTDFTIwc6y94ftITGebSynqOQ5j
 .ekUTiVCw9x_0HhVsYou8A_1QGAlNER1XYQ_5_Kp20pAn1WeFNaXaNxCFmXV
 WZBPm0_4V4NzHEbBjqvsG13kWauQMW_p.ilzvAPSejBG4_9c2rT.XU3srmK7
 m8QYTwUeHujiKAZM5xRsM3rTWVdbfTxWQ6sJXtc3MGi4SRhZAWRmwQe8HxPM
 aIPe_QL.L0tPhkR7rB0F4UibjVek85YeXDP0bwCFXCPHvrwfql5sJYvZyBkW
 q0FHwA9n5tngkQqTFOTvBjiw8fABPCiXyBRxGT1cVscTZyXaFyWbC_zFkqSe
 7xS1xX5b8qyGT8DpgJsWdAndecOhIe0o1ynUs8CMzGiH0p9VFbCevKC0AxuQ
 U1dmWw5if2hBzFbVcPEbKNQ6zC.mfCo8c91FF05O5K6dwFYX1MY7LdAIF
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <4E655049.6060507@schaufler-ca.com>
Date: Mon, 05 Sep 2011 15:42:17 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:6.0.1) Gecko/20110830 Thunderbird/6.0.1
MIME-Version: 1.0
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
CC: agruen@kernel.org, bfields@fieldses.org, akpm@linux-foundation.org,
        dhowells@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        LSM <linux-security-module@vger.kernel.org>,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH -V6 00/26]  New ACL format for better NFSv4 acl interoperability
References: <1315243548-18664-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
In-Reply-To: <1315243548-18664-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Enigmail-Version: 1.3.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/5/2011 10:25 AM, Aneesh Kumar K.V wrote:
> Hi,
>
> The following set of patches implements VFS and ext4 changes needed to implement
> a new acl model for linux. Rich ACLs are an implementation of NFSv4 ACLs,
> extended by file masks to fit into the standard POSIX file permission model.
> They are designed to work seamlessly locally as well as across the NFSv4 and
> CIFS/SMB2 network file system protocols.

POSIX ACLs predate the LSM and can't be done as an LSM due to
the interactions between mode bits and ACLs as defined by the
POSIX DRAFT specification. Is there a reason that "rich" ACLs
can not be done as an LSM?

>
> A user-space utility for displaying and changing richacls is available at [4]
> (a number of examples can be found at http://acl.bestbits.at/richacl/examples.html).
>
> [4] git://git.kernel.org/pub/scm/fs/acl/kvaneesh/richacl.git master
>
> To test richacl on ext4 use -o richacl mount option. This mount option may later be
> dropped in favour of a feature flag.
>
> More details regarding richacl can be found at
> http://acl.bestbits.at/richacl/
>
> Changes from v5:
> a) rebase to v3.1-rc4-131-g9e79e3e
>
> NOTE: The kernel changes will be pushed to
> git://git.kernel.org/pub/scm/linux/kernel/git/kvaneesh/linux-richacl.git richacl
> when kernel.org is back
>
> -aneesh
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

