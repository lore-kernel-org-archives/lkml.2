Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932375Ab1COQfZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 12:35:25 -0400
Received: from shutemov.name ([188.40.19.243]:51353 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932351Ab1COQfY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 12:35:24 -0400
Date: Tue, 15 Mar 2011 18:35:23 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Phil Carmody <ext-phil.2.carmody@nokia.com>
Cc: menage@google.com, lizf@cn.fujitsu.com,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH 2/2] cgroup: if you list_empty() a head then don't
 list_del() it
Message-ID: <20110315163523.GB12170@shutemov.name>
References: <1300194523-19325-1-git-send-email-ext-phil.2.carmody@nokia.com>
 <1300194523-19325-2-git-send-email-ext-phil.2.carmody@nokia.com>
 <1300194523-19325-3-git-send-email-ext-phil.2.carmody@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300194523-19325-3-git-send-email-ext-phil.2.carmody@nokia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 15, 2011 at 03:08:43PM +0200, Phil Carmody wrote:
> list_del() leaves poison in the prev and next pointers. The next
> list_empty() will compare those poisons, and say the list isn't empty.
> Any list operations that assume the node is on a list because of such a
> check will be fooled into dereferencing poison. One needs to INIT the
> node after the del, and fortunately there's already a wrapper for that -
> list_del_init().
> 
> Some of the dels are followed by deallocations, so can be ignored,
> and one can be merged with an add to make a move. Apart from that, I
> erred on the side of caution in making nodes list_empty()-queriable.
> 
> Signed-off-by: Phil Carmody <ext-phil.2.carmody@nokia.com>

Acked-by: Kirill A. Shutemov <kirill@shutemov.name>

-- 
 Kirill A. Shutemov
