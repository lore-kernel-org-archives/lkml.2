Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300Ab1F2Lkn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 07:40:43 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:54312 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769Ab1F2Lkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 07:40:39 -0400
MIME-Version: 1.0
In-Reply-To: <4E0AF2BA.2040706@gmail.com>
References: <1302756608.2854.10.camel@perseus.themaw.net> <BANLkTini-g9XVOohKjwpZT-SGozcwx720A@mail.gmail.com>
 <4DA4B6A8.7030804@gmail.com> <BANLkTimsAE1ZAJhsSjnh3LqwsN9x0cLaXg@mail.gmail.com>
 <4DA5DCB8.3040101@gmail.com> <BANLkTineg2XYYOZAU9trrw=+-vH8McN_9w@mail.gmail.com>
 <4DA5F569.9020309@gmail.com> <BANLkTi=Z1CQm=u2Q1VCHfr=53n5qTC=7bA@mail.gmail.com>
 <24792.1302808448@redhat.com> <4E0AF2BA.2040706@gmail.com>
From: Michal Suchanek <hramrach@centrum.cz>
Date: Wed, 29 Jun 2011 13:40:19 +0200
X-Google-Sender-Auth: 6FiMDak1uZ_k8Z2Mc0gYjkcvYY4
Message-ID: <BANLkTikeurm0KbmVQKi_OkTs5ZbqOvmdcQ@mail.gmail.com>
Subject: Re: Union mount and overlayfs bake off?
To: Ric Wheeler <ricwheeler@gmail.com>
Cc: David Howells <dhowells@redhat.com>, Alexander Viro <aviro@redhat.com>,
        Ian Kent <ikent@redhat.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>,
        miklos@szeredi.hu, Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29 June 2011 11:39, Ric Wheeler <ricwheeler@gmail.com> wrote:
>
> I think that it has been a while since David reposted the refreshed patch
> set for union mounts & know that overlayfs has recent updates as well.
>
> Despite that, I have not seen a lot of feedback from reviewers or testers.
>

I can only attest that I can build working live CD on top of either
overlayfs or unionmount.

This is not a good metric for reliability because issues were found
with both solutions after the live CDs were working fine already.

However, it is an usability metric in that both solutions are from the
alpha stage in which crucial features were missing or broken way into
the beta stage  in which corner case issues are discovered but the
solution is generally working.

Somebody was running racer on top of overlayfs which uncovered some
problems with overlayfs itself and linux vfs in general. Unionmount
has supposedly its own testsuite but I have never seen that.

There are some issues with neither creating full emulation of a
traditional filesystem and the cost of hiding more effects of the
union from userspace to make the filesystem look more traditional.

With something touching VFS, however, it is important to decide how
(and if) these corner case issues should be resolved because they
could possibly affect unrelated parts of the system. Reviewing all
raised concerns is unfortunately taking quite some time, and then
addressing them in code will probably require more.

Thanks

Michal
