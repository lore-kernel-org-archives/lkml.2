Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756353Ab0LJNKr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 08:10:47 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:50444 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756256Ab0LJNKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 08:10:45 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Guan Xuetao" <guanxuetao@mprc.pku.edu.cn>
Subject: Re: [PATCH] Unicore architecture patch review, part 2
Date: Fri, 10 Dec 2010 14:10:37 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
References: <201011301754.17829.arnd@arndb.de> <201012081353.44927.arnd@arndb.de> <017801cb9752$79a48a50$6ced9ef0$@mprc.pku.edu.cn>
In-Reply-To: <017801cb9752$79a48a50$6ced9ef0$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012101410.37537.arnd@arndb.de>
X-Provags-ID: V02:K0:kG3u9WL927wjf6rd76BGYN6fBWZIJHEOCJNUXadtY+z
 3clvRFTZXio5Z9l5aDuBR1Mt81oyBxBCf/pMkgSscvWi3up0EN
 YBv/m0vEOtxojeRxZSvjn7rHKS5quCVWGrvJEM43H8EDA4pFF+
 Q/XTBmDFHRvKe/jGxRpDNOsMypELfMW4jfF72Kmn8ma5XxI10x
 5KL9OfQebrOiukCJDN5qg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 09 December 2010, Guan Xuetao wrote:
> > Did I misunderstand you or did you make up your mind since then?
> > 
> We do define new 32-bit ABI work at present, and I will use generic unistd
> in new ABI.
> But existing machines must be maintained, so many codes need remain
> compatibility.

Ok, I see.

I would suggest a slightly different approach here as a compromise:

Make a patch that contains the difference between the backwards-compatible
and the new ABI. With this, you can run the backwards-compatible
ABI internally, but send our the new ABI for inclusion in the mainline
kernel. Send out the patch between the two along with the other
patches and make it clear that you still depend on this patch but that
it is not meant to be included.

Nothing stops you from using the old ABI as long as you want to, since
you can always put the patch on top of any upstream kernel when you
make a system image. It is quite normal to have a few patches required
to get a working kernel, although of course everyone tries to keep these
to a minimum.

It is probably also a good time for you to start learning about managing
patches for a submission. Everyone does this a bit differently, but
there two basic tools that most people use:

* Quilt is a simple tool that manages plain files with patches that
  apply on top of each other. You can easily modify patches in the middle,
  keep a patch description for each one and reorder the patches. It
  is mostly compatible with git-send-email for submitting the patches
  to the mailing list. Typically, you will want to use the quilt series
  in combination with a sourcecode management tool like git, in order to
  keep a history of what you have done.

* Git can do everything that quilt does, besides doing many other things
  as well. The most important sub-command to learn here is 'git rebase -i',
  which lets you reorder changeset and insert or delete changesets in the
  middle of a branch. It takes somewhat longer to be productive with git
  rebase than with quilt, but I personally find it much more reliable.

stgit is a tool that tries to combine the features of quilt and git, but
as far as I can tell, most users have moved on to just using git by itself.

	Arnd
