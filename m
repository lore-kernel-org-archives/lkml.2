Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760918Ab2ILRiU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 13:38:20 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:38035 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760594Ab2ILRiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 13:38:18 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Namjae Jeon <linkinjeon@gmail.com>,
        "Steven J. Magnani" <steve@digidescorp.com>,
        Al Viro <viro@zeniv.linux.org.uk>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: Re: [PATCH v2 1/5] fat: allocate persistent inode numbers
References: <87k3w3ph8d.fsf@devron.myhome.or.jp>
	<CAKYAXd-k4yVV3h8k0kcFMsyGnOVckYRjXi8fkZrLtjuWVi7Eqw@mail.gmail.com>
	<87har6kmfx.fsf@devron.myhome.or.jp>
	<CAKYAXd-ZNmCbHqmFX=YXti7XprhD_Hgvmnd=TnKPVoFc88Sc4A@mail.gmail.com>
	<87oblc4u6f.fsf@devron.myhome.or.jp>
	<CAKYAXd-gO5Pw=0unjB=YQJhu6W=g7VpZYnmHXkve-k8_4VjpgA@mail.gmail.com>
	<871ui84l4l.fsf@devron.myhome.or.jp>
	<CAKYAXd89CKZa9nV3pBiFgcpGsYzX1-iCB+UJ8bBvst88GnB4mg@mail.gmail.com>
	<20120912143227.GE3009@fieldses.org>
	<87vcfjfa14.fsf@devron.myhome.or.jp>
	<20120912171128.GG3009@fieldses.org>
Date: Thu, 13 Sep 2012 02:38:11 +0900
In-Reply-To: <20120912171128.GG3009@fieldses.org> (J. Bruce Fields's message
	of "Wed, 12 Sep 2012 13:11:28 -0400")
Message-ID: <87r4q7f8fw.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"J. Bruce Fields" <bfields@fieldses.org> writes:

>> On other view (as server side solution), we are thinking there is
>> possible to make the stable filehandle on FAT if we disabled some
>> operations (e.g. rename(), unlink()) which change inode location in FAT.
>> 
>> Yes, it would be stable, but supporting limited operations.
>> 
>> This is server side solution, and we comparing it with client solution.
>
> Is that useful to anyone?

Good question. I'm not sure though, Namjae is asking. And I was asked
about stable read-only export in past.

>> >> LOOKUP return NFS FH->[inode number changed at NFS Server] ->
>> >> But we still use old NFS FH returned from LOOKUP for any file
>> >> operation(write,read,etc..)
>> >> -> ESTALE will be returned.
>> 
>> Yes.  And I'm expecting as client side solution,
>> 
>> -> ESTALE will be returned -> discard old FH -> restart from LOOKUP ->
>> make cached inode -> use returned new FH.
>> 
>> Yeah, I know this is unstable (there is no perfect solution for now),
>
> You may end up with a totally different file, of course:
>
> 	client:			server:
>
> 	open "/foo/bar"
> 				rename "/foo/baz"->"/foo/bar"
> 	write to file
>
> And now we're writing to the file that was originally named /foo/baz
> when we should have gotten ESTALE.

I see. So, client can't solve the ESTALE if inode cache was evicted,
right? (without application changes)
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
