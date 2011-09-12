Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509Ab1ILWie (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 18:38:34 -0400
Received: from nm24-vm0.access.bullet.mail.mud.yahoo.com ([66.94.236.143]:22723
	"HELO nm24-vm0.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755334Ab1ILWib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 18:38:31 -0400
X-Yahoo-Newman-Id: 58272.77677.bm@smtp104.biz.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: KVMBCbIVM1kdOuZGjtxFiQuVQVHBHtBlI7B2C_F21ErWQwV
 FXLvXf7IOxv3IFfFoYbYhnnDhGovsKaZv6EYMhxuDMPQLn3cJUMnP_k2.ARG
 hZEREOUohQqiTvG6hzVTpKJPhV6CXJE4PtbCSGXklrF3jGiExX0bBwCezxH7
 YrNpFZV27bkvpYL6VSYZI0npRS8sh9ketDecpAiRXyB4qSib2yI6IEQ5Jzpn
 MukLeu47s_o1Sn9t8x.85HtcGJ_jyqxU6jc5GaXVbdNhi0Kc.ubw2z_nl38l
 OY3euS_ABgNrHy6uu7eot0T0qRSVHdIZp4qj_.hlfcrUc1.1zocKs_1QAs2r
 syvX_ETUEBJ6GJo2Z0dGxLbH3cI903lBU.TOv5OZv9X979sO3qgXcJRVGhk5
 wAzh8BG1nK2ETAr2Uwt5z
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <4E6E89E0.4010406@schaufler-ca.com>
Date: Mon, 12 Sep 2011 15:38:24 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:6.0.2) Gecko/20110902 Thunderbird/6.0.2
MIME-Version: 1.0
To: "J. Bruce Fields" <bfields@fieldses.org>
CC: Valdis.Kletnieks@vt.edu,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        agruen@kernel.org, akpm@linux-foundation.org, dhowells@redhat.com,
        linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        LSM <linux-security-module@vger.kernel.org>,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH -V6 00/26] New ACL format for better NFSv4 acl interoperability
References: <1315243548-18664-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <4E655049.6060507@schaufler-ca.com> <108028.1315442771@turing-police.cc.vt.edu> <4E6E7ACC.8040003@schaufler-ca.com> <20110912222014.GA17483@fieldses.org>
In-Reply-To: <20110912222014.GA17483@fieldses.org>
X-Enigmail-Version: 1.3.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/12/2011 3:20 PM, J. Bruce Fields wrote:
> On Mon, Sep 12, 2011 at 02:34:04PM -0700, Casey Schaufler wrote:
>> On 9/7/2011 5:46 PM, Valdis.Kletnieks@vt.edu wrote:
>>> On Mon, 05 Sep 2011 15:42:17 PDT, Casey Schaufler said:
>>>> On 9/5/2011 10:25 AM, Aneesh Kumar K.V wrote:
>>>>> The following set of patches implements VFS and ext4 changes needed to implement
>>>>> a new acl model for linux. Rich ACLs are an implementation of NFSv4 ACLs,
>>>>> extended by file( masks to fit into the standard POSIX file permission model.
>>>>> They are designed to work seamlessly locally as well as across the NFSv4 and
>>>>> CIFS/SMB2 network file system protocols.
>>>> POSIX ACLs predate the LSM and can't be done as an LSM due to
>>>> the interactions between mode bits and ACLs as defined by the
>>>> POSIX DRAFT specification.
> I don't know LSM so don't understand what you mean when you say that
> interactions between mode bits and ACLs would make an ACL model hard to
> implement as an LSM.

POSIX ACLs require that the file permission bits change when
the ACL changes. This interaction violates the strict "additional
restriction" model of the LSM.


> But in any case the rich acl/mode bit interactions are similar to the
> posix acl/mode bit interactions, so the same issue probably applies.

It would help if you knew for sure and could explain the interaction
in sufficient detail to justify the position.

>
> --b.
>

