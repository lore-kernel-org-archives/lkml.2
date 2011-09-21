Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751927Ab1IUFZn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 01:25:43 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:33523 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465Ab1IUFZl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 01:25:41 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=svA9syYi2VW8WjUw5Fmdp5V1toRmC2VQL6MasMQUDjw= c=1 sm=1
 a=irGJFI2oAs8A:10 a=BLceEmwcHowA:10 a=kj9zAlcOel0A:10
 a=k8hqzbHzjweV03hO1KKrVA==:17 a=1UFAje1gK6Lw1vHfmMEA:9 a=CjuIK1q_8ugA:10
 a=ivB-C1rZdGOxFSjN:21 a=o6-vQP7kb9al6tju:21 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Subject: Re: [PATCH] fallocate.2: add FALLOC_FL_PUNCH_HOLE flag definition
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <CAKgNAkhCptHn_UxReeZeSNaP0yNr+iWYd3fcxrD_PHohqQVxuQ@mail.gmail.com>
Date: Tue, 20 Sep 2011 23:25:40 -0600
Cc: Josef Bacik <josef@redhat.com>, Eric Gouriou <egouriou@google.com>,
        inux-man@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Lucian Adrian Grijincu <lucian.grijincu@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Dave Chinner <dchinner@redhat.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <804BB4B7-E19F-41EE-81A3-25D4389B54B9@dilger.ca>
References: <1289840876-3546-1-git-send-email-josef@redhat.com> <CAKgNAkj-jPR-9hyuxrJ74uu3Kdv9bATrfCUedoty4dJOCh2GcA@mail.gmail.com> <CAKgNAkhCptHn_UxReeZeSNaP0yNr+iWYd3fcxrD_PHohqQVxuQ@mail.gmail.com>
To: mtk.manpages@gmail.com
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-09-20, at 10:11 PM, Michael Kerrisk wrote:
> Thanks for this patch. As noted in another mail, Lucian also sent a
> patch for FALLOC_FL_PUNCH_HOLE, and I applied his patch first, and
> then added some pieces from yours, as well as some of my own edits.
> 
> However, the addition of a second class of operation to the man page
> made it clear that some significant restructuring of the page is
> required. So I substantially reworked the page, including the
> preexisting material on the default "file allocation" operation (Dave
> C please note).
> 
> .TP
> .B EINVAL
> .I offset
> was less than 0, or
> .I len
> was less than or equal to 0.

I wasn't sure if this is a bug in the manpage or actually how it is done
in the kernel, but it seems this is a kernel implementation issue...

Does it make sense to return an error if len == 0?  That just adds extra
complexity on the part of the application, and doesn't reduce complexity
in the kernel (whether the kernel checks for len == 0 and returns 0 or
-EINVAL is not any different).  read() and write() and malloc() all allow
a length of zero to succeed, since applications may compute this length
and sometimes it is zero.

Cheers, Andreas





