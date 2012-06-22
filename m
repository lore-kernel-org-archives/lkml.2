Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761735Ab2FVIuN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 04:50:13 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:50462 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761702Ab2FVIto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 04:49:44 -0400
Date: Fri, 22 Jun 2012 09:49:40 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        dhowells@redhat.com
Subject: Re: [PATCH 00/21] vfs: atomic open v6 (part 2)
Message-ID: <20120622084940.GB14083@ZenIV.linux.org.uk>
References: <1338901832-14049-1-git-send-email-miklos@szeredi.hu>
 <20120610034921.GB30000@ZenIV.linux.org.uk>
 <20120610111056.GD30000@ZenIV.linux.org.uk>
 <20120610175605.GE30000@ZenIV.linux.org.uk>
 <20120610222745.GG30000@ZenIV.linux.org.uk>
 <20120617203755.GA31478@infradead.org>
 <20120618115804.GA4048@infradead.org>
 <20120618131252.GA21931@infradead.org>
 <87aa00g0f6.fsf@tucsk.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87aa00g0f6.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2012 at 04:27:41PM +0200, Miklos Szeredi wrote:
> Here's fix against e8c30bb7 "->atomic_open() prototype change - pass int
> * instead of bool *"
> 
> Rename FILE_CREATE to FILE_CREATED because it conflicts with a define in
> fs/cifs/cifspdu.h

... and that leads to actual breakage in e.g. cifs_do_create(), since the macro
from cifspdu.h wins and we end up setting the wrong bit there.  Folded.
