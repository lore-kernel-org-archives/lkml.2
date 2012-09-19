Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755211Ab2ISLsW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 07:48:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55523 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752014Ab2ISLsV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 07:48:21 -0400
Date: Wed, 19 Sep 2012 13:50:16 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@hack.frob.com>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Amerigo Wang <amwang@redhat.com>,
        "Jonathan M. Foote" <jmfoote@cert.org>,
        Pedro Alves <palves@redhat.com>
Subject: Re: [PATCH -mm v2] coredump: extend core dump note section to
	contain file names of mapped files
Message-ID: <20120919115016.GA9437@redhat.com>
References: <1347980129-1510-1-git-send-email-vda.linux@googlemail.com> <20120918165819.583252C0A4@topped-with-meat.com> <20120918172720.GA26606@redhat.com> <20120918174729.GA27841@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120918174729.GA27841@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/18, Oleg Nesterov wrote:
>
> Hmm. And I just noticed that 'filename = ""' case does not verify
> there is a room to write a single '\0' :/
> 
> So, afaics you also need
> 
> 	- if (-ENAMETOOLONG)
> 	+ if (-ENAMETOOLONG || !remaining)

No, please ignore.

d_path() always starts with prepend("\0", 1), it should always
return ENAMETOOLONG if !remaining.

Oleg.

