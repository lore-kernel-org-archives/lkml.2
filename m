Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847Ab2IRRZX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 13:25:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19595 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751890Ab2IRRZW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 13:25:22 -0400
Date: Tue, 18 Sep 2012 19:27:20 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@hack.frob.com>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Amerigo Wang <amwang@redhat.com>,
        "Jonathan M. Foote" <jmfoote@cert.org>,
        Pedro Alves <palves@redhat.com>
Subject: Re: [PATCH -mm v2] coredump: extend core dump note section to
	contain file names of mapped files
Message-ID: <20120918172720.GA26606@redhat.com>
References: <1347980129-1510-1-git-send-email-vda.linux@googlemail.com> <20120918165819.583252C0A4@topped-with-meat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120918165819.583252C0A4@topped-with-meat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/18, Roland McGrath wrote:
>
> It's doubtful that rolling your own single loop actually performs better
> than just calling strlen and memcpy.



This is needed to advance 'name' if d_path() fails with !ENAMETOOLONG.
Probably needs a comment.

Or perhaps 'filename = ""' case can handle this case itself. In this
case we do not even need strlen(), remaining = name - filename.

Oleg.

