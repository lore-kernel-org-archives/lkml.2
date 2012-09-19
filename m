Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756190Ab2ISKZd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 06:25:33 -0400
Received: from mga09.intel.com ([134.134.136.24]:3671 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756147Ab2ISKZa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 06:25:30 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.02.1209191419410.29525@tundra.namei.org>
References: <CALLzPKZqw05_4V6NQeo-A6xOza2P4g6mqxDJnv7f-ktovj_HpQ@mail.gmail.com>
	<alpine.LRH.2.02.1209191419410.29525@tundra.namei.org>
Date: Wed, 19 Sep 2012 13:25:26 +0300
Message-ID: <CALLzPKaKoHkVx37FeOSTpRvFM_d6KifDYvywbMk4MOKiy2nQbQ@mail.gmail.com>
Subject: Re: IMA policy search speedup
From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
To: James Morris <jmorris@namei.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org,
        linux-security-module <linux-security-module@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 19, 2012 at 7:21 AM, James Morris <jmorris@namei.org> wrote:
> On Tue, 18 Sep 2012, Kasatkin, Dmitry wrote:
>
>> I looked to <linux/fs.h> and found that there is a possibility to to
>> add additional flag for sb->s_flags.
>> For example
>>
>> #define MS_NOT_IMA              (1<<25) /* NOT_IMA */
>> #define IS_I_NOT_IMA(inode)   __IS_FLG(inode, MS_NOT_IMA)
>>
>>
>> Another way is to add additional dedicated integrity related member to
>> the sb structure.
>> struct super_block {
>> ...
>> #ifdef CONFIG_INTEGRITY
>>       int s_integrity;
>> #endif
>> };
>>
>> Obviously there are only few super blocks in the system and few bytes
>> will not harm.
>
> The flag seems better than adding a new struct member.  Why would you need
> an int for this?
>

int is not really needed. It may be char. I just thought that normally
we have around 10 super blocks
and it 10 or 40 bytes does not really mater...

Actually there is more severe case. IMA cache objects "iint" per inode
have following members:
  enum integrity_status ima_status;
  enum integrity_status evm_status;

And it is only 5 values per each or 10 values per 8 bytes.
8 bytes can be easily replaced by 1 byte.

Should we improve it?

>
>
> - James
> --
> James Morris
> <jmorris@namei.org>
