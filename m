Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758283Ab0ENINi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 04:13:38 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:48553 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758072Ab0ENIND convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 04:13:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=hiDkJVVz5mgQBVubkg8fCAPCzuLVgcwYxO9zlhMcC9rPKMITsG0eAv8YYAZqU4aPug
         fUtjO9qYXH7imsBvYYJVuoxY1Bvru6ygK43dwHD4AXvEc2GruvyDf5ci/QM7hhBgFHLr
         z2FEbvVtJDGTLlySZIOvPkMIBXCj68cw2ToJQ=
MIME-Version: 1.0
In-Reply-To: <1273824214.5605.3625.camel@twins>
References: <1273744285-8128-1-git-send-email-xiaosuo@gmail.com> 
	<1273756816.5605.3547.camel@twins> <AANLkTinLT5g5SKjqmQlS2kxvvMq1gsi1jPDgOKTnrT-q@mail.gmail.com> 
	<1273824214.5605.3625.camel@twins>
From: Changli Gao <xiaosuo@gmail.com>
Date: Fri, 14 May 2010 16:12:41 +0800
Message-ID: <AANLkTimAfd5vWURp75galRdoHxszFS7GYsOfGHZLD3h7@mail.gmail.com>
Subject: Re: [PATCH 1/9] mm: add generic adaptive large memory allocation APIs
To: Peter Zijlstra <peterz@infradead.org>
Cc: akpm@linux-foundation.org, Hoang-Nam Nguyen <hnguyen@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>, Roland Dreier <rolandd@cisco.com>,
       Sean Hefty <sean.hefty@intel.com>,
       Hal Rosenstock <hal.rosenstock@gmail.com>,
       Divy Le Ray <divy@chelsio.com>,
       "James E.J. Bottomley" <James.Bottomley@suse.de>,
       "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger@sun.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
       linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mm@kvack.org, containers@lists.linux-foundation.org,
       Eric Dumazet <eric.dumazet@gmail.com>,
       Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 14, 2010 at 4:03 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, 2010-05-13 at 22:08 +0800, Changli Gao wrote:
>> > NAK, I really utterly dislike that inatomic argument. The alloc side
>> > doesn't function in atomic context either. Please keep the thing
>> > symmetric in that regards.
>> >
>>
>> There are some users, who release memory in atomic context. for
>> example: fs/file.c: fdmem.
>
> urgh, but yeah, aside from not using vmalloc to allocate fd tables one
> needs to deal with this.
>
> But if that is the only one, I'd let them do the workqueue thing that's
> already there. If there really are more people wanting to do this, then
> maybe add: kvfree_atomic().
>

Tetsuo has pointed another one in apparmor.
http://kernel.ubuntu.com/git?p=jj/ubuntu-lucid.git;a=blobdiff;f=security/apparmor/match.c;h=d2cd55419acfcae85cb748c8f837a4384a3a0d29;hp=afc2dd2260edffcf88521ae86458ad03aa8ea12c;hb=f5eba4b0a01cc671affa429ba1512b6de7caeb5b;hpb=abdff9ddaf2644d0f9962490f73e030806ba90d3
, though apparmor hasn't been merged into mainline.

-- 
Regards，
Changli Gao(xiaosuo@gmail.com)
