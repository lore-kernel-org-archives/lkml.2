Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755518Ab1GJI3R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 04:29:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5664 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755419Ab1GJI3P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 04:29:15 -0400
Message-ID: <4E1962BE.8010204@redhat.com>
Date: Sun, 10 Jul 2011 09:28:46 +0100
From: Ric Wheeler <rwheeler@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>, Alexander Viro <aviro@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
CC: Michal Suchanek <hramrach@centrum.cz>, Ian Kent <ikent@redhat.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeff Moyer <jmoyer@redhat.com>, miklos@szeredi.hu
Subject: Union mount and lockdep design issues
References: <4E0AF2BA.2040706@gmail.com> <1302756608.2854.10.camel@perseus.themaw.net> <BANLkTini-g9XVOohKjwpZT-SGozcwx720A@mail.gmail.com> <4DA4B6A8.7030804@gmail.com> <BANLkTimsAE1ZAJhsSjnh3LqwsN9x0cLaXg@mail.gmail.com> <4DA5DCB8.3040101@gmail.com> <BANLkTineg2XYYOZAU9trrw=+-vH8McN_9w@mail.gmail.com> <4DA5F569.9020309@gmail.com> <BANLkTi=Z1CQm=u2Q1VCHfr=53n5qTC=7bA@mail.gmail.com> <24792.1302808448@redhat.com> <2477.1309342656@redhat.com>
In-Reply-To: <2477.1309342656@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29/2011 11:17 AM, David Howells wrote:
> Ric Wheeler<ricwheeler@gmail.com>  wrote:
>
>> I think that it has been a while since David reposted the refreshed patch set
>> for union mounts&  know that overlayfs has recent updates as well.
>>
>> Despite that, I have not seen a lot of feedback from reviewers or testers.
> The main problem I've got is that it causes lockdep to generate warnings when
> the top layer and one of the lower layers are of the same filesystem type.  The
> obvious way round this is to give each superblock its own i_mutex lock class
> rather than putting this in the file_system_type struct, but I'm not sure of
> the consequences (the two obvious problems are superblock transience and the
> fact that there may be so many more of them that it may explode lockdep).
>
> I've split out some of the VFS patches that we might be interested in taking
> upstream anyway.  They're currently sat on Al's plate for his consideration.
>
> I've been dealing with some of Al's issues with the unionmount patches, but I
> know he's got more - I just can't remember them all.
>
> David

After sitting down in person to dive into the lockdep issues with David over 
some very nice food (thanks David!), it does seem that this is really more of a 
lockdep issue and the way it is designed than a union mount issue.

Peter, Ingo, are either of you the right people to think about how to fix 
lockdep to handle stacked components (like ext4 used in union mounts stacked on 
top of another ext4 fs) where both layers will routinely lock to the same object?

Should we do a specific hack to work around this for union mounts or look for 
lockdep to change?

Thanks!

Ric


