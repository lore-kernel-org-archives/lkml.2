Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194Ab2ISE3z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 00:29:55 -0400
Received: from tundra.namei.org ([65.99.196.166]:42002 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751068Ab2ISE3x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 00:29:53 -0400
Date: Wed, 19 Sep 2012 14:21:56 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org,
        linux-security-module <linux-security-module@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: Re: IMA policy search speedup
In-Reply-To: <CALLzPKZqw05_4V6NQeo-A6xOza2P4g6mqxDJnv7f-ktovj_HpQ@mail.gmail.com>
Message-ID: <alpine.LRH.2.02.1209191419410.29525@tundra.namei.org>
References: <CALLzPKZqw05_4V6NQeo-A6xOza2P4g6mqxDJnv7f-ktovj_HpQ@mail.gmail.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Sep 2012, Kasatkin, Dmitry wrote:

> I looked to <linux/fs.h> and found that there is a possibility to to
> add additional flag for sb->s_flags.
> For example
> 
> #define MS_NOT_IMA              (1<<25) /* NOT_IMA */
> #define IS_I_NOT_IMA(inode)   __IS_FLG(inode, MS_NOT_IMA)
> 
> 
> Another way is to add additional dedicated integrity related member to
> the sb structure.
> struct super_block {
> ...
> #ifdef CONFIG_INTEGRITY
>       int s_integrity;
> #endif
> };
> 
> Obviously there are only few super blocks in the system and few bytes
> will not harm.

The flag seems better than adding a new struct member.  Why would you need 
an int for this?



- James
-- 
James Morris
<jmorris@namei.org>
