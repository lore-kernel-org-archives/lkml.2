Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754970Ab1ILVeN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 17:34:13 -0400
Received: from nm12-vm0.access.bullet.mail.mud.yahoo.com ([66.94.236.11]:32498
	"HELO nm12-vm0.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754638Ab1ILVeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 17:34:10 -0400
X-Yahoo-Newman-Id: 192362.21172.bm@smtp103.biz.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: Z5PfZO4VM1lX8ksU2sUmT0an39aQJVsIj3KcQ3.Ui9vEHo8
 mg05hFOROQYYMhR0d_RNdayuSDdv8k1M4tzyYZe8sdkngAgZgX83htkjRmWL
 QP0bTpyFjBHWhcKIxykyIbDqyd6ZPqshzgHyxNy62Lhrr_s6l2vOOJAfZckI
 06hb17pMGH2fSilnZjRn4x00qbseOda6vUto2ypiRl10RlJF_EtsjiFWeuKI
 rYnaF.ZByAwPhtPDAWbWoa9FhFo.ZJZd0EYQWhjclBP045T0NZxMRt0EUZAe
 oY9XFAiMezbVp2Ya7QnXtZpaMk.v.8uG7NJJYVyRZc9cEaVo4I7ffoQu074e
 1zwh8kybNSXV4WtHYcDY9vJPc5HsDacAHNtyRspUR03VKOD7DsMrmX_HvEm5
 w500.zCJy
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <4E6E7ACC.8040003@schaufler-ca.com>
Date: Mon, 12 Sep 2011 14:34:04 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:6.0.2) Gecko/20110902 Thunderbird/6.0.2
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, agruen@kernel.org,
        bfields@fieldses.org, akpm@linux-foundation.org, dhowells@redhat.com,
        linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        LSM <linux-security-module@vger.kernel.org>,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH -V6 00/26] New ACL format for better NFSv4 acl interoperability
References: <1315243548-18664-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>            <4E655049.6060507@schaufler-ca.com> <108028.1315442771@turing-police.cc.vt.edu>
In-Reply-To: <108028.1315442771@turing-police.cc.vt.edu>
X-Enigmail-Version: 1.3.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/7/2011 5:46 PM, Valdis.Kletnieks@vt.edu wrote:
> On Mon, 05 Sep 2011 15:42:17 PDT, Casey Schaufler said:
>> On 9/5/2011 10:25 AM, Aneesh Kumar K.V wrote:
>>> The following set of patches implements VFS and ext4 changes needed to implement
>>> a new acl model for linux. Rich ACLs are an implementation of NFSv4 ACLs,
>>> extended by file( masks to fit into the standard POSIX file permission model.
>>> They are designed to work seamlessly locally as well as across the NFSv4 and
>>> CIFS/SMB2 network file system protocols.
>>
>> POSIX ACLs predate the LSM and can't be done as an LSM due to
>> the interactions between mode bits and ACLs as defined by the
>> POSIX DRAFT specification. Is there a reason that "rich" ACLs
>> can not be done as an LSM?
>
> Well, if it was done as an LSM, it would mean that if I wanted to build a
> system where I have a few hundred terabytes of disk exported via Samba, and I
> wanted Samba to save the CIFS permission ACL, I couldn't also run Selinux or
> SMACK or anything like that - unless somebody actually snuck in the "LSMs are
> stackable" patch while I wasn't looking?
>
 
True, but not an acceptable argument for not doing it as an LSM.
It is an argument in favor of LSM stacking, and after the Linux
Security Summit this past week it seems only a matter of time before
we have that. This could be the compelling use case that we've been
missing for LSM stacking.
 
So at this point, unless there is another reason why it can't be an
LSM it should be an LSM.
 

